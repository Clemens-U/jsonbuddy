# jsonbuddy
[JSONBuddy](https://www.json-buddy.com) is a JSON editor and validator for Windows that supports Draft 4, 6, 7, 2019-09, and 2020-12. It includes a JSON text and grid editor, syntax checking, and schema validation, as well as a unique JSON schema analyzer and debugger.
JSONBuddy also allows users to import CSV text and export JSON to CSV, and it includes an intelligent auto-completion feature that uses JSON schema information. Other features include brace highlighting, JSON pretty-print, and code folding.
JSONBuddy can be used to create and modify JSON content or JSON Schema files, and it provides a grid style editor that simplifies the creation and editing of JSON text.

# C# wrapper nuget package
Please take a look at the `dotnet wrapper` folder to find more information about the C# wrapper library to access JSON Schema validation and other functionality in your .NET project.

# Using the free JSON validator command-line tool
- Download your free JSON validator command-line tool for Windows® from this repository.
- Easy setup. Just run the Windows® installer. No additional configuration required.
- Use the JSON validator to generate detailed error reports.
- XML/W3C validation is also supported (using the Apache Xerces parser).

Usage example:

`valbuddy.exe -v -verbose -s "D:\Examples\Library\library_schema.json" "D:\Examples\Library\library.json" "D:\Examples\Library\library_invalid.json"`

Call "valbuddy.exe" without any parameters to get a list of options in the console window.

Validation output:
```
D:\Examples\Library\library.json: valid

D:\Examples\Library\library_invalid.json: invalid
Did not find the following required properties: [title]
Input location: /bib/book/2
Schema location: /properties/bib/properties/book/items

Finished processing
```

# Using the C++ DLL for easy JSON Schema validation
- Add the jsonvalidator.dll and the .lib and .h files from the dll folder to your project.
- Don't forget to add the dll to the output folder of your C++ solution.

Example code:
```
JSONSchemaSubSchemaResult::JSONSchemaSubSchemaResultsT out_results;
JSONSchemaValidator* json_validator = NewJSONSchemaValidator();

json_validator->SetJSONSchema("C:\\Users\\Clemens\\Dokumente\\JSONBuddy\\Examples\\Library\\library_schema.json", JSONSchemaValidator::TJSONSchemaSchemaID::k_nJSONSchemaIDDraft202012);
std::string json_instance = "{\"bib\":{\"book\":[{\"author\":[\"Clemens\",\"Stevens\"],\"publisher\":\"Addison-Wesley\"},{\"title\":1}]}}";

if (json_validator->ValidateJSONDocument(json_instance, 0, out_results))
{
    JSONSchemaSubSchemaResult::JSONSchemaSubSchemaResultsItrT find_invalid = std::find_if(out_results.begin(), out_results.end(),
        [](JSONSchemaSubSchemaResult::JSONSchemaSubSchemaResultsT::value_type& the_result) { return !the_result.m_bValid; });

    if (find_invalid != out_results.end())
    {
        std::cout << "The data is invalid.\n";
        std::cout << "Location: " << find_invalid->m_strJSONPointer << "\n";
    }
    else
        std::cout << "The data is valid.\n";
}
else
    std::cout << "The validation was not executed.\n";

json_validator->Free();
```


