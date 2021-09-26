*** Settings ***
Resource            ${EXECDIR}/src/resources/commonResource.robot
Resource            ${EXECDIR}/src/resources/postsResource.robot
Suite Setup         Connect to the API

*** Test Cases ***
TC01 - Should create a new post for a user
    [Documentation]   Acceptance Criteria: At the end of this test, a new post should be created for a user
    [Tags]    create_post     positive

    ${new_user}    Create a new user
    ${user_id}    Get value    ${new_user}    id

    ${post}     Generate post data

    ${response}    Send a POST request on the URL to create a new post for a user    ${user_id}    ${post}
    Status code should be   201    ${response}
    Response payload should have an ID     ${response}
    Values should be equal    ${post["title"]}    ${response.json()["data"]["title"]}
    Values should be equal    ${post["body"]}     ${response.json()["data"]["body"]}
    Values should be equal    ${user_id}          ${response.json()["data"]["user_id"]}

    ${post_id}    Get value    ${response}    id

    ${response_search_post}    Send a GET request on the URL to get post data    ${post_id}
    Values should be equal    ${post_id}          ${response_search_post.json()["data"]["id"]}
    Values should be equal    ${post["title"]}    ${response_search_post.json()["data"]["title"]}
    Values should be equal    ${post["body"]}     ${response_search_post.json()["data"]["body"]}
    Values should be equal    ${user_id}          ${response_search_post.json()["data"]["user_id"]}

TC02 - Should not create a new post when a required field is not sent
    [Documentation]   Acceptance Criteria: At the end of this test, a new post should not be created
    [Tags]    create_post     negative

    ${new_user}    Create a new user
    ${user_id}    Get value    ${new_user}    id

    ${post}     Create Dictionary    title=${EMPTY}   body=${EMPTY}

    ${response}    Send a POST request on the URL to create a new post for a user    ${user_id}    ${post}
    Status code should be   422    ${response}
    "${response}" should have an error for "title" field with the message "can't be blank"
    "${response}" should have an error for "body" field with the message "can't be blank"

TC03 - Should not create a new post for an non existent user
    [Documentation]   Acceptance Criteria: At the end of this test, a new post should not be created
    [Tags]    create_post     negative

    ${post}     Generate post data

    ${response}    Send a POST request on the URL to create a new post for a user    99999999    ${post}
    Status code should be   422    ${response}
    "${response}" should have an error for "user" field with the message "must exist"

TC04 - Should not create a new post for an invalid user
    [Documentation]   Acceptance Criteria: At the end of this test, a new post should not be created
    [Tags]    create_post     negative

    ${post}     Generate post data

    ${response}    Send a POST request on the URL to create a new post for a user    KPLI    ${post}
    Status code should be   422    ${response}
    "${response}" should have an error for "user" field with the message "must exist"
    "${response}" should have an error for "user_id" field with the message "is not a number"
