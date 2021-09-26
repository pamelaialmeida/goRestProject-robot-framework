*** Settings ***
Resource            ${EXECDIR}/src/resources/commonResource.robot
Resource            ${EXECDIR}/src/resources/postsResource.robot
Suite Setup         Connect to the API

*** Test Cases ***
TC01 - Should delete a post
    [Documentation]   Acceptance Criteria: At the end of this test, a post should have been deleted
    [Tags]    delete_post     positive

    ${post_created}    Create a new post
    ${post_id}    Get value    ${post_created}    id

    ${response_delete_post}    Send a DELETE request on the URL to delete a post    ${post_id}
    Status code should be   204   ${response_delete_post}

    ${response_search_post}    Send a GET request on the URL to get post data    ${post_id}
    Status code should be   404   ${response_search_post}
    Should Be Equal As Strings    ${response_search_post.json()["data"]["message"]}    Resource not found
    Log Many    Expected message: Resource not found - Message on response: ${response_search_post.json()["data"]["message"]}

TC02 - Should show a message when it doesn't find the post to delete
    [Documentation]   Acceptance Criteria: At the end of this test, the API should show the message "Resource not found"
    [Tags]    delete_post     negative

    ${response}    Send a DELETE request on the URL to delete a post    9999999999
    Status code should be   404   ${response}
    Should Be Equal As Strings    ${response.json()["data"]["message"]}    Resource not found
    Log Many    Expected message: Resource not found - Message on response: ${response.json()["data"]["message"]}

TC03 - Should not delete a post when an invalid id is provided
    [Documentation]   Acceptance Criteria: At the end of this test, the API should show an error message
    [Tags]    delete_post     negative

    ${response}    Send a DELETE request on the URL to delete a post    IOLU
    Status code should be   404   ${response}
    Should Be Equal As Strings    ${response.json()["data"]["message"]}    Resource not found
    Log Many    Expected message: Resource not found - Message on response: ${response.json()["data"]["message"]}
