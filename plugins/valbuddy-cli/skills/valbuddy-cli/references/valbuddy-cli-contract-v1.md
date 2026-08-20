# ValBuddy CLI Contract v1

Status: Approved
Version: 1.1.0
Effective date: 2026-08-19
Executable: `valbuddy.exe`
Products: XML ValidatorBuddy, JSONBuddy
Validated against: `ValBuddyConsoleApp.cpp` command-line implementation and `valbuddy.exe` help text

## 1. Purpose

This document defines the authoritative command-line contract for `valbuddy.exe`.
It is the normative source for:

- supported commands and options
- argument rules
- exit-code behavior
- compatibility guarantees

Website copy, help text, and marketing pages must not contradict this contract.

## 2. Scope

This contract covers:

- XML and JSON validation modes
- JSON Schema documentation generation
- JSON utility and automation modes
- settings-XML batch execution mode
- return-code semantics

This contract does not define GUI behavior.

## 3. Invocation Grammar

`valbuddy.exe` SHALL support the following invocation forms:

```text
valbuddy.exe [-v | -wf [-verbose] [-s] <file 1> ... <file n>]
 | [<settings-xml>]
 | -patch <patches.json> <file 1> ... <file n>
 | -jsl [-ox <output.xml> | -oj <output.json>] <json-schema.json>
 | -jsdoc -o <output.html> <json-schema.json>
 | -jspp [-oj <output.json>] <json-input.json>
 | -jsm [-oj <output.json>] <json-input.json>
 | -jst <Name of JSON Schema test>
 | -jsv -s <json-schema.json> -oj <output.json> <json-instance.json>
 | -j2csv -config <configuration.json> -o <output.csv> <json-instance.json>
```

Starting `valbuddy.exe` with no arguments SHALL print usage/options text.

## 4. Option Contract

### 4.1 Core Validation

- `-v`
  - Validate one or more XML or JSON files.
- `-wf`
  - Well-formedness check on one or more files.
- `-verbose`
  - Verbose output with full list of errors.
- `-s`
  - Validate against a specific W3C or JSON Schema.
  - In the `-v/-wf` form, the first file parameter after `-s` is interpreted as schema path.

### 4.2 Batch Execution

- `<settings-xml>`
  - Run batch validation and create log file using XML settings.
  - Not available with free license.

### 4.3 JSON Operations

- `-patch <patches.json> <file 1> ... <file n>`
  - Apply JSON Patch operations to documents.
  - Not available with free license.
- `-jsl [-ox <output.xml> | -oj <output.json>] <json-schema.json>`
  - Apply JSON Schema linter.
  - Not available with free license.
- `-jsdoc -o <output.html> <json-schema.json>`
  - Generate self-contained HTML documentation from a local JSON Schema.
  - The output path is required and must use the `.html` or `.htm` extension.
  - HTTP and HTTPS schema inputs are not supported.
  - Input and output must resolve to different files.
  - In the free version after the evaluation period, the input schema must be smaller than 50 KB.
- `-jspp [-oj <output.json>] <json-input.json>`
  - Pretty-print JSON input of any size.
  - If no output path is set, input is overwritten.
  - Not available with free license.
- `-jsm [-oj <output.json>] <json-input.json>`
  - Minify JSON input.
  - If no output path is set, input is overwritten.
- `-jst <Name of JSON Schema test>`
  - Run configured JSON Schema test from JSONBuddy desktop application.
  - Not available with free license.
- `-j2csv -config <configuration.json> -o <output.csv> <json-instance.json>`
  - Convert JSON to CSV using desktop-generated configuration.
  - Not available with free license.
- `-jsv -s <json-schema.json> -oj <output.json> <json-instance.json>`
  - Use streaming JSON validator.
  - Requires JSONBuddy Large Data license.

### 4.4 Output/Config Options

- `-oj <output.json>`: Write JSON output.
- `-ox <output.xml>`: Write XML output.
- `-config <configuration.json>`: Provide JSON-to-CSV conversion configuration.
- `-o <output>`: Provide the HTML output path for `-jsdoc` or CSV output path for `-j2csv`.

