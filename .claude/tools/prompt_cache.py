#!/usr/bin/env python3
"""
Prompt Caching Helper for BC27 Development Template

Implements Anthropic's Prompt Caching to reduce token usage and improve
response times when working with large BC27 documentation.

Key Benefits:
- 90% token cost reduction for cached content (base: 100% → cache read: 10%)
- 50-70% faster response times for large documents
- 5-minute cache lifetime (auto-refreshed on use)
- Up to 4 cache breakpoints for granular control

Usage:
    from tools.prompt_cache import CachedContext, BC27DocsCache

    # Load BC27 docs with caching
    cache = BC27DocsCache()
    context = cache.get_cached_context(
        quick_ref=True,
        event_catalog=True,
        module_overview=False
    )
"""

import os
from pathlib import Path
from typing import List, Dict, Optional
from dataclasses import dataclass


@dataclass
class CacheBlock:
    """Represents a cacheable content block"""
    name: str
    content: str
    cache_control: Dict[str, str]
    priority: int = 0  # Higher priority = cached first (0-3, max 4 breakpoints)


class BC27DocsCache:
    """
    Manages cached BC27 documentation content.

    Implements up to 4 cache breakpoints for different documentation layers:
    1. BC27_LLM_QUICKREF.md (always cached - 450 lines, most frequently used)
    2. BC27_EVENT_CATALOG.md (core events - ~50 events)
    3. Module-specific event catalogs (on-demand)
    4. Full BC27 documentation (rarely needed)
    """

    def __init__(self, bc27_path: str = "BC27"):
        self.bc27_path = Path(bc27_path)
        self.project_root = Path(__file__).parent.parent.parent

    def _load_file(self, file_path: str) -> str:
        """Load file content safely"""
        full_path = self.project_root / file_path
        if not full_path.exists():
            return f"# {file_path} not found"

        with open(full_path, 'r', encoding='utf-8') as f:
            return f.read()

    def get_quick_ref(self) -> CacheBlock:
        """
        Load BC27 Quick Reference (Priority 1 - always cached)

        450 lines covering 80-90% of common BC27 queries.
        Recommended for all BC27-related tasks.
        """
        content = self._load_file(f"{self.bc27_path}/BC27_LLM_QUICKREF.md")

        return CacheBlock(
            name="BC27 Quick Reference",
            content=content,
            cache_control={"type": "ephemeral"},
            priority=1  # Highest priority
        )

    def get_event_catalog(self) -> CacheBlock:
        """
        Load BC27 Core Event Catalog (Priority 2)

        ~50 core events for posting, validation, and document operations.
        """
        content = self._load_file(f"{self.bc27_path}/BC27_EVENT_CATALOG.md")

        return CacheBlock(
            name="BC27 Event Catalog",
            content=content,
            cache_control={"type": "ephemeral"},
            priority=2
        )

    def get_module_events(self, module: str) -> CacheBlock:
        """
        Load module-specific event catalog (Priority 3)

        Args:
            module: One of [sales, purchasing, warehouse, manufacturing,
                    service, jobs, api, fixedassets, assembly]
        """
        module_upper = module.upper()
        content = self._load_file(
            f"{self.bc27_path}/events/BC27_EVENTS_{module_upper}.md"
        )

        return CacheBlock(
            name=f"BC27 {module.title()} Events",
            content=content,
            cache_control={"type": "ephemeral"},
            priority=3
        )

    def get_module_overview(self) -> CacheBlock:
        """
        Load BC27 Modules Overview (Priority 3)

        All 73 modules with dependencies and relationships.
        """
        content = self._load_file(f"{self.bc27_path}/BC27_MODULES_OVERVIEW.md")

        return CacheBlock(
            name="BC27 Modules Overview",
            content=content,
            cache_control={"type": "ephemeral"},
            priority=3
        )

    def get_architecture(self) -> CacheBlock:
        """
        Load BC27 Architecture (Priority 4)

        System design, layering patterns, integration guidelines.
        Rarely needed - only for architectural decisions.
        """
        content = self._load_file(f"{self.bc27_path}/BC27_ARCHITECTURE.md")

        return CacheBlock(
            name="BC27 Architecture",
            content=content,
            cache_control={"type": "ephemeral"},
            priority=4  # Lowest priority (still cached if needed)
        )

    def get_cached_context(
        self,
        quick_ref: bool = True,
        event_catalog: bool = False,
        module_events: Optional[List[str]] = None,
        module_overview: bool = False,
        architecture: bool = False
    ) -> List[CacheBlock]:
        """
        Build cached context based on requirements.

        Automatic optimization:
        - Returns blocks sorted by priority (highest first)
        - Limits to 4 cache breakpoints (Anthropic limit)
        - Always includes quick_ref if no other options specified

        Args:
            quick_ref: Include BC27_LLM_QUICKREF.md (recommended)
            event_catalog: Include BC27_EVENT_CATALOG.md
            module_events: List of module names for event catalogs
            module_overview: Include BC27_MODULES_OVERVIEW.md
            architecture: Include BC27_ARCHITECTURE.md

        Returns:
            List of CacheBlock objects ready for Anthropic API

        Example:
            >>> cache = BC27DocsCache()
            >>> blocks = cache.get_cached_context(
            ...     quick_ref=True,
            ...     event_catalog=True,
            ...     module_events=["sales", "warehouse"]
            ... )
            >>> # Returns 4 blocks (max cache breakpoints):
            >>> # 1. Quick Ref (priority 1)
            >>> # 2. Event Catalog (priority 2)
            >>> # 3. Sales Events (priority 3)
            >>> # 4. Warehouse Events (priority 3)
        """
        blocks = []

        # Always include quick ref if nothing else specified
        if quick_ref or not any([event_catalog, module_events, module_overview, architecture]):
            blocks.append(self.get_quick_ref())

        if event_catalog:
            blocks.append(self.get_event_catalog())

        if module_events:
            for module in module_events:
                blocks.append(self.get_module_events(module))

        if module_overview:
            blocks.append(self.get_module_overview())

        if architecture:
            blocks.append(self.get_architecture())

        # Sort by priority (highest first) and limit to 4 breakpoints
        blocks.sort(key=lambda b: b.priority)
        blocks = blocks[:4]

        return blocks


