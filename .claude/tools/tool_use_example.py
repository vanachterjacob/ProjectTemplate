#!/usr/bin/env python3
"""
Tool Use Integration Example

Demonstrates how Claude automatically selects and calls BC automation tools
based on developer requests.

This shows the full workflow:
1. Developer makes request ("Review my code")
2. Claude analyzes request and selects appropriate tools
3. Tools execute and return results
4. Claude synthesizes results into actionable feedback
"""

import os
from anthropic import Anthropic
from bc_automation import BCAutomationTools


def example_auto_review():
    """
    Example: Automatic code review with tool selection

    Developer request: "Review the AL files in src/ for ESC compliance"
    Claude automatically calls: check_esc_compliance tool
    """
    client = Anthropic(api_key=os.environ.get("ANTHROPIC_API_KEY"))
    bc_tools = BCAutomationTools()

    # Step 1: Developer makes request
    user_request = "Review the AL files in src/ folder for ESC compliance and check if any objects are using production IDs accidentally."

    print(f"User Request: {user_request}")
    print("=" * 80)
    print()

    # Step 2: Claude analyzes and selects tools
    response = client.messages.create(
        model="claude-sonnet-4-5-20250929",
        max_tokens=4096,
        tools=bc_tools.get_tool_definitions(),  # All BC automation tools available
        messages=[
            {
                "role": "user",
                "content": user_request
            }
        ]
    )

    print("Claude's Response (with automatic tool selection):")
    print("-" * 80)

    # Step 3: Process tool calls from Claude
    tool_results = []

    for block in response.content:
        if block.type == "text":
            print(f"\nClaude: {block.text}")

        elif block.type == "tool_use":
            tool_name = block.name
            tool_input = block.input

            print(f"\n🔧 Claude selected tool: {tool_name}")
            print(f"   Input: {tool_input}")
            print()

            # Execute tool
            result = bc_tools.execute_tool(tool_name, tool_input)

            print(f"📊 Tool Result:")
            print(result)

            # Store for next API call
            tool_results.append({
                "type": "tool_result",
                "tool_use_id": block.id,
                "content": result
            })

    # Step 4: Send tool results back to Claude for synthesis
    if tool_results:
        print("\n" + "=" * 80)
        print("Sending tool results back to Claude for analysis...")
        print("=" * 80)
        print()

        final_response = client.messages.create(
            model="claude-sonnet-4-5-20250929",
            max_tokens=4096,
            tools=bc_tools.get_tool_definitions(),
            messages=[
                {"role": "user", "content": user_request},
                {"role": "assistant", "content": response.content},
                {"role": "user", "content": tool_results}
            ]
        )

        print("Claude's Final Analysis:")
        print("-" * 80)
        for block in final_response.content:
            if block.type == "text":
                print(block.text)


def example_production_deployment():
    """
    Example: Production deployment preparation

    Developer request: "Prepare src/ for production deployment starting at ID 50100"
    Claude automatically calls: check_object_ids → assign_production_ids (with dry_run)
    """
    client = Anthropic(api_key=os.environ.get("ANTHROPIC_API_KEY"))
    bc_tools = BCAutomationTools()

    user_request = "Prepare the src/ folder for production deployment. Assign production IDs starting at 50100. Show me what will change first."

    print(f"\nUser Request: {user_request}")
    print("=" * 80)
    print()

    response = client.messages.create(
        model="claude-sonnet-4-5-20250929",
        max_tokens=4096,
        tools=bc_tools.get_tool_definitions(),
        messages=[{"role": "user", "content": user_request}]
    )

    # Process Claude's tool selections
    conversation = [
        {"role": "user", "content": user_request},
        {"role": "assistant", "content": response.content}
    ]

    while True:
        tool_calls = [block for block in response.content if block.type == "tool_use"]

        if not tool_calls:
            # No more tools to call - print final response
            for block in response.content:
                if block.type == "text":
                    print(f"\nClaude: {block.text}")
            break

        # Execute tool calls
        tool_results = []
        for tool_call in tool_calls:
            tool_name = tool_call.name
            tool_input = tool_call.input

            print(f"\n🔧 Claude selected tool: {tool_name}")
            print(f"   Input: {tool_input}")

            result = bc_tools.execute_tool(tool_name, tool_input)

            print(f"\n📊 Tool Result:")
            print(result)
            print()

            tool_results.append({
                "type": "tool_result",
                "tool_use_id": tool_call.id,
                "content": result
            })

        # Send results back to Claude
        conversation.append({"role": "user", "content": tool_results})

        response = client.messages.create(
            model="claude-sonnet-4-5-20250929",
            max_tokens=4096,
            tools=bc_tools.get_tool_definitions(),
            messages=conversation
        )

        conversation.append({"role": "assistant", "content": response.content})


