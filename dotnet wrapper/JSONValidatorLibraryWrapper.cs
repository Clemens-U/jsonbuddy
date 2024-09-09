using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace JSONBuddyLibrary
{
    public static class JSONValidatorWrapper
    {
        // Create a validator instance that can be used for all further operations.
        // Provide a name and a valid license key for enhanced functionality.
        // Provide empty strings to use the free version.

        [DllImport("jsonvalidator.dll", CallingConvention = CallingConvention.Cdecl, CharSet = CharSet.Unicode)]
        public static extern IntPtr JB_NewJSONSchemaValidator([MarshalAs(UnmanagedType.LPWStr)] string name, [MarshalAs(UnmanagedType.LPWStr)] string key);

        [DllImport("jsonvalidator.dll", CallingConvention = CallingConvention.Cdecl)]
        public static extern void JB_FreeJSONSchemaValidator(IntPtr validator);

        [DllImport("jsonvalidator.dll", CallingConvention = CallingConvention.Cdecl)]
        public static extern void JB_FreeString(IntPtr string_data);

        // Returns a minified version of the JSON text.
        // Fully available with the free version.

        [DllImport("jsonvalidator.dll", CallingConvention = CallingConvention.Cdecl, CharSet = CharSet.Unicode)]
        public static extern IntPtr JB_MinifyJSONText(IntPtr validator, [MarshalAs(UnmanagedType.LPWStr)] string json_text);

        // Returns a prettified version of the JSON text.
        // Fully available with the free version.

        [DllImport("jsonvalidator.dll", CallingConvention = CallingConvention.Cdecl, CharSet = CharSet.Unicode)]
        public static extern IntPtr JB_PrettifyJSONText(IntPtr validator, [MarshalAs(UnmanagedType.LPWStr)] string json_text);

        // Schema IDs
        // Undefined = -1
        // Draft04 = 0
        // Draft06 = 1
        // Draft07 = 2
        // Draft201909 = 3
        // Draft202012 = 4

        [DllImport("jsonvalidator.dll", CallingConvention = CallingConvention.Cdecl, CharSet = CharSet.Unicode)]
        public static extern bool JB_SetJSONSchemaFromString(IntPtr validator, [MarshalAs(UnmanagedType.LPWStr)] string json_schema_text, int nUseDraft);

        // Define a callback delegate for external document loading
        [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
        public delegate bool LoadDocumentCallback(
            [MarshalAs(UnmanagedType.LPWStr)] string pszPath,
            out IntPtr out_content,  // Provide as UTF-16LE
            out IntPtr out_error,    // and zero-terminated
            long nMaxFileSizeInMB
        );

        // Return false from this callback to stop the validation process.
        [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
        public delegate bool ResultsEntryAddedCallback(
            [MarshalAs(UnmanagedType.LPWStr)] string json_pointer,
            [MarshalAs(UnmanagedType.LPWStr)] string json_pointer_schema,
            [MarshalAs(UnmanagedType.LPWStr)] string schema_key,
            [MarshalAs(UnmanagedType.LPWStr)] string path_to_schema,
            bool bValid,
            long nValidationStep,
            [MarshalAs(UnmanagedType.LPWStr)] string message
        );

        [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
        public delegate bool ValidationStepAddedCallback(
            [MarshalAs(UnmanagedType.LPWStr)] string json_pointer
        );

        // Validate a large JSON document from a file stream with constant memory usage.
        // Any validation errors are reported through the callback function.
        // The document loader callback is used to load schemas directly referenced during the validation process.
        // Available with a valid license key only.

        [DllImport("jsonvalidator.dll", CallingConvention = CallingConvention.Cdecl, CharSet = CharSet.Unicode)]
        public static extern bool JB_ValidateJSONDocumentStream(
            IntPtr validator, [MarshalAs(UnmanagedType.LPWStr)] string json_instance_path, LoadDocumentCallback doc_loader, ResultsEntryAddedCallback result_callback, ValidationStepAddedCallback step_callback
        );

        // Import the JB_ValidateJSONDocument function.
        // Returns a null pointer if the validation could not start.
        // Returns an empty JSON array if the JSON instance is valid.
        // Returns a JSON array with validation results if the JSON instance is invalid.
        // The document loader callback is used to load schemas directly referenced during the validation process.
        // The free version will only return the first validation error detected.

        [DllImport("jsonvalidator.dll", CallingConvention = CallingConvention.Cdecl)]
        public static extern IntPtr JB_ValidateJSONDocument(IntPtr validator, [MarshalAs(UnmanagedType.LPWStr)] string json_instance, LoadDocumentCallback doc_loader);

        // Generate JSON Schema documentation as HTML/SVG
        // Returns a null pointer if the documentation could not be generated.
        // Samples of the generated documentation can be found at https://github.com/Clemens-U/jsonbuddy
        // Available with a valid license key only.

        [DllImport("jsonvalidator.dll", CallingConvention = CallingConvention.Cdecl)]
        public static extern IntPtr JB_GenerateJSONSchemaDocumentation(IntPtr validator, [MarshalAs(UnmanagedType.LPWStr)] string json_schema);

        // Apply JSONPatch operations to a JSON document.

        [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
        public delegate bool PatchResultCallback(
            long patch_op_index,
            bool success,
            [MarshalAs(UnmanagedType.LPWStr)] string message
	    );

        // Returns the patched JSON document.
        // Returns a null pointer if not all of the patches could be applied.
        // Available with a valid license key only.

        [DllImport("jsonvalidator.dll", CallingConvention = CallingConvention.Cdecl, CharSet = CharSet.Unicode)]
        public static extern IntPtr JB_ApplyJSONPatch(IntPtr validator, [MarshalAs(UnmanagedType.LPWStr)] string json_patch_array, [MarshalAs(UnmanagedType.LPWStr)] string json_data, PatchResultCallback results_callback);
    }
}
