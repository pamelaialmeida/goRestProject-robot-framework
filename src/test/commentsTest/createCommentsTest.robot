*** Settings ***
Resource            ${EXECDIR}/src/resources/commonResource.robot
Resource            ${EXECDIR}/src/resources/commentsResource.robot
Suite Setup         Connect to the API

*** Test Cases ***
TC01 - Should create a new comment for a post
    [Documentation]   Acceptance Criteria: At the end of this test, a new comment should be created for a post
    [Tags]    create_comment     positive

    ${new_post}    Create a new post
    ${post_id}     Get value    ${new_post}    id

    ${comment}     Generate comment data

    ${response}    Send a POST request on the URL to create a new comment for a post    ${post_id}    ${comment}
    Status code should be   201    ${response}
    Response payload should have an ID     ${response}
    Values should be equal    ${comment["name"]}    ${response.json()["data"]["name"]}
    Values should be equal    ${comment["email"]}   ${response.json()["data"]["email"]}
    Values should be equal    ${comment["body"]}    ${response.json()["data"]["body"]}
    Values should be equal    ${post_id}            ${response.json()["data"]["post_id"]}

    ${comment_id}    Get value    ${response}    id

    ${response_search_comment}    Send a GET request on the URL to get comment data    ${comment_id}
    Values should be equal    ${comment_id}          ${response_search_comment.json()["data"]["id"]}
    Values should be equal    ${comment["name"]}     ${response_search_comment.json()["data"]["name"]}
    Values should be equal    ${comment["email"]}    ${response_search_comment.json()["data"]["email"]}
    Values should be equal    ${comment["body"]}     ${response_search_comment.json()["data"]["body"]}
    Values should be equal    ${post_id}             ${response_search_comment.json()["data"]["post_id"]}

TC02 - Should not create a new comment with invalid data
    [Documentation]   Acceptance Criteria: At the end of this test, a new comment should not be created
    [Tags]    create_comment     negative

    ${new_post}    Create a new post
    ${post_id}     Get value    ${new_post}    id

    ${comment}     Create Dictionary    name=${EMPTY}   email=invalidemail.com    body=${EMPTY}

    ${response}    Send a POST request on the URL to create a new comment for a post     ${post_id}    ${comment}
    Status code should be   422    ${response}
    "${response}" should have an error for "name" field with the message "can't be blank"
    "${response}" should have an error for "email" field with the message "is invalid"
    "${response}" should have an error for "body" field with the message "can't be blank"

TC03 - Should not create a new comment when a required field is not sent
    [Documentation]   Acceptance Criteria: At the end of this test, a new comment should not be created
    [Tags]    create_comment     negative

    ${new_post}    Create a new post
    ${post_id}     Get value    ${new_post}    id

    ${comment}     Create Dictionary    name=${EMPTY}   email=${EMPTY}   body=${EMPTY}

    ${response}    Send a POST request on the URL to create a new comment for a post     ${post_id}    ${comment}
    Status code should be   422    ${response}
    "${response}" should have an error for "name" field with the message "can't be blank"
    "${response}" should have an error for "email" field with the message "can't be blank"
    "${response}" should have an error for "body" field with the message "can't be blank"

TC04 - Should not create a new comment for an non existent post
    [Documentation]   Acceptance Criteria: At the end of this test, a new comment should not be created
    [Tags]    create_comment     negative

    ${comment}     Generate comment data

    ${response}    Send a POST request on the URL to create a new comment for a post    999999    ${comment}
    Status code should be   422    ${response}
    "${response}" should have an error for "post" field with the message "must exist"

TC05 - Should not create a new comment for an invalid post
    [Documentation]   Acceptance Criteria: At the end of this test, a new comment should not be created
    [Tags]    create_comment     negative

    ${comment}     Generate comment data

    ${response}    Send a POST request on the URL to create a new comment for a post    UYGFD    ${comment}
    Status code should be   422    ${response}
    "${response}" should have an error for "post" field with the message "must exist"
    "${response}" should have an error for "post_id" field with the message "is not a number"
