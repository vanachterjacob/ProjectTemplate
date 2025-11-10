#!/usr/bin/env python3
"""
Example: Using Prompt Caching with Anthropic API

Demonstrates how to integrate prompt caching into BC27 development workflows.

This example shows:
1. Loading BC27 docs with caching
2. Making API calls with cached content
3. Monitoring cache performance
4. Cost/token savings analysis
"""

import os
from anthropic import Anthropic
from prompt_cache import CachedContext, get_bc27_context, get_coding_context


def example_event_discovery():
    """
    Example: Event discovery with prompt caching

    Query: "What events are available for Sales Header posting?"

    Without caching: ~18,000 tokens
    With caching: ~2,500 tokens (86% reduction)
    """
    client = Anthropic(api_key=os.environ.get("ANTHROPIC_API_KEY"))

    # Get cached BC27 context for sales events
    cached_context = get_bc27_context(
        quick_ref=True,
        event_catalog=True,
        module="sales"
    )

    response = client.messages.create(
        model="claude-sonnet-4-5-20250929",
        max_tokens=2048,
        system=[
            {
                "type": "text",
                "text": "You are a Business Central 27 development expert. "
                        "Answer using ONLY the provided BC27 documentation."
            },
            *cached_context  # Unpacked cached content with breakpoints
        ],
        messages=[
            {
                "role": "user",
                "content": "What events are available for Sales Header posting? "
                          "Provide event names, signatures, and when to use each."
            }
        ]
    )

    # Print response
    print("Event Discovery Response:")
    print("=" * 60)
    print(response.content[0].text)
    print()

    # Print cache performance metrics
    print_cache_metrics(response.usage)

    return response


def example_coding_task():
    """
    Example: AL coding task with prompt caching

    Task: "Create a Sales Header table extension with commission field"

    Without caching: ~15,000 tokens
    With caching: ~3,000 tokens (80% reduction)
    """
    client = Anthropic(api_key=os.environ.get("ANTHROPIC_API_KEY"))

    # Get cached coding context
    cached_context = get_coding_context(document_extension=True)

    response = client.messages.create(
        model="claude-sonnet-4-5-20250929",
        max_tokens=4096,
        system=[
            {
                "type": "text",
                "text": "You are a Business Central AL development expert. "
                        "Write ESC-compliant code following all BC27 patterns."
            },
            *cached_context  # Cached: BC27 quick ref + coding rules + document patterns
        ],
        messages=[
            {
                "role": "user",
                "content": "Create a Sales Header table extension (ABC Sales Header Ext) "
                          "with a Commission Percentage field (decimal, 0-100). "
                          "Include validation that commission cannot exceed 50%."
            }
        ]
    )

    print("Coding Task Response:")
    print("=" * 60)
    print(response.content[0].text)
    print()

    print_cache_metrics(response.usage)

    return response


def example_multi_turn_conversation():
    """
    Example: Multi-turn conversation with cache benefits

    Demonstrates the power of prompt caching: subsequent queries
    only pay 10% for cached content.

    First query: 125% cost (cache write)
    Queries 2-20: 10% cost (cache read) ← 79% savings here!
    """
    client = Anthropic(api_key=os.environ.get("ANTHROPIC_API_KEY"))

    # Cache context once
    cached_context = get_bc27_context(
        quick_ref=True,
        event_catalog=True,
        module="sales"
    )

    system_messages = [
        {
            "type": "text",
            "text": "You are a Business Central 27 development expert."
        },
        *cached_context
    ]

    # Query 1: Cache write (125% cost)
    print("Query 1 (Cache Write):")
    print("-" * 60)
    response1 = client.messages.create(
        model="claude-sonnet-4-5-20250929",
        max_tokens=1024,
        system=system_messages,
        messages=[
            {"role": "user", "content": "List all Sales Header posting events."}
        ]
    )
    print(response1.content[0].text[:200] + "...")
    print_cache_metrics(response1.usage)

    # Query 2: Cache read (10% cost) - SAME context, different question
    print("\nQuery 2 (Cache Read - 10% cost!):")
    print("-" * 60)
    response2 = client.messages.create(
        model="claude-sonnet-4-5-20250929",
        max_tokens=1024,
        system=system_messages,  # SAME system messages → cache hit!
        messages=[
            {"role": "user", "content": "Which event should I use for adding commission calculation?"}
        ]
    )
    print(response2.content[0].text[:200] + "...")
    print_cache_metrics(response2.usage)

    # Query 3: Another cache read
    print("\nQuery 3 (Cache Read - 10% cost!):")
    print("-" * 60)
    response3 = client.messages.create(
        model="claude-sonnet-4-5-20250929",
        max_tokens=1024,
        system=system_messages,
        messages=[
            {"role": "user", "content": "Show me the signature for OnAfterPostSalesDoc event."}
        ]
    )
    print(response3.content[0].text[:200] + "...")
    print_cache_metrics(response3.usage)

    # Calculate total savings
    print("\n" + "=" * 60)
    print("CACHE SAVINGS ANALYSIS:")
    print("=" * 60)
    print(f"Total input tokens (all 3 queries): {
        response1.usage.input_tokens +
        response2.usage.input_tokens +
        response3.usage.input_tokens
    }")

    # Estimate without caching (assuming ~20k tokens per query)
    without_cache = 20_000 * 3
    print(f"Without caching (estimate): ~{without_cache:,} tokens")
    print(f"Savings: ~{((without_cache - (response1.usage.input_tokens + response2.usage.input_tokens + response3.usage.input_tokens)) / without_cache * 100):.0f}%")


