  JSONBuddyLibrary

JSONBuddyLibrary
================

Overview
--------

`JSONBuddyLibrary` is a .NET wrapper for the `jsonvalidator.dll`, a powerful native library for validating, minifying, and prettifying JSON data. This package provides a simple and efficient way to leverage advanced JSON validation capabilities in your .NET applications, including streaming schema validation for huge data and customizable validation processes with callbacks.

Features
--------

*   **JSON Validation**: Validate JSON documents against various JSON Schema drafts.
*   **Generate JSON Schema documentation**: Create HTML/SVG documentation from your JSON Schemas.
*   **Minification and Prettification**: Easily minify or prettify JSON strings.
*   **JSON Patch**: Apply JSON Patch operations to JSON documents.
*   **Schema Support**: Supports multiple JSON Schema drafts, including Draft04, Draft06, Draft07, Draft201909, and Draft202012.
*   **Custom Callbacks**: Define custom callbacks for document loading and validation reporting.
*   **License Support**: Unlock enhanced functionality with a valid license key.

Installation
------------

You can install the `JSONBuddyLibrary` package using any of the following methods:

### NuGet Package Manager

    PM> Install-Package JSONBuddyLibrary

### .NET CLI

    dotnet add package JSONBuddyLibrary

### PackageReference

Add the following XML node into your project file to reference the package:

    <PackageReference Include="JSONBuddyLibrary" Version="1.1.2" />

Usage
-----

### Basic JSON Validation

Here's an example of how to use the `JSONValidatorWrapper` to validate a JSON document against a schema:

    using System;
    using System.Runtime.InteropServices;
    using JSONBuddyLibrary;
    
    class Program
    {
        static void Main()
        {
            // Create a JSON Schema validator instance (using free version)
            IntPtr validator = JSONValidatorWrapper.JB_NewJSONSchemaValidator("", "");
    
            // Define your JSON Schema
            string jsonSchema = @"
            {
                ""$schema"": ""http://json-schema.org/draft-07/schema#"",
                ""type"": ""object"",
                ""properties"": {
                    ""name"": { ""type"": ""string"" },
                    ""age"": { ""type"": ""integer"" }
                },
                ""required"": [""name"", ""age""]
            }";
    
            // Set the schema for the validator
            bool schemaSet = JSONValidatorWrapper.JB_SetJSONSchemaFromString(validator, jsonSchema, 2); // Draft07
    
            if (schemaSet)
            {
                // Validate a JSON instance against the schema
                string jsonInstance = "{ \"name\": \"John Doe\", \"age\": 30 }";
                IntPtr validationResult = JSONValidatorWrapper.JB_ValidateJSONDocument(validator, jsonInstance, null);
    
                string resultString = Marshal.PtrToStringUni(validationResult);
                Console.WriteLine($"Validation Result: {resultString}");
    
                // Free the string allocated by the native library
                JSONValidatorWrapper.JB_FreeString(validationResult);
            }
    
            // Free the validator instance
            JSONValidatorWrapper.JB_FreeJSONSchemaValidator(validator);
        }
    }

### Minifying and Prettifying JSON

The `JSONValidatorWrapper` also provides methods for minifying and prettifying JSON strings:

    using System;
    using System.Runtime.InteropServices;
    using JSONBuddyLibrary;
    
    class Program
    {
        static void Main()
        {
            IntPtr validator = JSONValidatorWrapper.JB_NewJSONSchemaValidator("", "");
    
            string json = "{ \"name\": \"John Doe\", \"age\": 30, \"city\": \"New York\" }";
    
            // Minify JSON
            IntPtr minifiedJsonPtr = JSONValidatorWrapper.JB_MinifyJSONText(validator, json);
            string minifiedJson = Marshal.PtrToStringUni(minifiedJsonPtr);
            Console.WriteLine($"Minified JSON: {minifiedJson}");
            JSONValidatorWrapper.JB_FreeString(minifiedJsonPtr);
    
            // Prettify JSON
            IntPtr prettifiedJsonPtr = JSONValidatorWrapper.JB_PrettifyJSONText(validator, json);
            string prettifiedJson = Marshal.PtrToStringUni(prettifiedJsonPtr);
            Console.WriteLine($"Prettified JSON: {prettifiedJson}");
            JSONValidatorWrapper.JB_FreeString(prettifiedJsonPtr);
    
            JSONValidatorWrapper.JB_FreeJSONSchemaValidator(validator);
        }
    }

### Advanced Usage with Callbacks

You can define custom callbacks for loading documents and handling validation results. Please find below an example of how to use the streaming validation functionality with custom callbacks:

    using System;
    using System.Runtime.InteropServices;
    using JSONBuddyLibrary;
    
    class Program
    {
        static void Main()
        {
            IntPtr validator = JSONValidatorWrapper.JB_NewJSONSchemaValidator("", "");
    
            // Define a document loader callback
            JSONValidatorWrapper.LoadDocumentCallback documentLoader = (string path, out IntPtr content, out IntPtr error, long maxFileSize) =>
            {
                content = IntPtr.Zero;
                error = IntPtr.Zero;
    
                // Load your external document here, convert it to UTF-16LE, and assign it to content
                // For simplicity, we'll just return false here
                return false;
            };
    
            // Define a results entry added callback
            JSONValidatorWrapper.ResultsEntryAddedCallback resultsCallback = (string jsonPointer, string jsonPointerSchema, string schemaKey, string pathToSchema, bool isValid, long validationStep, string message) =>
            {
                Console.WriteLine($"Validation Error: {message}");
                return true; // Continue validation
            };
    
            string jsonInstancePath = "path_to_json_file.json";
            bool validationSuccess = JSONValidatorWrapper.JB_ValidateJSONDocumentStream(validator, jsonInstancePath, documentLoader, resultsCallback, null);
    
            Console.WriteLine($"Validation Success: {validationSuccess}");
    
            JSONValidatorWrapper.JB_FreeJSONSchemaValidator(validator);
        }
    }

Supported Schema Drafts
-----------------------

The following JSON Schema drafts are supported:

*   **Draft04** (0)
*   **Draft06** (1)
*   **Draft07** (2)
*   **Draft201909** (3)
*   **Draft202012** (4)

Requirements
------------

**Platform**: Windows (x64)

**.NET Standard 2.0** or higher


Changelog
---------

### Version 1.1.2

*   Added support for JSON Schema documentation and JSONPatch operations.

### Version 1.0.0

*   Initial release with standard and streaming JSON validation, minification, and prettification functionalities.

Free versus full version
-------

The following functionality is available in the free version:
*   JSON Schema validation supporting all schema drafts.
*   Prettify and minify JSON text. 

The full version includes the following additional features:
*   Streaming JSON data validation.
*   JSON Schema documentation generation.
*   Applying JSONPatch operations.

License
-------

The `JSONBuddyLibrary` wrapper included in this NuGet package is free to use under the MIT license,
allowing developers to easily integrate standard JSON validation and manipulation capabilities into their .NET applications.
However, the underlying `jsonvalidator.dll` included in the package contains advanced functionality
that requires a commercial license for full access. Users can utilize basic features without a license, but to unlock enhanced capabilities,
a valid license key must be provided. For more details on the licensing terms, please refer to the `license.txt` file included in this package.

Support
-------

For any issues or questions, please visit the github project pages at [Clemens-U/jsonbuddy](https://github.com/Clemens-U/jsonbuddy) or contact us at [office@xml-buddy.com](mailto:office@xml-buddy.com).