## 5. Argument and Parsing Rules

- Option names are case-insensitive.
- File paths may be absolute or relative.
- Paths containing spaces should be quoted.
- Unknown options SHALL produce a usage error with non-zero exit code.
- Missing required arguments SHALL produce a usage error with non-zero exit code.
- Mutually exclusive mode switches SHALL produce a usage error with non-zero exit code.

## 6. Exit Code Contract

`valbuddy.exe` SHALL return:

- `0`: Successful processing.
- `-1`: Any file is not valid, not well-formed, or has no schema assigned.

Additional non-zero codes MAY exist for runtime/license/usage failures.
For automation compatibility, callers MUST treat any non-zero code as failure.

The `-jsdoc` mode additionally defines:

- `2`: Invalid arguments, output extension, remote input, or input/output path combination.
- `9`: Free-version schema-size limit exceeded.
- `701`: Input file access or load failure.
- `702`: JSON Schema parse failure.
- `703`: Documentation generation did not produce valid UTF-8.
- `704`: Output write failure.

## 7. Standard Output and Error Behavior

- With no args, tool prints usage/options text.
- On success, tool prints per-file status and completion text.
- With `-verbose`, tool prints expanded diagnostics.
- On failure, tool prints actionable errors and returns non-zero.

Console text formatting is not a stable API. Integrations MUST rely on exit codes and explicit output files.

## 8. License-Dependent Features

Not available with free license:

- `<settings-xml>` batch mode
- `-patch`
- `-jsl`
- `-jspp`
- `-jst`
- `-j2csv`

Large Data license required:

- `-jsv`

Free-version size limit:

- `-jsdoc` accepts schemas smaller than 50 KB after the evaluation period has ended.

If entitlement is missing, command SHALL fail with non-zero exit code and clear message.

## 9. Compatibility Guarantees

For all 1.x contract revisions:

- Existing switches and their meaning remain backward compatible.
- Exit-code semantics remain stable (`0` success, `-1` documented validation/assignment failure, other non-zero = failure).
- Removing/renaming switches is not allowed in patch/minor contract revisions.

Breaking changes require a major contract revision (`v2`).

## 10. Deprecation Policy

- Any planned removal MUST be announced before removal.
- Deprecated options SHOULD remain operational for at least one published release cycle.
- Deprecation warnings SHOULD identify replacement option/mode.

## 11. Conformance Tests (Required)

Each release SHALL run smoke tests for:

- `-v` success/failure
- `-wf` success/failure
- `-s` schema-path behavior in `-v/-wf` flow
- `-patch`, `-jsl`, `-jsdoc`, `-jspp`, `-jsm`, `-jst`, `-jsv`, `-j2csv`
- `<settings-xml>` batch execution
- unknown option usage error
- exit code assertions (`0`, `-1`, and generic non-zero failures)

## 12. Canonical Examples

```bat
valbuddy.exe -v -verbose -s "D:\Examples\Library\library_schema.json" "D:\Examples\Library\library.json" "D:\Examples\Library\library_invalid.json"
```

```bat
valbuddy.exe -jspp -oj "D:\Output\pretty.json" "D:\Data\raw.json"
```

```bat
valbuddy.exe -jsdoc -o "D:\Documentation\schema.html" "D:\Schemas\schema.json"
```

```bat
valbuddy.exe -jsm -oj "D:\Output\min.json" "D:\Data\pretty.json"
```

```bat
valbuddy.exe -jst "InvoiceSchemaRegression"
```

```bat
valbuddy.exe -j2csv -config "D:\Configs\export_config.json" -o "D:\Output\data.csv" "D:\Data\source.json"
```

```bat
valbuddy.exe -jsv -s "D:\Schemas\schema.json" -oj "D:\Output\result.json" "D:\Data\instance.json"
```

```bat
valbuddy.exe "D:\Configs\myJSON2XMLconfig.xml"
```

## 13. Change Control

Any CLI change requires all of:

- update this contract
- update conformance tests
- update release notes
- update public docs/help pages

Contract versioning:

- patch: wording/clarity only
- minor: additive backward-compatible options
- major: breaking changes
