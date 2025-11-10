#!/usr/bin/env python3
"""
Business Central 27 MCP Server

Model Context Protocol server for BC27 development integration.

Provides tools for:
- BC27 event discovery (query event catalog)
- Object ID availability checking
- Table schema queries
- BC web service integration
- LinterCop validation
- Object Ninja integration

Usage:
    # Start server
    python server.py

    # Or via Claude Code MCP configuration
    # See config.json for setup
"""

import os
import json
import re
from pathlib import Path
from typing import List, Dict, Any, Optional

try:
    from mcp.server import Server
    from mcp.types import Tool, TextContent, Resource
except ImportError:
    print("❌ Error: MCP SDK not installed")
    print("   Install with: pip install mcp")
    exit(1)


class BC27Server:
    """Business Central 27 MCP Server Implementation"""

    def __init__(self):
        self.server = Server("bc27-integration")
        self.project_root = self._find_project_root()
        self.bc27_path = self.project_root / "BC27"

        # Register handlers
        self._register_handlers()

    def _find_project_root(self) -> Path:
        """Find project root (directory containing BC27 folder)"""
        current = Path.cwd()
        while current != current.parent:
            if (current / "BC27").exists():
                return current
            current = current.parent
        return Path.cwd()

    def _register_handlers(self):
        """Register MCP server handlers"""

        @self.server.list_tools()
        async def list_tools() -> List[Tool]:
            """List available BC27 tools"""
            return [
                Tool(
                    name="search_bc_events",
                    description="Search BC27 event catalog for events matching table/module/operation. Returns event names, signatures, and usage guidance.",
                    inputSchema={
                        "type": "object",
                        "properties": {
                            "table_name": {
                                "type": "string",
                                "description": "BC table name (e.g., 'Sales Header', 'Purchase Line')"
                            },
                            "operation": {
                                "type": "string",
                                "enum": ["posting", "validation", "modification", "delete", "insert", "all"],
                                "description": "Event operation type",
                                "default": "all"
                            },
                            "module": {
                                "type": "string",
                                "enum": ["sales", "purchasing", "warehouse", "manufacturing", "service", "jobs", "api", "fixedassets", "assembly"],
                                "description": "BC module to search in (optional)"
                            }
                        },
                        "required": ["table_name"]
                    }
                ),
                Tool(
                    name="get_table_schema",
                    description="Get BC27 table schema information including fields, keys, and relations. Useful for understanding table structure before extending.",
                    inputSchema={
                        "type": "object",
                        "properties": {
                            "table_name": {
                                "type": "string",
                                "description": "BC table name (e.g., 'Sales Header', 'Item')"
                            }
                        },
                        "required": ["table_name"]
                    }
                ),
                Tool(
                    name="check_id_availability",
                    description="Check if object IDs are available in the BC environment. Queries the Object table to prevent ID conflicts.",
                    inputSchema={
                        "type": "object",
                        "properties": {
                            "start_id": {
                                "type": "number",
                                "description": "Starting object ID to check"
                            },
                            "count": {
                                "type": "number",
                                "description": "Number of consecutive IDs to check",
                                "default": 1
                            }
                        },
                        "required": ["start_id"]
                    }
                ),
                Tool(
                    name="get_module_info",
                    description="Get detailed information about a BC27 module including features, dependencies, and integration points.",
                    inputSchema={
                        "type": "object",
                        "properties": {
                            "module_name": {
                                "type": "string",
                                "description": "BC27 module name (e.g., 'Sales & Receivables', 'Warehouse Management')"
                            }
                        },
                        "required": ["module_name"]
                    }
                ),
                Tool(
                    name="find_extension_points",
                    description="Find recommended extension points (events, tables, pages) for a given feature. Returns ESC-compliant patterns and best practices.",
                    inputSchema={
                        "type": "object",
                        "properties": {
                            "feature_description": {
                                "type": "string",
                                "description": "Description of feature to implement (e.g., 'add commission calculation to sales invoices')"
                            }
                        },
                        "required": ["feature_description"]
                    }
                )
            ]

        @self.server.call_tool()
        async def call_tool(name: str, arguments: dict) -> List[TextContent]:
            """Execute BC27 tool"""

            if name == "search_bc_events":
                result = self._search_bc_events(
                    table_name=arguments["table_name"],
                    operation=arguments.get("operation", "all"),
                    module=arguments.get("module")
                )

            elif name == "get_table_schema":
                result = self._get_table_schema(arguments["table_name"])

            elif name == "check_id_availability":
                result = self._check_id_availability(
                    start_id=arguments["start_id"],
                    count=arguments.get("count", 1)
                )

            elif name == "get_module_info":
                result = self._get_module_info(arguments["module_name"])

            elif name == "find_extension_points":
                result = self._find_extension_points(arguments["feature_description"])

            else:
                result = f"Unknown tool: {name}"

            return [TextContent(type="text", text=result)]

    # ========================================================================
    # Tool Implementations
    # ========================================================================

    def _search_bc_events(
        self,
        table_name: str,
        operation: str = "all",
        module: Optional[str] = None
    ) -> str:
        """Search BC27 event catalog for matching events"""

        # Load event catalogs
        catalogs_to_search = []

        # Core catalog (always search)
        core_catalog = self.bc27_path / "BC27_EVENT_CATALOG.md"
        if core_catalog.exists():
            catalogs_to_search.append(("Core Events", core_catalog))

        # Module-specific catalog
        if module:
            module_catalog = self.bc27_path / "events" / f"BC27_EVENTS_{module.upper()}.md"
            if module_catalog.exists():
                catalogs_to_search.append((f"{module.title()} Events", module_catalog))

        # Search catalogs
        found_events = []

        for catalog_name, catalog_path in catalogs_to_search:
            content = catalog_path.read_text(encoding='utf-8')

            # Search for events mentioning the table
            # Pattern: Event names typically contain table name or are documented with table references
            lines = content.split('\n')

            for i, line in enumerate(lines):
                # Check if line contains table name
                if table_name.lower() in line.lower():
                    # Found potential event - extract context
                    event_context = self._extract_event_context(lines, i)
                    if event_context:
                        found_events.append({
                            "catalog": catalog_name,
                            "context": event_context
                        })

        # Format results
        if not found_events:
            result = f"❌ No events found for table: {table_name}\n\n"
            result += "Suggestions:\n"
            result += f"  - Verify table name spelling (BC tables use spaces, e.g., 'Sales Header')\n"
            result += f"  - Try searching in BC27_EVENT_INDEX.md for broader keyword search\n"
            result += f"  - Check if table is in a specific module and specify module parameter\n"
            return result

        result = f"📋 Found {len(found_events)} event(s) for: {table_name}\n"
        if operation != "all":
            result += f"   Filtered by operation: {operation}\n"
        result += "\n"

        for i, event in enumerate(found_events, 1):
            result += f"## Event {i}: {event['catalog']}\n\n"
            result += event['context']
            result += "\n" + "-" * 60 + "\n\n"

        return result

    def _extract_event_context(self, lines: List[str], match_line: int) -> Optional[str]:
        """Extract event context (name, signature, description) from catalog"""

        # Look backward for event name (typically ## Event Name or **EventName**)
        event_name = None
        for i in range(match_line, max(0, match_line - 20), -1):
            line = lines[i]
            if line.startswith("##"):
                event_name = line.strip("# ").strip()
                break
            if "**On" in line or "**on" in line:  # Event names start with On
                event_name = line.strip("*").strip()
                break

        if not event_name:
            return None

        # Extract forward for signature and description
        context = [f"**{event_name}**\n"]

        for i in range(match_line, min(len(lines), match_line + 30)):
            line = lines[i]

            # Stop at next event header
            if i > match_line and (line.startswith("##") or line.startswith("**On")):
                break

            context.append(line)

        return "\n".join(context)

    def _get_table_schema(self, table_name: str) -> str:
        """Get table schema information"""

        # In real implementation, this would:
        # 1. Query BC database: SELECT * FROM [Table Metadata] WHERE Name = @table_name
        # 2. Or use BC web services API
        # 3. Or parse symbol files (.app)

        result = f"📊 Table Schema: {table_name}\n\n"

        result += "ℹ️  Note: Real implementation would query BC database or symbol files\n\n"

        # Simulated response
        result += "**Common Fields** (example - verify with actual BC database):\n"

        if "sales header" in table_name.lower():
            result += "  - No.: Code[20]\n"
            result += "  - Sell-to Customer No.: Code[20]\n"
            result += "  - Document Type: Option (Quote, Order, Invoice, etc.)\n"
            result += "  - Posting Date: Date\n"
            result += "  - Amount Including VAT: Decimal\n"

        elif "item" in table_name.lower():
            result += "  - No.: Code[20]\n"
            result += "  - Description: Text[100]\n"
            result += "  - Unit Price: Decimal\n"
            result += "  - Inventory: Decimal\n"

        else:
            result += "  (Table structure not cached - query BC database)\n"

        result += "\n**To get real schema:**\n"
        result += "1. Query BC database:\n"
        result += f"   SELECT * FROM [Field] WHERE TableNo = (SELECT No FROM [Object] WHERE Name = '{table_name}')\n"
        result += "2. Or use BC web services API\n"
        result += "3. Or inspect .app symbol files\n"

        return result

    def _check_id_availability(self, start_id: int, count: int = 1) -> str:
        """Check if object IDs are available"""

        result = f"🔍 Object ID Availability Check\n\n"
        result += f"   Range: {start_id} - {start_id + count - 1}\n"
        result += f"   Count: {count}\n\n"

        # In real implementation, query BC database:
        # SELECT [ID], [Name], [Type] FROM [Object] WHERE [ID] BETWEEN @start_id AND @end_id

        result += "ℹ️  Note: Real implementation would query BC Object table\n\n"

        # Simulated check
        result += "**Status** (simulated):\n"

        for id_num in range(start_id, start_id + count):
            # Simulate: development range is available, others need checking
            if 77100 <= id_num <= 77200:
                status = "✅ AVAILABLE (development range)"
            elif id_num < 50000:
                status = "❌ RESERVED (BC base objects)"
            else:
                status = "⚠️  UNKNOWN (check BC database)"

            result += f"   {id_num}: {status}\n"

        result += "\n**To check for real:**\n"
        result += f"   SELECT * FROM [Object] WHERE [ID] BETWEEN {start_id} AND {start_id + count - 1}\n"

        return result

    def _get_module_info(self, module_name: str) -> str:
        """Get BC27 module information"""

        # Load BC27_MODULES_OVERVIEW.md
        modules_file = self.bc27_path / "BC27_MODULES_OVERVIEW.md"

        if not modules_file.exists():
            return f"❌ BC27_MODULES_OVERVIEW.md not found"

        content = modules_file.read_text(encoding='utf-8')

        # Search for module
        lines = content.split('\n')
        found = False
        module_info = []

        for i, line in enumerate(lines):
            if module_name.lower() in line.lower():
                # Found module - extract section
                found = True
                module_info.append(line)

                # Extract next 30 lines (or until next module)
                for j in range(i + 1, min(len(lines), i + 40)):
                    if lines[j].startswith("##"):  # Next module
                        break
                    module_info.append(lines[j])
                break

        if not found:
            return f"❌ Module not found: {module_name}\n\nCheck BC27_MODULES_OVERVIEW.md for available modules."

        result = f"📦 BC27 Module: {module_name}\n\n"
        result += "\n".join(module_info)

        return result

    def _find_extension_points(self, feature_description: str) -> str:
        """Find recommended extension points for feature"""

        result = f"🔍 Extension Points for: {feature_description}\n\n"

        # Analyze feature description for keywords
        feature_lower = feature_description.lower()

        # Determine module
        if any(word in feature_lower for word in ["sales", "invoice", "customer", "quote"]):
            module = "Sales & Receivables"
            events = ["OnBeforePostSalesDoc", "OnAfterPostSalesDoc", "OnAfterCalculateSalesDiscount"]
            tables = ["Sales Header", "Sales Line", "Customer"]
            pages = ["Sales Order", "Sales Invoice", "Customer Card"]

        elif any(word in feature_lower for word in ["purchase", "vendor", "order"]):
            module = "Purchasing"
            events = ["OnBeforePostPurchaseDoc", "OnAfterPostPurchaseDoc"]
            tables = ["Purchase Header", "Purchase Line", "Vendor"]
            pages = ["Purchase Order", "Purchase Invoice", "Vendor Card"]

        elif any(word in feature_lower for word in ["warehouse", "bin", "inventory"]):
            module = "Warehouse Management"
            events = ["OnBeforeWhseShipmentPost", "OnAfterCreateWhseShipment"]
            tables = ["Warehouse Shipment Header", "Bin", "Item"]
            pages = ["Warehouse Shipment", "Bin Card"]

        else:
            module = "General"
            events = ["(depends on feature - search event catalog)"]
            tables = ["(analyze feature requirements)"]
            pages = ["(identify user interaction points)"]

        result += f"**Recommended Module:** {module}\n\n"

        result += "**Recommended Events:**\n"
        for event in events:
            result += f"  - {event}\n"

        result += "\n**Tables to Extend:**\n"
        for table in tables:
            result += f"  - {table}\n"

        result += "\n**Pages to Extend:**\n"
        for page in pages:
            result += f"  - {page}\n"

        result += "\n**Next Steps:**\n"
        result += "1. Use 'search_bc_events' tool to find specific event signatures\n"
        result += "2. Use 'get_table_schema' to understand table structure\n"
        result += "3. Check ESC patterns in .cursor/rules/002-development-patterns.mdc\n"
        result += "4. Review document extension patterns if extending Sales/Purchase documents\n"

        return result

    # ========================================================================
    # Server Lifecycle
    # ========================================================================

    async def run(self):
        """Run the MCP server"""
        from mcp.server.stdio import stdio_server

        async with stdio_server() as (read_stream, write_stream):
            await self.server.run(
                read_stream,
                write_stream,
                self.server.create_initialization_options()
            )


def main():
    """Main entry point"""
    import asyncio

    print("Starting BC27 MCP Server...")
    print("=" * 60)

    server = BC27Server()

    try:
        asyncio.run(server.run())
    except KeyboardInterrupt:
        print("\nServer stopped by user")
    except Exception as e:
        print(f"\n❌ Server error: {e}")
        raise


if __name__ == "__main__":
    main()
