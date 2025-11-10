# BC27 MCP Server

Model Context Protocol server for Business Central 27 development integration.

## Features

### 1. Event Discovery
Search BC27 event catalog for relevant events based on table, operation, and module:

```python
# Claude automatically calls this when you ask:
# "What events are available for Sales Header posting?"

search_bc_events({
    "table_name": "Sales Header",
    "operation": "posting",
    "module": "sales"
})
```

**Returns:**
- Event names and signatures
- When to use each event
- Code examples from BC27 documentation

### 2. Table Schema Queries
Get field information before extending tables:

```python
# Claude calls this for:
# "What fields are in the Sales Header table?"

get_table_schema({
    "table_name": "Sales Header"
})
```

**Returns:**
- Field names and types
- Keys and relations
- Field properties

### 3. Object ID Availability
Check if object IDs are free before using them:

```python
# Claude calls this for:
# "Are IDs 77100-77105 available?"

check_id_availability({
    "start_id": 77100,
    "count": 6
})
```

**Returns:**
- Status for each ID (available/reserved/in use)
- Warnings for conflicting IDs

### 4. Module Information
Get detailed BC27 module information:

```python
# Claude calls this for:
# "Tell me about the Warehouse Management module"

get_module_info({
    "module_name": "Warehouse Management"
})
```

**Returns:**
- Module features and capabilities
- Dependencies on other modules
- Integration points

### 5. Extension Point Recommendations
Find recommended extension points for features:

```python
# Claude calls this for:
# "How should I add commission calculation to sales?"

find_extension_points({
    "feature_description": "add commission calculation to sales invoices"
})
```

**Returns:**
- Recommended events to subscribe to
- Tables to extend
- Pages to modify
- ESC-compliant patterns

---

## Installation

### 1. Install Python dependencies

```bash
cd .claude/mcp-servers/bc27-server
pip install -r requirements.txt
```

### 2. Configure Claude Code

Add to your Claude Code MCP configuration (`~/.claude/mcp.json` or project `.claude/mcp.json`):

```json
{
  "mcpServers": {
    "bc27-integration": {
      "command": "python",
      "args": [
        "/full/path/to/ProjectTemplate/.claude/mcp-servers/bc27-server/server.py"
      ],
      "env": {
        "BC_DATABASE": "Server=localhost;Database=BC270;Integrated Security=true",
        "BC_WEB_SERVICE_URL": "https://localhost:7048/BC270/ODataV4"
      }
    }
  }
}
```

### 3. Test the server

```bash
# Start server manually
python server.py

# Or test with Claude Code
# Server will start automatically when Claude Code launches
```

---

## Usage Examples

### Example 1: Event Discovery

**User:** "What events should I use to add custom logic when posting sales invoices?"

**Claude (internally):**
1. Calls `search_bc_events({"table_name": "Sales Header", "operation": "posting", "module": "sales"})`
2. Receives BC27 event list with signatures
3. Responds to user with recommendations

**User sees:**
> "For posting sales invoices, I recommend these events:
>
> 1. **OnBeforePostSalesDoc** - Use this to validate or modify data before posting
> 2. **OnAfterPostSalesDoc** - Use this to perform actions after successful posting
> 3. **OnAfterCheckSalesDoc** - Use this to add validation checks
>
> Here are the event signatures..."

### Example 2: Table Extension Planning

**User:** "I want to add a Commission Percentage field to Sales Header. What do I need to know?"

**Claude (internally):**
1. Calls `get_table_schema({"table_name": "Sales Header"})`
2. Receives field list and types
3. Responds with extension guidance

**User sees:**
> "To add Commission Percentage to Sales Header:
>
> 1. Create a table extension:
>    - Base table: Sales Header (table 36)
>    - Add field: Commission Percentage (Decimal)
>    - Validation: 0-100%
>
> 2. Existing related fields:
>    - Amount Including VAT (Decimal)
>    - Sell-to Customer No. (Code[20])
>
> 3. Recommended validation event:
>    - OnBeforeValidate on your field..."

### Example 3: Production Deployment Prep

**User:** "I'm ready to deploy. Check if object IDs 50100-50110 are available."

**Claude (internally):**
1. Calls `check_id_availability({"start_id": 50100, "count": 11})`
2. Receives availability status
3. Responds with deployment guidance

