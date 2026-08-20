# ValBuddy CLI Reference (Contract-Aligned)

## Invocation

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

## Option Semantics

- `-v`: validate one or more XML or JSON files.
- `-wf`: run well-formed check.
- `-verbose`: print detailed errors.
- `-s`: validate against schema. In `-v/-wf`, first file after `-s` is schema path.
- `<settings-xml>`: run batch settings XML (free license restriction applies).
- `-patch`: apply JSON Patch (free license restriction applies).
- `-jsl`: JSON Schema linter (free license restriction applies).
- `-jsdoc`: generate self-contained HTML documentation from a local JSON Schema. Requires `-o` followed by a distinct `.html` or `.htm` output path; HTTP and HTTPS schema inputs are not supported.
- `-jspp`: pretty-print JSON, overwrites input if no output path (free license restriction applies).
- `-jsm`: minify JSON, overwrites input if no output path.
- `-jst`: run named JSON Schema test from JSONBuddy desktop app (free license restriction applies).
- `-jsv`: streaming JSON validator (Large Data license required).
- `-j2csv`: convert JSON to CSV using desktop-generated config (free license restriction applies).

## Exit Code

- `0`: success.
- `-1`: any file not valid, not well-formed, or no schema assigned.
- `2`: invalid `-jsdoc` arguments, output extension, remote input, or input/output path combination.
- `9`: free-version `-jsdoc` input is not smaller than 50 KB.
- `701`: unable to access or load the JSON Schema input.
- `702`: unable to parse the input as a JSON Schema.
- `703`: unable to generate valid UTF-8 documentation.
- `704`: unable to write the documentation output.
- Any other non-zero: failure; treat as failed run.

## License Flags

Not available with free license:

- `<settings-xml>`
- `-patch`
- `-jsl`
- `-jspp`
- `-jst`
- `-j2csv`

Large Data license required:

- `-jsv`

Free-version limit:

- `-jsdoc` accepts schemas smaller than 50 KB after the evaluation period has ended; paid licenses and active evaluations allow larger schemas.
