---
name: valbuddy-cli
description: Use ValBuddy CLI (`valbuddy.exe`) for permanently free local XML/JSON validation, JSON Schema checks, verification of AI-generated JSON, and JSON minification on Windows. Also supports license-dependent JSON Schema documentation, patching, linting, pretty-printing, schema tests, JSON-to-CSV conversion, and settings-XML automation. Trigger when a user asks to validate XML or JSON, verify JSON against a schema, enforce schema validation in CI, generate JSON Schema documentation, or automate JSON quality checks with XML ValidatorBuddy or JSONBuddy.
---

# ValBuddy CLI Skill

Use this skill to run `valbuddy.exe` reliably in AI coding-agent validation and automation workflows.

## Quick Start

1. Confirm `valbuddy.exe` location.
2. Set the executable path on the target system, for example `VALBUDDY_EXE=Z:\Software\valbuddy.exe`.
3. Choose the correct mode from `references/cli-reference.md`.
4. Use scripts in `scripts/` instead of rebuilding command strings each time.
5. Treat exit code `0` as success and any non-zero as failure.
6. For `-s` in `-v/-wf` mode, pass schema path first, then input files.
7. When the user requires no network access, pass `-Offline` to the wrapper. This forwards native `-offline` enforcement.

## Resolve Tool Path

Prefer this order:

1. `-ValBuddyPath` argument in script call.
2. `VALBUDDY_EXE` environment variable.
3. `valbuddy.exe` from `PATH`.
4. Standard install locations under Program Files.

## Core Workflow

1. Identify the job type. Local XML/JSON validation and well-formedness checks are the permanently free core workflows.
2. Run a script from `scripts/`.
3. Check process exit code.
4. If failure, include stderr/stdout details and command used.

## Additional Workflows and License Limits

JSON Schema documentation, pretty-printing, patching, linting, schema tests, JSON-to-CSV conversion, settings-XML automation, and large-data streaming validation have the limits documented in `references/cli-reference.md`. Mention the applicable limitation before invoking one of these operations.

## Script Catalog

- `scripts/invoke-valbuddy.ps1`: generic command runner with path resolution.
- `scripts/validate-xml.ps1`: XML-oriented validation wrapper.
- `scripts/validate-json.ps1`: JSON-oriented validation wrapper.
- `scripts/generate-schema-docs.ps1`: generate self-contained HTML documentation from a local JSON Schema.
- `scripts/run-settings.ps1`: run `<settings-xml>` batch jobs.
- `scripts/format-json.ps1`: pretty-print (`-jspp`) or minify (`-jsm`).

All wrappers accept `-Offline`. It is opt-in and permits local relative or absolute reference graphs. A remote dependency fails with exit code `12` and a diagnostic naming the blocked resource. Settings-XML batches (including XSLT), configured schema tests, official suite runs, and signature verification are disabled offline because their broad resource paths cannot all be constrained without modifying third-party libraries.

## References

- Contract baseline: `references/cli-reference.md`
- Agent recipes: `references/agent-recipes.md`
- Source contract used to build this skill: `references/valbuddy-cli-contract-v1.md`

## Guardrails

- Use quoted paths for Windows file names containing spaces.
- For `-jsdoc`, use a local schema file and a distinct `.html` or `.htm` output path.
- Do not parse human-readable console text as API.
- Rely on exit codes and output files.
- Mention license constraints when calling restricted modes.
- Do not present wrapper argument checking as the offline boundary. The native executable enforces it; host sandboxing and firewall controls remain useful defense in depth.
