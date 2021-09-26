*** Settings ***
Resource            ${EXECDIR}/src/resources/commonResource.robot
Resource            ${EXECDIR}/src/resources/todosResource.robot
Suite Setup         Connect to the API

*** Test Cases ***
TC01 - Should create a new todo for a user
    [Documentation]   Acceptance Criteria: At the end of this test, a new todo should be created for a user
    [Tags]    create_todo     positive

    ${new_user}    Create a new user
    ${user_id}     Get value    ${new_user}    id

    ${todo}     Generate todo data

    ${response}    Send a POST request on the URL to create a new todo for a user    ${user_id}    ${todo}
    Status code should be   201    ${response}
    Response payload should have an ID     ${response}
    Values should be equal    ${todo["title"]}    ${response.json()["data"]["title"]}
    Values should be equal    ${todo["status"]}   ${response.json()["data"]["status"]}
    Values should be equal    ${user_id}          ${response.json()["data"]["user_id"]}

    ${todo_id}    Get value    ${response}    id

    ${response_search_todo}    Send a GET request on the URL to get todo data    ${todo_id}
    Values should be equal    ${todo_id}          ${response_search_todo.json()["data"]["id"]}
    Values should be equal    ${todo["title"]}    ${response_search_todo.json()["data"]["title"]}
    Values should be equal    ${todo["status"]}   ${response_search_todo.json()["data"]["status"]}
    Values should be equal    ${user_id}          ${response_search_todo.json()["data"]["user_id"]}

TC02 - Should not create a new todo with invalid data
    [Documentation]   Acceptance Criteria: At the end of this test, a new todo should not be created
    [Tags]    create_todo     negative

    ${new_user}    Create a new user
    ${user_id}     Get value    ${new_user}    id

    ${todo}     Create Dictionary    title=${EMPTY}   status=invalidstatus

    ${response}    Send a POST request on the URL to create a new todo for a user    ${user_id}    ${todo}
    Status code should be   422    ${response}
    "${response}" should have an error for "title" field with the message "can't be blank"
    "${response}" should have an error for "status" field with the message "can't be blank"

TC03 - Should not create a new todo when a required field is not sent
    [Documentation]   Acceptance Criteria: At the end of this test, a new todo should not be created
    [Tags]    create_todo     negative

    ${new_user}    Create a new user
    ${user_id}     Get value    ${new_user}    id

    ${todo}     Create Dictionary    title=${EMPTY}   status=${EMPTY}

    ${response}    Send a POST request on the URL to create a new todo for a user    ${user_id}    ${todo}
    Status code should be   422    ${response}
    "${response}" should have an error for "title" field with the message "can't be blank"
    "${response}" should have an error for "status" field with the message "can't be blank"

TC04 - Should not create a new todo for an non existent user
    [Documentation]   Acceptance Criteria: At the end of this test, a new todo should not be created
    [Tags]    create_todo     negative

    ${todo}     Generate todo data

    ${response}    Send a POST request on the URL to create a new todo for a user    999999    ${todo}
    Status code should be   422    ${response}
    "${response}" should have an error for "user" field with the message "must exist"

TC05 - Should not create a new todo for an invalid user
    [Documentation]   Acceptance Criteria: At the end of this test, a new todo should not be created
    [Tags]    create_todo     negative

    ${todo}     Generate todo data

    ${response}    Send a POST request on the URL to create a new todo for a user    UYGFD    ${todo}
    Status code should be   422    ${response}
    "${response}" should have an error for "user" field with the message "must exist"
    "${response}" should have an error for "user_id" field with the message "is not a number"