**User sees:**
> "Object ID availability (50100-50110):
>
> ✅ Available: 50100-50105 (6 IDs)
> ❌ In use: 50106 (Table "Custom Sales Data")
> ✅ Available: 50107-50110 (4 IDs)
>
> Recommendation: Use 50100-50105 for your 6 objects. Skip 50106."

---

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│ Claude Code                                             │
│  ├─ User: "What events for Sales Header posting?"      │
│  └─ MCP Client → calls bc27-integration server         │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│ BC27 MCP Server (this server)                           │
│  ├─ Receives: search_bc_events request                  │
│  ├─ Searches: BC27/BC27_EVENT_CATALOG.md                │
│  ├─ Searches: BC27/events/BC27_EVENTS_SALES.md          │
│  └─ Returns: Event list with signatures                 │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│ Data Sources                                            │
│  ├─ BC27/BC27_EVENT_CATALOG.md (core events)            │
│  ├─ BC27/events/*.md (module events)                    │
│  ├─ BC27/BC27_MODULES_OVERVIEW.md (module info)         │
│  └─ (Future: BC database, web services)                 │
└─────────────────────────────────────────────────────────┘
```

---

## Configuration

### Environment Variables

Set in `config.json` or system environment:

| Variable | Description | Example |
|----------|-------------|---------|
| `BC_DATABASE` | BC database connection string | `Server=localhost;Database=BC270;Integrated Security=true` |
| `BC_WEB_SERVICE_URL` | BC OData web service URL | `https://localhost:7048/BC270/ODataV4` |
| `OBJECT_NINJA_PATH` | Object Ninja executable path | `C:/Tools/ObjectNinja/ObjectNinja.exe` |
| `LINTERCOP_PATH` | LinterCop DLL path | `C:/Tools/LinterCop/LinterCop.dll` |

### Current Implementation Status

| Feature | Status | Data Source |
|---------|--------|-------------|
| Event discovery | ✅ Implemented | BC27 markdown docs |
| Table schema | ⚠️ Simulated | BC27 docs (needs BC database connection) |
| Object ID availability | ⚠️ Simulated | Needs BC database connection |
| Module info | ✅ Implemented | BC27_MODULES_OVERVIEW.md |
| Extension points | ✅ Implemented | Pattern analysis |

**Next Steps for Full Implementation:**
1. Add BC database connection (pyodbc)
2. Add BC web services integration (requests + OAuth)
3. Add Object Ninja CLI integration
4. Add LinterCop integration

---

## Development

### Adding New Tools

1. Add tool definition in `_register_handlers()`:

```python
Tool(
    name="your_new_tool",
    description="What it does",
    inputSchema={
        "type": "object",
        "properties": {
            "param": {"type": "string", "description": "Description"}
        },
        "required": ["param"]
    }
)
```

2. Add tool implementation:

```python
def _your_new_tool(self, param: str) -> str:
    """Implementation"""
    # Your code here
    return result
```

3. Add tool call handler:

```python
elif name == "your_new_tool":
    result = self._your_new_tool(arguments["param"])
```

### Testing

```bash
# Run server in test mode
python server.py

# Or use MCP inspector (if available)
mcp-inspector bc27-integration
```

---

## Troubleshooting

### Server won't start

**Check:**
1. MCP SDK installed: `pip install mcp`
2. Python version ≥ 3.8
3. BC27 folder exists in project root

### Events not found

**Check:**
1. Table name spelling (use spaces: "Sales Header" not "SalesHeader")
2. BC27 documentation files exist
3. Search in BC27_EVENT_INDEX.md for broader search

### Database connection fails

**Check:**
1. BC_DATABASE environment variable set
2. BC service running
3. Database permissions
4. pyodbc installed (if using database features)

---

## Future Enhancements

- [ ] Real BC database integration (pyodbc)
- [ ] BC web services integration (OData v4)
- [ ] Object Ninja CLI integration
- [ ] LinterCop integration
- [ ] Symbol file parsing (.app files)
- [ ] Caching layer for frequently accessed data
- [ ] Real-time BC environment monitoring

---

## Contributing

Contributions welcome! Focus areas:

1. BC database query implementations
2. Web services integration
3. Additional tool definitions
4. Performance optimizations
5. Error handling improvements

---

## License

Same as parent project (BC27 Development Template)

---

## Support

For issues:
1. Check this README
2. Review `.agent/research/awesomeclaude-improvements.md`
3. Check MCP SDK docs: https://modelcontextprotocol.io/

---

**Version:** 1.0.0
**Last Updated:** 2025-11-10
**Status:** Beta (simulated database features)
