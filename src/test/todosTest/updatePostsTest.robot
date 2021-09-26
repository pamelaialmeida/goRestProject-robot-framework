*** Settings ***
Resource            ${EXECDIR}/src/resources/commonResource.robot
Resource            ${EXECDIR}/src/resources/todosResource.robot
Suite Setup         Connect to the API

*** Test Cases ***
TC01 - Should update all todo data
    [Documentation]   Acceptance Criteria: At the end of this test, a todo should have been updated
    [Tags]    update_todo     positive

    ${todo_created}    Create a new todo
    ${todo_id}         Get value    ${todo_created}   id

    ${new_todo_data}        Generate todo data

    ${response_todo_updated}    Send a PUT request on the URL to update todo    ${todo_id}    ${new_todo_data}
    Status code should be   200   ${response_todo_updated}
    Values should be equal        ${todo_id}                       ${response_todo_updated.json()["data"]["id"]}

    Values should be equal        ${new_todo_data["title"]}        ${response_todo_updated.json()["data"]["title"]}
    Values should be equal        ${new_todo_data["status"]}       ${response_todo_updated.json()["data"]["status"]}

    ${response_search_todo}    Send a GET request on the URL to get todo data    ${todo_id}
    Values should be equal        ${todo_id}         ${response_search_todo.json()["data"]["id"]}

    Values should be different    ${todo_created.json()["data"]["title"]}    ${response_search_todo.json()["data"]["title"]}
    Values should be equal        ${new_todo_data["title"]}                  ${response_search_todo.json()["data"]["title"]}
    Values should be equal        ${new_todo_data["status"]}                   ${response_search_todo.json()["data"]["status"]}

TC02 - Should update todo title
    [Documentation]   Acceptance Criteria: At the end of this test, the todo title should have been updated
    [Tags]    update_todo     positive

    ${todo_created}    Create a new todo
    ${todo_id}         Get value    ${todo_created}   id

    ${new_todo_title}      Generate title
    ${new_todo_data}       Create Dictionary    title=${new_todo_title}

    ${response_todo_updated}    Send a PUT request on the URL to update todo    ${todo_id}    ${new_todo_data}
    Status code should be   200   ${response_todo_updated}
    Values should be equal        ${todo_id}            ${response_todo_updated.json()["data"]["id"]}
    Values should be equal        ${new_todo_data["title"]}    ${response_todo_updated.json()["data"]["title"]}
    Values should be equal        ${todo_created.json()["data"]["status"]}     ${response_todo_updated.json()["data"]["status"]}

    ${response_search_todo}    Send a GET request on the URL to get todo data    ${todo_id}
    Values should be equal        ${todo_id}          ${response_search_todo.json()["data"]["id"]}

    Values should be different    ${todo_created.json()["data"]["title"]}    ${response_search_todo.json()["data"]["title"]}
    Values should be equal        ${new_todo_data["title"]}                  ${response_search_todo.json()["data"]["title"]}
    Values should be equal        ${todo_created.json()["data"]["status"]}   ${response_search_todo.json()["data"]["status"]}

TC03 - Should update todo status
    [Documentation]   Acceptance Criteria: At the end of this test, the todo status should have been updated
    [Tags]    update_todo     positive

    ${todo_created}    Create a new todo
    ${todo_id}         Get value    ${todo_created}   id

    ${new_todo_status}    Generate todo status
    ${new_todo_data}      Create Dictionary    status=${new_todo_status}

    ${response_todo_updated}    Send a PUT request on the URL to update todo    ${todo_id}    ${new_todo_data}
    Status code should be   200   ${response_todo_updated}
    Values should be equal        ${todo_id}            ${response_todo_updated.json()["data"]["id"]}
    Values should be equal        ${new_todo_data["status"]}    ${response_todo_updated.json()["data"]["status"]}
    Values should be equal        ${todo_created.json()["data"]["title"]}     ${response_todo_updated.json()["data"]["title"]}

    ${response_search_todo}    Send a GET request on the URL to get todo data    ${todo_id}
    Values should be equal        ${todo_id}          ${response_search_todo.json()["data"]["id"]}

    Values should be equal        ${new_todo_data["status"]}                ${response_search_todo.json()["data"]["status"]}
    Values should be equal        ${todo_created.json()["data"]["title"]}   ${response_search_todo.json()["data"]["title"]}

TC04 - Should not update a todo to invalid data
    [Documentation]   Acceptance Criteria: At the end of this test, a todo should not have been updated
    [Tags]    update_todo     negative

    ${todo_created}    Create a new todo
    ${todo_id}         Get value    ${todo_created}   id

    ${new_todo_data}     Create Dictionary    title=${EMPTY}    status=${EMPTY}

    ${response}    Send a PUT request on the URL to update todo    ${todo_id}    ${new_todo_data}
    Status code should be   422   ${response}
    "${response}" should have an error for "title" field with the message "can't be blank"
    "${response}" should have an error for "status" field with the message "can't be blank"

    ${response_search_todo}    Send a GET request on the URL to get todo data   ${todo_id}
    Values should be equal        ${todo_id}                                    ${response_search_todo.json()["data"]["id"]}
    Values should be equal        ${todo_created.json()["data"]["title"]}       ${response_search_todo.json()["data"]["title"]}
    Values should be equal        ${todo_created.json()["data"]["status"]}      ${response_search_todo.json()["data"]["status"]}

TC05 - Should not update a todo when an invalid id is provided
    [Documentation]   Acceptance Criteria: At the end of this test, the API should show an error message
    [Tags]    update_todo     negative

    ${new_todo_data}        Generate todo data

    ${response}    Send a PUT request on the URL to update todo    SDWEE    ${new_todo_data}
    Status code should be   404   ${response}
    Should Be Equal As Strings    ${response.json()["data"]["message"]}    Resource not found
    Log Many    Expected message: Resource not found - Message on response: ${response.json()["data"]["message"]}

TC06 - Should show a message when it doesn't find the todo to update
    [Documentation]   Acceptance Criteria: At the end of this test, the API should show the message "Resource not found"
    [Tags]    update_todo     negative

    ${new_todo_data}        Generate todo data

    ${response}    Send a PUT request on the URL to update todo    9999999    ${new_todo_data}
    Status code should be   404   ${response}
    Should Be Equal As Strings    ${response.json()["data"]["message"]}    Resource not found
    Log Many    Expected message: Resource not found - Message on response: ${response.json()["data"]["message"]}
