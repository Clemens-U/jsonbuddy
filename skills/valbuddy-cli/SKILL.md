---
name: valbuddy-cli
description: Use ValBuddy CLI (`valbuddy.exe`) for XML/JSON validation, schema checks, JSON patch/lint/format/minify, JSON Schema tests, JSON-to-CSV conversion, and settings-XML batch automation on Windows. Trigger when a user asks to validate XML or JSON, enforce schema in CI, run command-line batch jobs, or automate JSON quality checks with XML ValidatorBuddy or JSONBuddy.
---

# ValBuddy CLI Skill

Use this skill to run `valbuddy.exe` reliably from Codex for validation and automation workflows.

## Quick Start

1. Confirm `valbuddy.exe` location.
2. Choose the correct mode from `references/cli-reference.md`.
3. Use scripts in `scripts/` instead of rebuilding command strings each time.
4. Treat exit code `0` as success and any non-zero as failure.
5. For `-s` in `-v/-wf` mode, pass schema path first, then input files.

## Resolve Tool Path

Prefer this order:

1. `-ValBuddyPath` argument in script call.
2. `VALBUDDY_EXE` environment variable.
3. `valbuddy.exe` from `PATH`.
4. Standard install locations under Program Files.

## Core Workflow

1. Identify job type: XML/JSON validation, formatting/minification, patching, schema test, conversion, or settings batch.
2. Run a script from `scripts/`.
3. Check process exit code.
4. If failure, include stderr/stdout details and command used.

## Script Catalog

- `scripts/invoke-valbuddy.ps1`: generic command runner with path resolution.
- `scripts/validate-xml.ps1`: XML-oriented validation wrapper.
- `scripts/validate-json.ps1`: JSON-oriented validation wrapper.
- `scripts/run-settings.ps1`: run `<settings-xml>` batch jobs.
- `scripts/format-json.ps1`: pretty-print (`-jspp`) or minify (`-jsm`).

## References

- Contract baseline: `references/cli-reference.md`
- Agent recipes: `references/agent-recipes.md`
- Source contract used to build this skill: `../../valbuddy-cli-contract-v1.md`

## Guardrails

- Use quoted paths for Windows file names containing spaces.
- Do not parse human-readable console text as API.
- Rely on exit codes and output files.
- Mention license constraints when calling restricted modes.
