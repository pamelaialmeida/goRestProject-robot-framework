*** Settings ***
Resource            ${EXECDIR}/src/resources/commonResource.robot
Resource            ${EXECDIR}/src/resources/postsResource.robot
Suite Setup         Connect to the API

*** Test Cases ***
TC01 - Should get post data
    [Documentation]   Acceptance Criteria: At the end of this test, a post data has to be shown
    [Tags]    get_post     positive

    ${post_created}    Create a new post
    ${post_id}         Get value    ${post_created}   id

    ${response}    Send a GET request on the URL to get post data    ${post_id}
    Status code should be   200   ${response}
    Values should be equal        ${post_id}        ${response.json()["data"]["id"]}

    Values should be equal        ${post_created.json()["data"]["user_id"]}      ${response.json()["data"]["user_id"]}
    Values should be equal        ${post_created.json()["data"]["title"]}        ${response.json()["data"]["title"]}
    Values should be equal        ${post_created.json()["data"]["body"]}         ${response.json()["data"]["body"]}

TC02 - Should return all posts
    [Documentation]   Acceptance Criteria: At the end of this test, all posts should be shown with their respective data
    [Tags]    get_post     positive

    ${response}    Send a GET request on the URL to list all posts
    Status code should be   200   ${response}

TC03 - Should return all posts for an especific user
    [Documentation]   Acceptance Criteria: At the end of this test, all posts for an especific user should be shown with their respective data
    [Tags]    get_post     positive

    ${post_created}    Create a new post
    ${post_id}         Get value   ${post_created}    id
    ${user_id}         Get value   ${post_created}    user_id

    ${response}    Send a GET request on the URL to list all posts for an user    ${user_id}
    Status code should be   200   ${response}

TC04 - Should show a message when it doesn't find the post
    [Documentation]   Acceptance Criteria: At the end of this test, the API should show the message "Resource not found"
    [Tags]    get_post     negative

    ${response}    Send a GET request on the URL to get post data    999999999999
    Status code should be   404   ${response}
    Should Be Equal As Strings    ${response.json()["data"]["message"]}    Resource not found
    Log Many    Expected message: Resource not found - Message on response: ${response.json()["data"]["message"]}

TC05 - Should not get a post data when an invalid id is provided
    [Documentation]   Acceptance Criteria: At the end of this test, the API should show an error message
    [Tags]    get_post     negative

    ${response}    Send a GET request on the URL to get post data    PITG
    Status code should be   404   ${response}
    Should Be Equal As Strings    ${response.json()["data"]["message"]}    Resource not found
    Log Many    Expected message: Resource not found - Message on response: ${response.json()["data"]["message"]}
