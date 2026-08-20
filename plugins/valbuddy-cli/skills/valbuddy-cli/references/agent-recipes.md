# Agent Recipes

First, configure the CLI path on the target system. For example, if JSONBuddy is installed at `Z:\Software\JSONBuddy`:

```powershell
$env:VALBUDDY_EXE="Z:\Software\JSONBuddy\valbuddy.exe"
```

## Validate JSON against schema

```powershell
./scripts/validate-json.ps1 -SchemaPath "D:\Schemas\library_schema.json" -InputFiles "D:\Data\library.json" -VerboseOutput
```

## Verify AI-generated JSON

When an agent creates or modifies JSON that has an associated JSON Schema:

1. Run `validate-json.ps1` against the generated JSON and schema.
2. Treat exit code `0` as successful validation.
3. If validation fails, use the validator diagnostics to correct the JSON.
4. Run validation again after each correction.
5. Do not report the JSON task as complete until validation succeeds.

## Generate JSON Schema documentation

Generate a self-contained HTML document from a local JSON Schema:

```powershell
./scripts/generate-schema-docs.ps1 -SchemaPath "D:\Schemas\library_schema.json" -OutputHtml "D:\Documentation\library_schema.html"
```

The output path must end in `.html` or `.htm` and must differ from the input path. Remote HTTP or HTTPS schema inputs are not supported.

## Validate XML against schema

```powershell
./scripts/validate-xml.ps1 -SchemaPath "D:\Schemas\invoice.xsd" -InputFiles "D:\Data\invoice.xml"
```

## Well-formedness check

```powershell
./scripts/validate-xml.ps1 -WellFormedOnly -InputFiles "D:\Data\input.xml"
```

## Run settings XML batch task

```powershell
./scripts/run-settings.ps1 -SettingsXml "D:\Configs\batch-settings.xml"
```

## Pretty-print JSON

```powershell
./scripts/format-json.ps1 -Mode pretty -InputJson "D:\Data\raw.json" -OutputJson "D:\Output\pretty.json"
```

## Minify JSON in place

```powershell
./scripts/format-json.ps1 -Mode minify -InputJson "D:\Data\pretty.json"
```

## Example prompts

- "Validate these JSON files against this schema with valbuddy and fail if invalid."
- "Generate self-contained HTML documentation for this JSON Schema with ValBuddy."
- "Run a well-formedness check for this XML folder using valbuddy.exe."
- "Use valbuddy in CI mode and return non-zero if any input fails."
- "Pretty-print this JSON using ValBuddy, keep original unchanged."
- "Run my settings XML batch job and summarize failures."