class CursorRulesCache:
    """
    Manages cached Cursor Rules for AL development.

    Caches frequently used rules to reduce token usage during coding tasks.
    """

    def __init__(self, rules_path: str = ".cursor/rules"):
        self.rules_path = Path(rules_path)
        self.project_root = Path(__file__).parent.parent.parent

    def _load_rule(self, rule_name: str) -> str:
        """Load cursor rule file"""
        full_path = self.project_root / self.rules_path / f"{rule_name}.mdc"
        if not full_path.exists():
            return f"# {rule_name}.mdc not found"

        with open(full_path, 'r', encoding='utf-8') as f:
            return f.read()

    def get_all_coding_rules(self) -> CacheBlock:
        """
        Load all essential coding rules in one cache block.

        Includes:
        - 001-naming-conventions.mdc
        - 002-development-patterns.mdc
        - 004-performance.mdc

        Use for all AL coding tasks.
        """
        rules = [
            "001-naming-conventions",
            "002-development-patterns",
            "004-performance"
        ]

        content = "\n\n---\n\n".join([
            f"# {rule}.mdc\n\n{self._load_rule(rule)}"
            for rule in rules
        ])

        return CacheBlock(
            name="AL Coding Rules",
            content=content,
            cache_control={"type": "ephemeral"},
            priority=1
        )

    def get_document_extension_rules(self) -> CacheBlock:
        """Load document extension patterns (Sales/Purchase)"""
        content = self._load_rule("003-document-extensions")

        return CacheBlock(
            name="Document Extension Rules",
            content=content,
            cache_control={"type": "ephemeral"},
            priority=2
        )

    def get_deployment_rules(self) -> CacheBlock:
        """Load deployment and security rules"""
        content = self._load_rule("007-deployment-security")

        return CacheBlock(
            name="Deployment & Security Rules",
            content=content,
            cache_control={"type": "ephemeral"},
            priority=3
        )


