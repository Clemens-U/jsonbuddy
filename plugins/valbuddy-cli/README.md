# ValBuddy CLI Agent Plugin

Use the ValBuddy command-line validator from AI coding agents for deterministic JSON, JSON Schema, and XML workflows on Windows.

The plugin provides the `valbuddy-cli` skill with workflows for:

- JSON and JSON Schema validation
- XML/XSD validation and well-formedness checks
- JSON formatting and minification
- Self-contained HTML documentation generation from JSON Schema
- JSON Schema tests, JSON Patch, JSON linting, JSON-to-CSV conversion, and settings-XML batch automation

## Prerequisites

- Windows
- A separately installed copy of [JSONBuddy](https://www.json-buddy.com/) or XML ValidatorBuddy that provides `valbuddy.exe`

The plugin does not include `valbuddy.exe`. The plugin files are MIT-licensed; JSONBuddy, XML ValidatorBuddy, and `valbuddy.exe` remain separately licensed software.

Set the executable path before using the skill if `valbuddy.exe` is not available through `PATH` or a standard installation location:

```powershell
$env:VALBUDDY_EXE="C:\Program Files\JSONBuddy\valbuddy.exe"
```

## Plugin contents

- `plugin.json`: plugin metadata
- `skills/valbuddy-cli/SKILL.md`: skill instructions
- `skills/valbuddy-cli/scripts/`: PowerShell command wrappers
- `skills/valbuddy-cli/references/`: CLI reference and agent recipes

## Test with GitHub Copilot CLI

From the repository root:

```powershell
copilot --plugin-dir ./plugins/valbuddy-cli
```

After the plugin is accepted into the Awesome Copilot marketplace, install it with:

```powershell
copilot plugin install valbuddy-cli@awesome-copilot
```

## Install as a standalone Codex skill

Use the built-in `skill-installer` with this repository path:

```powershell
python "$env:CODEX_HOME\skills\.system\skill-installer\scripts\install-skill-from-github.py" --repo Clemens-U/jsonbuddy --path plugins/valbuddy-cli/skills/valbuddy-cli
```

## Examples

Run these examples from the plugin directory:

```powershell
./skills/valbuddy-cli/scripts/validate-json.ps1 -SchemaPath "D:\Schemas\library_schema.json" -InputFiles "D:\Data\library.json" -VerboseOutput
```

```powershell
./skills/valbuddy-cli/scripts/validate-xml.ps1 -SchemaPath "D:\Schemas\invoice.xsd" -InputFiles "D:\Data\invoice.xml"
```

```powershell
./skills/valbuddy-cli/scripts/format-json.ps1 -Mode pretty -InputJson "D:\Data\raw.json" -OutputJson "D:\Output\pretty.json"
```

```powershell
./skills/valbuddy-cli/scripts/generate-schema-docs.ps1 -SchemaPath "D:\Schemas\library_schema.json" -OutputHtml "D:\Documentation\library_schema.html"
```

## License notes

- Free-license restrictions apply to `<settings-xml>`, `-patch`, `-jsl`, `-jspp`, `-jst`, and `-j2csv`.
- JSON Schema documentation generation with `-jsdoc` is limited to schemas smaller than 50 KB in the free version after the evaluation period.
- `-jsv` requires a JSONBuddy Large Data license.

See `LICENSE` for the MIT license covering this plugin. The separately installed ValBuddy executable is governed by its applicable product license.
