*** Settings ***
Resource            ${EXECDIR}/src/resources/commonResource.robot
Resource            ${EXECDIR}/src/resources/usersResource.robot
Suite Setup         Connect to the API

*** Test Cases ***
TC01 - Should delete a user
    [Documentation]   Acceptance Criteria: At the end of this test, a user should have been deleted
    [Tags]    delete_user     positive

    ${user_data_created}    Create a new user
    ${user_id}    Get value    ${user_data_created}   id

    ${response_delete_user}    Send a DELETE request on the URL to delete a user    ${user_id}
    Status code should be   204   ${response_delete_user}

    ${response_search_user}    Send a GET request on the URL to get user data    ${user_id}
    Status code should be   404   ${response_search_user}
    Should Be Equal As Strings    ${response_search_user.json()["data"]["message"]}    Resource not found
    Log Many    Expected message: Resource not found - Message on response: ${response_search_user.json()["data"]["message"]}

TC02 - Should show a message when it doesn't find the user to delete
    [Documentation]   Acceptance Criteria: At the end of this test, the API should show the message "Resource not found"
    [Tags]    delete_user     negative

    ${response}    Send a DELETE request on the URL to delete a user    9999999999
    Status code should be   404   ${response}
    Should Be Equal As Strings    ${response.json()["data"]["message"]}    Resource not found
    Log Many    Expected message: Resource not found - Message on response: ${response.json()["data"]["message"]}

TC03 - Should not delete a user when an invalid id is provided
    [Documentation]   Acceptance Criteria: At the end of this test, the API should show an error message
    [Tags]    delete_user     negative

    ${response}    Send a DELETE request on the URL to delete a user    KJLO
    Status code should be   404   ${response}
    Should Be Equal As Strings    ${response.json()["data"]["message"]}    Resource not found
    Log Many    Expected message: Resource not found - Message on response: ${response.json()["data"]["message"]}
