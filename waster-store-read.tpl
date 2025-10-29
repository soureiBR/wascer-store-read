___INFO___

{
  "type": "MACRO",
  "id": "cvt_NS4CZ",
  "version": 1,
  "displayName": "Waster Store Read",
  "description": "The value is set to the value from a key in a Waster Store document.",
  "containerContexts": [
    "SERVER"
  ],
  "securityGroups": []
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "documentId",
    "displayName": "Document ID",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "documentKey",
    "displayName": "Field Name",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

const logToConsole = require('logToConsole');
const sendHttpRequest = require('sendHttpRequest');
const JSON = require('JSON');
const setResponseStatus = require('setResponseStatus');
const setResponseBody = require('setResponseBody');
const getRequestHeader = require('getRequestHeader');
const encodeUriComponent = require('encodeUriComponent');

const documentId = data.documentId;
const documentKey = data.documentKey;
const url = getHost();

const request = sendHttpRequest(url, {
  headers: {
    'Content-Type': 'application/json',
    'x-container-identifier': enc(getRequestHeader('x-container-identifier')),
    'x-user-id': enc(getRequestHeader('x-user-id')),
  },
  method: 'GET',
  timeout: 10000
});

return request.then((response) => { 
  if (response.statusCode === 200 && response.body) {
    const value = mapResponse(response.body);
    if (value) {
      return value;
    } else {
      logToConsole('No fields in response');
      return undefined;
    }
  } else {
    logToConsole('document', response.statusCode);
    return undefined;
  }
}).catch((error) => {
  return undefined;
});

function mapResponse(bodyString) {
  const body = JSON.parse(bodyString);
  let document = body.data;
  document = document || {};
  logToConsole('document', document);
  if (!data.documentKey) return document;

  const keys = data.documentKey.trim().split('.');
  let value = document;
  for (let i = 0; i < keys.length; i++) {
    const key = keys[i];
    if (!value || !key) break;
    value = value[key];
  }

  return value;
}

function getHost() {
  const host = getRequestHeader('x-url-api') || '';

  return (
    host +
    '/get?document_key=' +
    documentId
  );
}

function enc(data) {
  data = data || '';
  return data; // encodeUriComponent(data);
}


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "send_http",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_response",
        "versionId": "1"
      },
      "param": [
        {
          "key": "writeResponseAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "writeHeaderAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_request",
        "versionId": "1"
      },
      "param": [
        {
          "key": "headerWhitelist",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "x-container-identifier"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "x-user-id"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "x-gtm-server-preview"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "headerName"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "x-url-api"
                  }
                ]
              }
            ]
          }
        },
        {
          "key": "headersAllowed",
          "value": {
            "type": 8,
            "boolean": true
          }
        },
        {
          "key": "requestAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "headerAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "queryParameterAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 24/01/2024, 14:06:55


