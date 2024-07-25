// jsonvalidator.h : main header file for the jsonvalidator DLL
//

#pragma once

#include <string>
#include <list>

#define _JSON_VALIDATOR_DLL_API_ __declspec(dllimport)

class JSONSchemaValidationResult
{
public:
	JSONSchemaValidationResult() : m_type(k_nTypeUndefined) { }

	typedef enum {
		k_nTypeUndefined,
		k_nTypeError,
		k_nTypeWarning
	} TJSONSchemaValidationResultType;

	TJSONSchemaValidationResultType	m_type;
	std::string m_message;
};

typedef std::list<JSONSchemaValidationResult> JSONSchemaValidationResultsT;
typedef JSONSchemaValidationResultsT::iterator JSONSchemaValidationResultsItrT;


class JSONSchemaSubSchemaResult
{
public:
	JSONSchemaSubSchemaResult()
	:	m_bValid(true),
		m_nValidationStep(0)
	{
	}

	virtual ~JSONSchemaSubSchemaResult() { }

	std::string m_strJSONPointer;			// location in data
	std::string m_strJSONPointerSchema;		// location in schema
	std::string m_strSchemaKey;				// exact key violated validation
	std::string m_strPathToSchema;
	bool m_bValid;							// sub-schema validation status
	size_t m_nValidationStep;				// step count at time of insertion
	JSONSchemaValidationResultsT m_results;	// detailed results

	typedef std::list<JSONSchemaSubSchemaResult> JSONSchemaSubSchemaResultsT;
	typedef JSONSchemaSubSchemaResultsT::iterator JSONSchemaSubSchemaResultsItrT;
	typedef JSONSchemaSubSchemaResultsT::const_iterator JSONSchemaSubSchemaResultsItrConstT;
};

class DocumentLoader
{
public:
	virtual bool LoadDocument(
		wchar_t* pszPath,
		std::string& strOutContent,
		std::string& strOutError,
		long nMaxFileSizeInMB
	) = 0;
};


class _JSON_VALIDATOR_DLL_API_ JSONSchemaValidator
{
public:
	typedef enum {
		k_nJSONSchemaIDDraft04,
		k_nJSONSchemaIDDraft06,
		k_nJSONSchemaIDDraft07,
		k_nJSONSchemaIDDraft201909,
		k_nJSONSchemaIDDraft202012,
		k_nJSONSchemaIDUndefined
	} TJSONSchemaSchemaID;

	virtual void SetJSONSchema(
		std::string json_schema_path,
		TJSONSchemaSchemaID use_draft		// set to undefined if the draft version should be detected from schema
	) = 0;

	virtual void SetJSONSchemaFromString(
		std::string json_schema,
		TJSONSchemaSchemaID nUseDraft		// set to undefined if the draft version should be detected from schema
	) = 0;

	// Returns true if validation was executed.
	// The free version will only report an invalid sub-schema result.
	// In the free version we only return the first invalid result.
	// The free version only supports JSON instance documents with a maximum count of 10k characters.

	virtual bool ValidateJSONDocument(
		std::string json_instance,
		DocumentLoader* doc_loader,
		JSONSchemaSubSchemaResult::JSONSchemaSubSchemaResultsT& out_results
	) = 0;

	virtual void Free() = 0;
};

_JSON_VALIDATOR_DLL_API_ JSONSchemaValidator* NewJSONSchemaValidator();
_JSON_VALIDATOR_DLL_API_ void FreeJSONSchemaValidator(JSONSchemaValidator* validator);

_JSON_VALIDATOR_DLL_API_ bool LocateJSONPointer(std::string json_pointer, std::string& json_instance, long& nLine, long& nPos, long& nLength, std::string& out_message);