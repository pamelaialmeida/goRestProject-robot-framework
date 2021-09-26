*** Settings ***
Resource            ${EXECDIR}/src/resources/commonResource.robot
Resource            ${EXECDIR}/src/resources/todosResource.robot
Suite Setup         Connect to the API

*** Test Cases ***
TC01 - Should delete a todo
    [Documentation]   Acceptance Criteria: At the end of this test, a todo should have been deleted
    [Tags]    delete_todo     positive

    ${todo_created}    Create a new todo
    ${todo_id}    Get value    ${todo_created}    id

    ${response_delete_todo}    Send a DELETE request on the URL to delete a todo    ${todo_id}
    Status code should be   204   ${response_delete_todo}

    ${response_search_todo}    Send a GET request on the URL to get todo data    ${todo_id}
    Status code should be   404   ${response_search_todo}
    Should Be Equal As Strings    ${response_search_todo.json()["data"]["message"]}    Resource not found
    Log Many    Expected message: Resource not found - Message on response: ${response_search_todo.json()["data"]["message"]}

TC02 - Should show a message when it doesn't find the todo to delete
    [Documentation]   Acceptance Criteria: At the end of this test, the API should show the message "Resource not found"
    [Tags]    delete_todo     negative

    ${response}    Send a DELETE request on the URL to delete a todo    9999999999
    Status code should be   404   ${response}
    Should Be Equal As Strings    ${response.json()["data"]["message"]}    Resource not found
    Log Many    Expected message: Resource not found - Message on response: ${response.json()["data"]["message"]}

TC03 - Should not delete a todo when an invalid id is provided
    [Documentation]   Acceptance Criteria: At the end of this test, the API should show an error message
    [Tags]    delete_todo     negative

    ${response}    Send a DELETE request on the URL to delete a todo   IOLU
    Status code should be   404   ${response}
    Should Be Equal As Strings    ${response.json()["data"]["message"]}    Resource not found
    Log Many    Expected message: Resource not found - Message on response: ${response.json()["data"]["message"]}