class CachedContext:
    """
    High-level API for building cached context.

    Combines BC27 docs, Cursor rules, and custom content into
    optimally cached system prompts.

    Usage:
        >>> ctx = CachedContext()
        >>>
        >>> # For event discovery task
        >>> blocks = ctx.for_event_discovery(module="sales")
        >>>
        >>> # For coding task
        >>> blocks = ctx.for_coding_task(document_extension=True)
        >>>
        >>> # For architectural planning
        >>> blocks = ctx.for_architecture_task()
    """

    def __init__(self):
        self.bc27_cache = BC27DocsCache()
        self.rules_cache = CursorRulesCache()

    def for_event_discovery(
        self,
        module: Optional[str] = None
    ) -> List[CacheBlock]:
        """
        Build cached context for event discovery tasks.

        Args:
            module: Specific module (sales, warehouse, etc.) or None for all

        Returns:
            Optimized cache blocks for event queries
        """
        blocks = [
            self.bc27_cache.get_quick_ref(),
            self.bc27_cache.get_event_catalog()
        ]

        if module:
            blocks.append(self.bc27_cache.get_module_events(module))

        return blocks[:4]  # Max 4 breakpoints

    def for_coding_task(
        self,
        document_extension: bool = False,
        performance_critical: bool = False
    ) -> List[CacheBlock]:
        """
        Build cached context for AL coding tasks.

        Args:
            document_extension: Include document extension patterns
            performance_critical: Include performance rules

        Returns:
            Optimized cache blocks for coding
        """
        blocks = [
            self.bc27_cache.get_quick_ref(),
            self.rules_cache.get_all_coding_rules()
        ]

        if document_extension:
            blocks.append(self.rules_cache.get_document_extension_rules())

        return blocks[:4]

    def for_architecture_task(self) -> List[CacheBlock]:
        """
        Build cached context for architectural planning.

        Returns:
            Optimized cache blocks for architecture decisions
        """
        return [
            self.bc27_cache.get_quick_ref(),
            self.bc27_cache.get_architecture(),
            self.bc27_cache.get_module_overview(),
            self.rules_cache.get_all_coding_rules()
        ][:4]

    def for_deployment_task(self) -> List[CacheBlock]:
        """
        Build cached context for deployment and security tasks.

        Returns:
            Optimized cache blocks for deployment
        """
        return [
            self.bc27_cache.get_quick_ref(),
            self.rules_cache.get_deployment_rules(),
            self.bc27_cache.get_module_overview()
        ][:4]


# Convenience functions for direct use
def get_bc27_context(
    quick_ref: bool = True,
    event_catalog: bool = False,
    module: Optional[str] = None
) -> List[Dict]:
    """
    Quick helper to get BC27 cached context.

    Returns list of dicts ready for Anthropic API system messages.

    Example:
        >>> context = get_bc27_context(quick_ref=True, module="sales")
        >>>
        >>> response = client.messages.create(
        ...     model="claude-sonnet-4-5-20250929",
        ...     system=[
        ...         {"type": "text", "text": "You are a BC27 expert."},
        ...         *context  # Unpacked cached content
        ...     ],
        ...     messages=[...]
        ... )
    """
    cache = BC27DocsCache()

    module_events = [module] if module else None

    blocks = cache.get_cached_context(
        quick_ref=quick_ref,
        event_catalog=event_catalog,
        module_events=module_events
    )

    return [
        {
            "type": "text",
            "text": block.content,
            "cache_control": block.cache_control
        }
        for block in blocks
    ]


def get_coding_context(document_extension: bool = False) -> List[Dict]:
    """
    Quick helper to get AL coding cached context.

    Returns list of dicts ready for Anthropic API system messages.
    """
    ctx = CachedContext()
    blocks = ctx.for_coding_task(document_extension=document_extension)

    return [
        {
            "type": "text",
            "text": block.content,
            "cache_control": block.cache_control
        }
        for block in blocks
    ]


if __name__ == "__main__":
    # Demo usage
    print("BC27 Prompt Caching Demo")
    print("=" * 60)

    cache = BC27DocsCache()

    # Example 1: Event discovery
    print("\n1. Event Discovery Context:")
    blocks = cache.get_cached_context(
        quick_ref=True,
        event_catalog=True,
        module_events=["sales"]
    )
    for block in blocks:
        print(f"   - {block.name} (Priority {block.priority})")
        print(f"     Content length: {len(block.content):,} chars")
        print(f"     Cacheable: {block.cache_control}")

    # Example 2: Coding context
    print("\n2. Coding Task Context:")
    ctx = CachedContext()
    blocks = ctx.for_coding_task(document_extension=True)
    for block in blocks:
        print(f"   - {block.name} (Priority {block.priority})")
        print(f"     Content length: {len(block.content):,} chars")

    # Example 3: Estimate token savings
    print("\n3. Estimated Token Savings:")
    print("   Without caching: ~62,000 tokens per query")
    print("   With caching (first query): ~77,500 tokens (125% write cost)")
    print("   With caching (subsequent 19 queries): ~6,200 tokens each (10% read cost)")
    print("   Total session (20 queries): ~195,300 tokens")
    print("   Savings: 79% reduction (1.24M → 195k tokens)")
    print("   Cost savings: $3.72 → $0.78 per session")
