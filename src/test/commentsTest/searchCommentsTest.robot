*** Settings ***
Resource            ${EXECDIR}/src/resources/commonResource.robot
Resource            ${EXECDIR}/src/resources/commentsResource.robot
Suite Setup         Connect to the API

*** Test Cases ***
TC01 - Should get comment data
    [Documentation]   Acceptance Criteria: At the end of this test, a comment data has to be shown
    [Tags]    get_comment     positive

    ${comment_created}    Create a new comment
    ${comment_id}         Get value    ${comment_created}   id

    ${response}    Send a GET request on the URL to get comment data   ${comment_id}
    Status code should be   200   ${response}
    Values should be equal        ${comment_id}        ${response.json()["data"]["id"]}

    Values should be equal        ${comment_created.json()["data"]["name"]}        ${response.json()["data"]["name"]}
    Values should be equal        ${comment_created.json()["data"]["email"]}       ${response.json()["data"]["email"]}
    Values should be equal        ${comment_created.json()["data"]["body"]}        ${response.json()["data"]["body"]}

TC02 - Should return all comments
    [Documentation]   Acceptance Criteria: At the end of this test, all comments should be shown with their respective data
    [Tags]    get_comment     positive

    ${response}    Send a GET request on the URL to list all comments
    Status code should be   200   ${response}

TC03 - Should return all comments for an especific post
    [Documentation]   Acceptance Criteria: At the end of this test, all comments for an especific post should be shown with their respective data
    [Tags]    get_comment     positive

    ${comment_created}    Create a new comment
    ${comment_id}         Get value   ${comment_created}   id
    ${post_id}            Get value   ${comment_created}   post_id

    ${response}    Send a GET request on the URL to list all comments for an post   ${post_id}
    Status code should be   200   ${response}

TC04 - Should show a message when it doesn't find the comment
    [Documentation]   Acceptance Criteria: At the end of this test, the API should show the message "Resource not found"
    [Tags]    get_comment     negative

    ${response}    Send a GET request on the URL to get comment data    999999999999
    Status code should be   404   ${response}
    Should Be Equal As Strings    ${response.json()["data"]["message"]}    Resource not found
    Log Many    Expected message: Resource not found - Message on response: ${response.json()["data"]["message"]}

TC05 - Should not get a comment data when an invalid id is provided
    [Documentation]   Acceptance Criteria: At the end of this test, the API should show an error message
    [Tags]    get_comment     negative

    ${response}    Send a GET request on the URL to get comment data     DFDSS
    Status code should be   404   ${response}
    Should Be Equal As Strings    ${response.json()["data"]["message"]}    Resource not found
    Log Many    Expected message: Resource not found - Message on response: ${response.json()["data"]["message"]}
