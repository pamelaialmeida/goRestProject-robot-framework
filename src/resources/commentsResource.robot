*** Settings ***
Resource          ${EXECDIR}/src/resources/commonResource.robot
Resource          ${EXECDIR}/src/resources/usersResource.robot
Resource          ${EXECDIR}/src/resources/postsResource.robot
Library           RequestsLibrary
Library           Collections


*** Variables ***
${comments_url}        comments

*** Keywords ***
#### Actions
Send a POST request on the URL to create a new comment for a post
    [Arguments]     ${post_id}      ${request_payload}
    ${response}     Post On Session    alias=goRestAPI         url=${posts_url}/${post_id}/${comments_url}
    ...                                json=&{request_payload}    headers=${headers}    expected_status=any
    Log    ${response.json()}
    [Return]    ${response}

Send a GET request on the URL to get comment data
    [Arguments]   ${comment_id}
    ${response}    Get On Session    alias=goRestAPI    url=${comments_url}/${comment_id}    expected_status=any
    Log    ${response.json()}
    [Return]    ${response}

Send a GET request on the URL to list all comments
    ${response}    Get On Session    alias=goRestAPI    url=${comments_url}    expected_status=any
    Log    ${response.json()}
    [Return]    ${response}

Send a GET request on the URL to list all comments for an post
    [Arguments]   ${post_id}
    ${response}    Get On Session    alias=goRestAPI    url=${posts_url}/${post_id}/${comments_url}    expected_status=any
    Log    ${response.json()}
    [Return]    ${response}

Send a PUT request on the URL to update comment
    [Arguments]   ${comment_id}    ${request_payload}
    ${response}   Put On Session    alias=goRestAPI       url=${comments_url}/${comment_id}
    ...                                json=&{request_payload}    headers=${headers}    expected_status=any
    Log    ${response.json()}
    [Return]    ${response}

Send a DELETE request on the URL to delete a comment
    [Arguments]   ${comment_id}
    ${response}    Delete On Session    alias=goRestAPI    url=${comments_url}/${comment_id}    expected_status=any
    [Return]    ${response}

#### Utils
Generate comment data
    ${name}       commonResource.Generate name
    ${email}      commonResource.Generate email
    ${body}       commonResource.Generate body

    ${comment_data}     Create Dictionary    name=${name}    email=${email}   body=${body}
    [Return]    ${comment_data}

Create a new comment
    ${new_post}    Create a new post
    ${post_id}     Get value    ${new_post}   id

    ${comment}     Generate comment data

    ${comment_created}    Send a POST request on the URL to create a new comment for a post    ${post_id}    ${comment}
    [Return]    ${comment_created}