def example_multi_check():
    """
    Example: Multiple checks in one request

    Developer request: "Is my code ready to commit?"
    Claude automatically calls multiple tools:
    1. check_esc_compliance
    2. check_object_ids
    3. compile_al_project
    4. validate_dependencies
    """
    client = Anthropic(api_key=os.environ.get("ANTHROPIC_API_KEY"))
    bc_tools = BCAutomationTools()

    user_request = "Is my code in src/ ready to commit? Check everything: ESC compliance, object IDs, compilation, and dependencies."

    print(f"\nUser Request: {user_request}")
    print("=" * 80)
    print()

    response = client.messages.create(
        model="claude-sonnet-4-5-20250929",
        max_tokens=4096,
        tools=bc_tools.get_tool_definitions(),
        messages=[{"role": "user", "content": user_request}]
    )

    print("Claude is running multiple checks...")
    print("-" * 80)

    # Process all tool calls
    conversation = [
        {"role": "user", "content": user_request},
        {"role": "assistant", "content": response.content}
    ]

    iteration = 1
    while True:
        tool_calls = [block for block in response.content if block.type == "tool_use"]

        if not tool_calls:
            # No more tools - show final verdict
            print("\n" + "=" * 80)
            print(f"Final Verdict (after {iteration-1} tool call(s)):")
            print("=" * 80)
            for block in response.content:
                if block.type == "text":
                    print(block.text)
            break

        print(f"\nIteration {iteration}: Claude calling {len(tool_calls)} tool(s)")

        tool_results = []
        for tool_call in tool_calls:
            tool_name = tool_call.name
            print(f"  - {tool_name}")

            result = bc_tools.execute_tool(tool_name, tool_call.input)

            tool_results.append({
                "type": "tool_result",
                "tool_use_id": tool_call.id,
                "content": result
            })

        # Continue conversation
        conversation.append({"role": "user", "content": tool_results})

        response = client.messages.create(
            model="claude-sonnet-4-5-20250929",
            max_tokens=4096,
            tools=bc_tools.get_tool_definitions(),
            messages=conversation
        )

        conversation.append({"role": "assistant", "content": response.content})
        iteration += 1


def example_slash_command_integration():
    """
    Example: How to integrate with /review slash command

    This shows the pattern for updating .claude/commands/review.md
    to use tool use automation.
    """
    print("\nIntegration Pattern for /review Slash Command")
    print("=" * 80)
    print()

    code_example = '''
# In .claude/commands/review.md

Review AL code for ESC compliance and best practices.

**Implementation:**

```python
import sys
sys.path.append('.claude/tools')

from anthropic import Anthropic
from bc_automation import BCAutomationTools

# Initialize
client = Anthropic()
bc_tools = BCAutomationTools()

# Get file/folder from command args
target = sys.argv[1] if len(sys.argv) > 1 else "src/"

# Let Claude automatically select and run appropriate tools
response = client.messages.create(
    model="claude-sonnet-4-5-20250929",
    max_tokens=4096,
    tools=bc_tools.get_tool_definitions(),
    messages=[{
        "role": "user",
        "content": f"Review {target} for ESC compliance, object ID issues, and code quality. Provide actionable feedback with file:line references."
    }]
)

# Claude will automatically call:
# 1. check_esc_compliance({{"file_path": "{target}"}})
# 2. check_object_ids({{"file_path": "{target}"}})
# 3. Any other relevant tools

# Process and display results...
```

**Usage:**
/review src/MyTable.al
/review src/
'''

    print(code_example)

    print("\n✅ Key Benefits:")
    print("   - Zero manual tool selection")
    print("   - Claude picks the right tools automatically")
    print("   - Comprehensive review with one command")
    print("   - Actionable feedback with file:line references")


if __name__ == "__main__":
    import sys

    print("BC Automation Tool Use Examples")
    print("=" * 80)
    print()

    if len(sys.argv) < 2:
        print("Usage:")
        print("  python tool_use_example.py auto_review")
        print("  python tool_use_example.py production_deployment")
        print("  python tool_use_example.py multi_check")
        print("  python tool_use_example.py slash_command")
        sys.exit(1)

    example_type = sys.argv[1]

    # Check for API key
    if example_type != "slash_command" and not os.environ.get("ANTHROPIC_API_KEY"):
        print("❌ Error: ANTHROPIC_API_KEY environment variable not set")
        print()
        print("Set your API key:")
        print("  export ANTHROPIC_API_KEY='your-api-key-here'")
        sys.exit(1)

    if example_type == "auto_review":
        example_auto_review()
    elif example_type == "production_deployment":
        example_production_deployment()
    elif example_type == "multi_check":
        example_multi_check()
    elif example_type == "slash_command":
        example_slash_command_integration()
    else:
        print(f"Unknown example type: {example_type}")
        sys.exit(1)
