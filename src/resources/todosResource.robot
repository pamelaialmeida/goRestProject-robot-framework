*** Settings ***
Resource          ${EXECDIR}/src/resources/commonResource.robot
Resource          ${EXECDIR}/src/resources/usersResource.robot
Library           RequestsLibrary
Library           Collections


*** Variables ***
${todos_url}            todos
@{valid_status_todo}    pending    completed

*** Keywords ***
#### Actions
Send a POST request on the URL to create a new todo for a user
    [Arguments]     ${user_id}      ${request_payload}
    ${response}     Post On Session    alias=goRestAPI         url=${users_url}/${user_id}/${todos_url}
    ...                                json=&{request_payload}    headers=${headers}    expected_status=any
    Log    ${response.json()}
    [Return]    ${response}

Send a GET request on the URL to get todo data
    [Arguments]   ${todo_id}
    ${response}    Get On Session    alias=goRestAPI    url=${todos_url}/${todo_id}    expected_status=any
    Log    ${response.json()}
    [Return]    ${response}

Send a GET request on the URL to list all todos
    ${response}    Get On Session    alias=goRestAPI    url=${todos_url}    expected_status=any
    Log    ${response.json()}
    [Return]    ${response}

Send a GET request on the URL to list all todos for an user
    [Arguments]   ${user_id}
    ${response}    Get On Session    alias=goRestAPI    url=${users_url}/${user_id}/${todos_url}    expected_status=any
    Log    ${response.json()}
    [Return]    ${response}

Send a PUT request on the URL to update todo
    [Arguments]   ${todo_id}    ${request_payload}
    ${response}   Put On Session    alias=goRestAPI       url=${todos_url}/${todo_id}
    ...                                json=&{request_payload}    headers=${headers}    expected_status=any
    Log    ${response.json()}
    [Return]    ${response}

Send a DELETE request on the URL to delete a todo
    [Arguments]   ${todo_id}
    ${response}    Delete On Session    alias=goRestAPI    url=${todos_url}/${todo_id}    expected_status=any
    [Return]    ${response}

#### Utils
Generate todo status
    ${status}   Evaluate    random.choice(${valid_status_todo})   random
    [Return]    ${status}

Generate date
    ${due_on}     FakerLibrary.Date
    [Return]    ${due_on}

Generate todo data
    ${title}     commonResource.Generate title
    ${due_on}    Generate date
    ${status}    Generate todo status

    ${todo_data}     Create Dictionary    title=${title}    due_on=${due_on}   status=${status}
    [Return]    ${todo_data}

Create a new todo
    ${new_user}    Create a new user
    ${user_id}     Get value    ${new_user}   id

    ${todo}        Generate todo data

    ${todo_created}    Send a POST request on the URL to create a new todo for a user    ${user_id}    ${todo}
    [Return]    ${todo_created}
