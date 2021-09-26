*** Settings ***
Resource          ${EXECDIR}/src/resources/usersResource.robot
Resource          ${EXECDIR}/src/resources/postsResource.robot
Library           RequestsLibrary
Library           BuiltIn
Library           FakerLibrary
Library           Collections

*** Variables ***
${api_url}         https://gorest.co.in/public/v1

*** Keywords ***
#### Actions
Connect to the API
    ${headers}    Create Dictionary    content-type=application/json
    ...                                Authorization=Bearer 86d060ed1e9770df6a8b4dacc49ac88c9f955b9a224bc4603fe347c4ecad636d

    Create Session    alias=goRestAPI    url=${api_url}   headers=${headers}    verify=true

    Set Suite Variable    ${headers}

#### Validations
Status code should be
    [Arguments]   ${expected_status_code}   ${response}
    Should Be Equal As Integers    ${response.status_code}   ${expected_status_code}
    Log Many      Expected status code: ${expected_status_code} - Obtained status code: ${response.status_code}

Response payload should have an ID
    [Arguments]   ${response}
    Dictionary Should Contain Key    ${response.json()["data"]}    id
    Log    ${response.json()["data"]["id"]}

Values should be equal
    [Arguments]   ${first_value}    ${second_value}
    Should Be Equal As Strings    ${first_value}    ${second_value}
    Log Many    Value on request: ${first_value} - Value on response: ${second_value}

Values should be different
    [Arguments]   ${first_value}    ${second_value}
    Should Not Be Equal As Strings    ${first_value}    ${second_value}
    Log Many    Value on request: ${first_value} - Value on response: ${second_value}

"${response}" should have an error for "${field}" field with the message "${error_message}"
    FOR   ${erro}   IN     @{response.json()["data"]}
      IF    "${erro["field"]}"=="${field}"
          Should Be Equal As Strings    ${erro["message"]}    ${error_message}
          Log Many    Expected error message: ${error_message} - Erros message on response: ${erro["message"]}
          Exit For Loop
      END
    END

#### Utils
Generate name
    ${name}     FakerLibrary.Name
    [Return]    ${name}

Generate email
    ${email}    FakerLibrary.Email
    [Return]    ${email}

Generate title
    ${title}    FakerLibrary.Text   max_nb_chars=50
    [Return]    ${title}

Generate body
    ${body}    FakerLibrary.Text   max_nb_chars=100
    [Return]    ${body}

Get value
    [Arguments]   ${response_payload}   ${value_to_get}
    ${value}    Get From Dictionary    ${response_payload.json()["data"]}    ${value_to_get}
    [Return]    ${value}

Create a new user
    ${user}     Generate user data

    ${user_created}    Send a POST request on the URL to create a new user    ${user}
    [Return]    ${user_created}

Create a new post
    ${new_user}    Create a new user
    ${user_id}     Get value    ${new_user}   id

    ${post}        Generate post data

    ${post_created}    Send a POST request on the URL to create a new post for a user    ${user_id}    ${post}
    [Return]    ${post_created}
