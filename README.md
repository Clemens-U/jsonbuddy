# jsonbuddy
[JSONBuddy](https://www.json-buddy.com) is a JSON editor and validator for Windows that supports Draft 4, 6, 7, 2019-09, and 2020-12. It includes a JSON text and grid editor, syntax checking, and schema validation, as well as a unique JSON schema analyzer and debugger.
JSONBuddy also allows users to import CSV text and export JSON to CSV, and it includes an intelligent auto-completion feature that uses JSON schema information. Other features include brace highlighting, JSON pretty-print, and code folding.
JSONBuddy can be used to create and modify JSON content or JSON Schema files, and it provides a grid style editor that simplifies the creation and editing of JSON text.

# Using the JSON validator command-line tool
- Download your free JSON validator command-line tool for Windows® from this repository.
- Easy setup. Just run the Windows® installer. No additional configuration required.
- Use the JSON validator to generate detailed error reports.
- XML/W3C validation is also supported (using the Apache Xerces parser).

Usage example:

`valbuddy.exe -v -verbose -s "D:\Examples\Library\library_schema.json" "D:\Examples\Library\library.json" "D:\Examples\Library\library_invalid.json"`

Call "valbuddy.exe" without any paramters to get a list of options in the console window.

Validation output:
```
D:\Examples\Library\library.json: valid

D:\Examples\Library\library_invalid.json: invalid
Did not find the following required properties: [title]
Input location: /bib/book/2
Schema location: /properties/bib/properties/book/items

Finished processing
```
