*** Settings ***
Resource            ${EXECDIR}/src/resources/commonResource.robot
Resource            ${EXECDIR}/src/resources/todosResource.robot
Suite Setup         Connect to the API

*** Test Cases ***
TC01 - Should get todo data
    [Documentation]   Acceptance Criteria: At the end of this test, a todo data has to be shown
    [Tags]    get_todo     positive

    ${todo_created}    Create a new todo
    ${todo_id}         Get value    ${todo_created}   id

    ${response}    Send a GET request on the URL to get todo data    ${todo_id}
    Status code should be   200   ${response}
    Values should be equal        ${todo_id}        ${response.json()["data"]["id"]}

    Values should be equal        ${todo_created.json()["data"]["title"]}        ${response.json()["data"]["title"]}
    Values should be equal        ${todo_created.json()["data"]["status"]}       ${response.json()["data"]["status"]}

TC02 - Should return all todos
    [Documentation]   Acceptance Criteria: At the end of this test, all todos should be shown with their respective data
    [Tags]    get_todo     positive

    ${response}    Send a GET request on the URL to list all todos
    Status code should be   200   ${response}

TC03 - Should return all todos for an especific user
    [Documentation]   Acceptance Criteria: At the end of this test, all todos for an especific user should be shown with their respective data
    [Tags]    get_todo     positive

    ${todo_created}    Create a new todo
    ${todo_id}         Get value   ${todo_created}   id
    ${user_id}         Get value   ${todo_created}    user_id

    ${response}    Send a GET request on the URL to list all todos for an user   ${user_id}
    Status code should be   200   ${response}

TC04 - Should show a message when it doesn't find the todo
    [Documentation]   Acceptance Criteria: At the end of this test, the API should show the message "Resource not found"
    [Tags]    get_todo     negative

    ${response}    Send a GET request on the URL to get todo data    999999999999
    Status code should be   404   ${response}
    Should Be Equal As Strings    ${response.json()["data"]["message"]}    Resource not found
    Log Many    Expected message: Resource not found - Message on response: ${response.json()["data"]["message"]}

TC05 - Should not get a todo data when an invalid id is provided
    [Documentation]   Acceptance Criteria: At the end of this test, the API should show an error message
    [Tags]    get_todo     negative

    ${response}    Send a GET request on the URL to get todo data    DFDSS
    Status code should be   404   ${response}
    Should Be Equal As Strings    ${response.json()["data"]["message"]}    Resource not found
    Log Many    Expected message: Resource not found - Message on response: ${response.json()["data"]["message"]}
