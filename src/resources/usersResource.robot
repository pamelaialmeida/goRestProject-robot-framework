*** Settings ***
Resource          ${EXECDIR}/src/resources/commonResource.robot
Library           RequestsLibrary
Library           Collections


*** Variables ***
${users_url}        users
@{genders}          male    female
@{valid_status}    active    inactive

*** Keywords ***
#### Actions
Send a POST request on the URL to create a new user
    [Arguments]   ${request_payload}
    ${response}     Post On Session    alias=goRestAPI         url=${users_url}
    ...                                json=&{request_payload}    headers=${headers}    expected_status=any
    Log    ${response.json()}
    [Return]    ${response}

Send a PUT request on the URL to update user
    [Arguments]   ${user_id}    ${request_payload}
    ${response}   Put On Session    alias=goRestAPI       url=${users_url}/${user_id}
    ...                                json=&{request_payload}    headers=${headers}    expected_status=any
    Log    ${response.json()}
    [Return]    ${response}

Send a GET request on the URL to get user data
    [Arguments]   ${user_id}
    ${response}    Get On Session    alias=goRestAPI    url=${users_url}/${user_id}    expected_status=any
    Log    ${response.json()}
    [Return]    ${response}

Send a GET request on the URL to list all users
    ${response}    Get On Session    alias=goRestAPI    url=${users_url}    expected_status=any
    Log    ${response.json()}
    [Return]    ${response}

Send a DELETE request on the URL to delete a user
    [Arguments]   ${user_id}
    ${response}    Delete On Session    alias=goRestAPI    url=${users_url}/${user_id}    expected_status=any
    [Return]    ${response}

#### Utils
Generate gender
    ${gender}   Evaluate    random.choice(${genders})   random
    [Return]    ${gender}

Generate status
    ${status}   Evaluate    random.choice(${valid_status})   random
    [Return]    ${status}

Generate user data
    ${name}     commonResource.Generate name
    ${email}    commonResource.Generate email
    ${gender}   Generate gender
    ${status}   Generate status

    ${user_data}     Create Dictionary    name=${name}    email=${email}    gender=${gender}    status=${status}
    [Return]    ${user_data}
