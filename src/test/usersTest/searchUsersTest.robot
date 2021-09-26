*** Settings ***
Resource            ${EXECDIR}/src/resources/commonResource.robot
Resource            ${EXECDIR}/src/resources/usersResource.robot
Suite Setup         Connect to the API

*** Test Cases ***
TC01 - Should get user data
    [Documentation]   Acceptance Criteria: At the end of this test, a user data has to be shown
    [Tags]    get_user     positive

    ${user_data_created}    Create a new user
    ${user_id}    Get value    ${user_data_created}   id

    ${response}    Send a GET request on the URL to get user data    ${user_id}
    Status code should be   200   ${response}
    Values should be equal        ${user_id}        ${response.json()["data"]["id"]}

    Values should be equal        ${user_data_created.json()["data"]["name"]}      ${response.json()["data"]["name"]}
    Values should be equal        ${user_data_created.json()["data"]["email"]}     ${response.json()["data"]["email"]}
    Values should be equal        ${user_data_created.json()["data"]["gender"]}    ${response.json()["data"]["gender"]}
    Values should be equal        ${user_data_created.json()["data"]["status"]}    ${response.json()["data"]["status"]}

TC02 - Should show a message when it doesn't find the user
    [Documentation]   Acceptance Criteria: At the end of this test, the API should show the message "Resource not found"
    [Tags]    get_user     negative

    ${response}    Send a GET request on the URL to get user data    999999999999
    Status code should be   404   ${response}
    Should Be Equal As Strings    ${response.json()["data"]["message"]}    Resource not found
    Log Many    Expected message: Resource not found - Message on response: ${response.json()["data"]["message"]}

TC03 - Should return all users data
    [Documentation]   Acceptance Criteria: At the end of this test, all users should be shown with their respective data
    [Tags]    get_user     positive

    ${response}    Send a GET request on the URL to list all users
    Status code should be   200   ${response}

TC04 - Should not get a user data when an invalid id is provided
    [Documentation]   Acceptance Criteria: At the end of this test, the API should show an error message
    [Tags]    get_user     negative

    ${response}    Send a GET request on the URL to get user data    KJLO
    Status code should be   404   ${response}
    Should Be Equal As Strings    ${response.json()["data"]["message"]}    Resource not found
    Log Many    Expected message: Resource not found - Message on response: ${response.json()["data"]["message"]}
