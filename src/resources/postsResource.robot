*** Settings ***
Resource          ${EXECDIR}/src/resources/commonResource.robot
Resource          ${EXECDIR}/src/resources/usersResource.robot
Library           RequestsLibrary
Library           Collections


*** Variables ***
${posts_url}        posts

*** Keywords ***
#### Actions
Send a POST request on the URL to create a new post for a user
    [Arguments]     ${user_id}      ${request_payload}
    ${response}     Post On Session    alias=goRestAPI         url=${users_url}/${user_id}/${posts_url}
    ...                                json=&{request_payload}    headers=${headers}    expected_status=any
    Log    ${response.json()}
    [Return]    ${response}

Send a GET request on the URL to get post data
    [Arguments]   ${post_id}
    ${response}    Get On Session    alias=goRestAPI    url=${posts_url}/${post_id}    expected_status=any
    Log    ${response.json()}
    [Return]    ${response}

Send a GET request on the URL to list all posts
    ${response}    Get On Session    alias=goRestAPI    url=${posts_url}    expected_status=any
    Log    ${response.json()}
    [Return]    ${response}

Send a GET request on the URL to list all posts for an user
    [Arguments]   ${user_id}
    ${response}    Get On Session    alias=goRestAPI    url=${users_url}/${user_id}/${posts_url}    expected_status=any
    Log    ${response.json()}
    [Return]    ${response}

Send a PUT request on the URL to update post
    [Arguments]   ${post_id}    ${request_payload}
    ${response}   Put On Session    alias=goRestAPI       url=${posts_url}/${post_id}
    ...                                json=&{request_payload}    headers=${headers}    expected_status=any
    Log    ${response.json()}
    [Return]    ${response}

Send a DELETE request on the URL to delete a post
    [Arguments]   ${post_id}
    ${response}    Delete On Session    alias=goRestAPI    url=${posts_url}/${post_id}    expected_status=any
    [Return]    ${response}

#### Utils
Generate post data
    ${title}     commonResource.Generate title
    ${body}      commonResource.Generate body

    ${post_data}     Create Dictionary    title=${title}    body=${body}
    [Return]    ${post_data}
