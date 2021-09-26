*** Settings ***
Resource            ${EXECDIR}/src/resources/commonResource.robot
Resource            ${EXECDIR}/src/resources/commentsResource.robot
Suite Setup         Connect to the API

*** Test Cases ***
TC01 - Should delete a comment
    [Documentation]   Acceptance Criteria: At the end of this test, a comment should have been deleted
    [Tags]    delete_comment     positive

    ${comment_created}    Create a new comment
    ${comment_id}    Get value    ${comment_created}    id

    ${response_delete_comment}    Send a DELETE request on the URL to delete a comment    ${comment_id}
    Status code should be   204   ${response_delete_comment}

    ${response_search_comment}    Send a GET request on the URL to get comment data    ${comment_id}
    Status code should be   404   ${response_search_comment}
    Should Be Equal As Strings    ${response_search_comment.json()["data"]["message"]}    Resource not found
    Log Many    Expected message: Resource not found - Message on response: ${response_search_comment.json()["data"]["message"]}

TC02 - Should show a message when it doesn't find the comment to delete
    [Documentation]   Acceptance Criteria: At the end of this test, the API should show the message "Resource not found"
    [Tags]    delete_comment     negative

    ${response}    Send a DELETE request on the URL to delete a comment    9999999999
    Status code should be   404   ${response}
    Should Be Equal As Strings    ${response.json()["data"]["message"]}    Resource not found
    Log Many    Expected message: Resource not found - Message on response: ${response.json()["data"]["message"]}

TC03 - Should not delete a comment when an invalid id is provided
    [Documentation]   Acceptance Criteria: At the end of this test, the API should show an error message
    [Tags]    delete_comment     negative

    ${response}    Send a DELETE request on the URL to delete a comment   OLKJH
    Status code should be   404   ${response}
    Should Be Equal As Strings    ${response.json()["data"]["message"]}    Resource not found
    Log Many    Expected message: Resource not found - Message on response: ${response.json()["data"]["message"]}