def print_cache_metrics(usage):
    """Print cache performance metrics from API response"""
    print("\n📊 Cache Metrics:")
    print(f"   Input tokens: {usage.input_tokens:,}")

    if hasattr(usage, 'cache_creation_input_tokens') and usage.cache_creation_input_tokens:
        print(f"   Cache write tokens: {usage.cache_creation_input_tokens:,} (125% cost)")

    if hasattr(usage, 'cache_read_input_tokens') and usage.cache_read_input_tokens:
        print(f"   Cache read tokens: {usage.cache_read_input_tokens:,} (10% cost) ← 90% savings!")

    print(f"   Output tokens: {usage.output_tokens:,}")
    print()


def example_advanced_caching():
    """
    Advanced example: Using CachedContext for different task types

    Demonstrates:
    - Automatic context selection based on task type
    - Optimal cache breakpoint placement
    - Maximum token efficiency
    """
    client = Anthropic(api_key=os.environ.get("ANTHROPIC_API_KEY"))
    ctx = CachedContext()

    # Task 1: Event discovery
    print("Task 1: Event Discovery")
    print("-" * 60)
    event_blocks = ctx.for_event_discovery(module="warehouse")
    print(f"Loaded {len(event_blocks)} cache blocks:")
    for block in event_blocks:
        print(f"  - {block.name} (~{len(block.content):,} chars)")

    # Task 2: Architectural planning
    print("\nTask 2: Architectural Planning")
    print("-" * 60)
    arch_blocks = ctx.for_architecture_task()
    print(f"Loaded {len(arch_blocks)} cache blocks:")
    for block in arch_blocks:
        print(f"  - {block.name} (~{len(block.content):,} chars)")

    # Task 3: Deployment preparation
    print("\nTask 3: Deployment Preparation")
    print("-" * 60)
    deploy_blocks = ctx.for_deployment_task()
    print(f"Loaded {len(deploy_blocks)} cache blocks:")
    for block in deploy_blocks:
        print(f"  - {block.name} (~{len(block.content):,} chars)")


if __name__ == "__main__":
    import sys

    print("BC27 Prompt Caching Examples")
    print("=" * 60)
    print()

    if len(sys.argv) < 2:
        print("Usage:")
        print("  python api_client_example.py event_discovery")
        print("  python api_client_example.py coding_task")
        print("  python api_client_example.py multi_turn")
        print("  python api_client_example.py advanced")
        sys.exit(1)

    example_type = sys.argv[1]

    # Check for API key
    if not os.environ.get("ANTHROPIC_API_KEY"):
        print("❌ Error: ANTHROPIC_API_KEY environment variable not set")
        print()
        print("Set your API key:")
        print("  export ANTHROPIC_API_KEY='your-api-key-here'")
        sys.exit(1)

    if example_type == "event_discovery":
        example_event_discovery()
    elif example_type == "coding_task":
        example_coding_task()
    elif example_type == "multi_turn":
        example_multi_turn_conversation()
    elif example_type == "advanced":
        example_advanced_caching()
    else:
        print(f"Unknown example type: {example_type}")
        sys.exit(1)
