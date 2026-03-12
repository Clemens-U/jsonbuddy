# Agent Recipes

## Validate JSON against schema

```powershell
./scripts/validate-json.ps1 -SchemaPath "D:\Schemas\library_schema.json" -InputFiles "D:\Data\library.json" -VerboseOutput
```

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

## Codex prompt triggers

- "Validate these JSON files against this schema with valbuddy and fail if invalid."
- "Run a well-formedness check for this XML folder using valbuddy.exe."
- "Use valbuddy in CI mode and return non-zero if any input fails."
- "Pretty-print this JSON using ValBuddy, keep original unchanged."
- "Run my settings XML batch job and summarize failures."
