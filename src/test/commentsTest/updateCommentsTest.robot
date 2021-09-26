*** Settings ***
Resource            ${EXECDIR}/src/resources/commonResource.robot
Resource            ${EXECDIR}/src/resources/commentsResource.robot
Suite Setup         Connect to the API

*** Test Cases ***
TC01 - Should update all comment data
    [Documentation]   Acceptance Criteria: At the end of this test, a comment should have been updated
    [Tags]    update_comment     positive

    ${comment_created}    Create a new comment
    ${comment_id}         Get value    ${comment_created}   id

    ${new_comment_data}        Generate comment data

    ${response_comment_updated}    Send a PUT request on the URL to update comment    ${comment_id}    ${new_comment_data}
    Status code should be   200   ${response_comment_updated}
    Values should be equal        ${comment_id}                    ${response_comment_updated.json()["data"]["id"]}

    Values should be equal        ${new_comment_data["name"]}        ${response_comment_updated.json()["data"]["name"]}
    Values should be equal        ${new_comment_data["email"]}       ${response_comment_updated.json()["data"]["email"]}
    Values should be equal        ${new_comment_data["body"]}        ${response_comment_updated.json()["data"]["body"]}

    ${response_search_comment}    Send a GET request on the URL to get comment data    ${comment_id}
    Values should be equal        ${comment_id}         ${response_search_comment.json()["data"]["id"]}

    Values should be different    ${comment_created.json()["data"]["name"]}    ${response_search_comment.json()["data"]["name"]}
    Values should be equal        ${new_comment_data["name"]}                  ${response_search_comment.json()["data"]["name"]}
    Values should be different    ${comment_created.json()["data"]["email"]}   ${response_search_comment.json()["data"]["email"]}
    Values should be equal        ${new_comment_data["email"]}                 ${response_search_comment.json()["data"]["email"]}
    Values should be different    ${comment_created.json()["data"]["body"]}    ${response_search_comment.json()["data"]["body"]}
    Values should be equal        ${new_comment_data["body"]}                  ${response_search_comment.json()["data"]["body"]}

TC02 - Should update comment name
    [Documentation]   Acceptance Criteria: At the end of this test, the comment name should have been updated
    [Tags]    update_comment     positive

    ${comment_created}    Create a new comment
    ${comment_id}         Get value    ${comment_created}   id

    ${new_comment_name}    Generate name
    ${new_comment_data}    Create Dictionary    name=${new_comment_name}

    ${response_comment_updated}    Send a PUT request on the URL to update comment    ${comment_id}    ${new_comment_data}
    Status code should be   200   ${response_comment_updated}
    Values should be equal        ${comment_id}                  ${response_comment_updated.json()["data"]["id"]}
    Values should be equal        ${new_comment_data["name"]}    ${response_comment_updated.json()["data"]["name"]}
    Values should be equal        ${comment_created.json()["data"]["email"]}     ${response_comment_updated.json()["data"]["email"]}
    Values should be equal        ${comment_created.json()["data"]["body"]}      ${response_comment_updated.json()["data"]["body"]}

    ${response_search_comment}    Send a GET request on the URL to get comment data    ${comment_id}
    Values should be equal        ${comment_id}          ${response_search_comment.json()["data"]["id"]}

    Values should be different    ${comment_created.json()["data"]["name"]}    ${response_search_comment.json()["data"]["name"]}
    Values should be equal        ${new_comment_data["name"]}                  ${response_search_comment.json()["data"]["name"]}
    Values should be equal        ${comment_created.json()["data"]["email"]}   ${response_search_comment.json()["data"]["email"]}
    Values should be equal        ${comment_created.json()["data"]["body"]}    ${response_search_comment.json()["data"]["body"]}

TC03 - Should update comment email
    [Documentation]   Acceptance Criteria: At the end of this test, the comment email should have been updated
    [Tags]    update_comment     positive

    ${comment_created}    Create a new comment
    ${comment_id}         Get value    ${comment_created}   id

    ${new_comment_email}   Generate email
    ${new_comment_data}    Create Dictionary    email=${new_comment_email}

    ${response_comment_updated}    Send a PUT request on the URL to update comment    ${comment_id}    ${new_comment_data}
    Status code should be   200   ${response_comment_updated}
    Values should be equal        ${comment_id}                   ${response_comment_updated.json()["data"]["id"]}
    Values should be equal        ${new_comment_data["email"]}    ${response_comment_updated.json()["data"]["email"]}
    Values should be equal        ${comment_created.json()["data"]["name"]}      ${response_comment_updated.json()["data"]["name"]}
    Values should be equal        ${comment_created.json()["data"]["body"]}      ${response_comment_updated.json()["data"]["body"]}

    ${response_search_comment}    Send a GET request on the URL to get comment data    ${comment_id}
    Values should be equal        ${comment_id}          ${response_search_comment.json()["data"]["id"]}

    Values should be different    ${comment_created.json()["data"]["email"]}    ${response_search_comment.json()["data"]["email"]}
    Values should be equal        ${new_comment_data["email"]}                  ${response_search_comment.json()["data"]["email"]}
    Values should be equal        ${comment_created.json()["data"]["name"]}     ${response_search_comment.json()["data"]["name"]}
    Values should be equal        ${comment_created.json()["data"]["body"]}     ${response_search_comment.json()["data"]["body"]}

TC04 - Should update comment body
    [Documentation]   Acceptance Criteria: At the end of this test, the comment body should have been updated
    [Tags]    update_comment     positive

    ${comment_created}    Create a new comment
    ${comment_id}         Get value    ${comment_created}   id

    ${new_comment_body}    Generate body
    ${new_comment_data}    Create Dictionary    body=${new_comment_body}

    ${response_comment_updated}    Send a PUT request on the URL to update comment    ${comment_id}    ${new_comment_data}
    Status code should be   200   ${response_comment_updated}
    Values should be equal        ${comment_id}                   ${response_comment_updated.json()["data"]["id"]}
    Values should be equal        ${new_comment_data["body"]}     ${response_comment_updated.json()["data"]["body"]}
    Values should be equal        ${comment_created.json()["data"]["name"]}      ${response_comment_updated.json()["data"]["name"]}
    Values should be equal        ${comment_created.json()["data"]["email"]}     ${response_comment_updated.json()["data"]["email"]}

    ${response_search_comment}    Send a GET request on the URL to get comment data    ${comment_id}
    Values should be equal        ${comment_id}          ${response_search_comment.json()["data"]["id"]}

    Values should be different    ${comment_created.json()["data"]["body"]}     ${response_search_comment.json()["data"]["body"]}
    Values should be equal        ${new_comment_data["body"]}                   ${response_search_comment.json()["data"]["body"]}
    Values should be equal        ${comment_created.json()["data"]["name"]}     ${response_search_comment.json()["data"]["name"]}
    Values should be equal        ${comment_created.json()["data"]["email"]}    ${response_search_comment.json()["data"]["email"]}

TC05 - Should not update a comment to invalid data
    [Documentation]   Acceptance Criteria: At the end of this test, a comment should not have been updated
    [Tags]    update_comment     negative

    ${comment_created}    Create a new comment
    ${comment_id}         Get value    ${comment_created}   id

    ${new_comment_data}     Create Dictionary    name=${EMPTY}    email=invalidemail.com    body=${EMPTY}

    ${response}    Send a PUT request on the URL to update comment    ${comment_id}    ${new_comment_data}
    Status code should be   422   ${response}
    "${response}" should have an error for "name" field with the message "can't be blank"
    "${response}" should have an error for "email" field with the message "is invalid"
    "${response}" should have an error for "body" field with the message "can't be blank"

    ${response_search_comment}    Send a GET request on the URL to get comment data    ${comment_id}
    Values should be equal        ${comment_id}                                 ${response_search_comment.json()["data"]["id"]}
    Values should be equal        ${comment_created.json()["data"]["name"]}     ${response_search_comment.json()["data"]["name"]}
    Values should be equal        ${comment_created.json()["data"]["email"]}    ${response_search_comment.json()["data"]["email"]}
    Values should be equal        ${comment_created.json()["data"]["body"]}     ${response_search_comment.json()["data"]["body"]}

TC06 - Should not update a comment when an invalid id is provided
    [Documentation]   Acceptance Criteria: At the end of this test, the API should show an error message
    [Tags]    update_comment     negative

    ${new_comment_data}        Generate comment data

    ${response}    Send a PUT request on the URL to update comment    LFGHDI    ${new_comment_data}
    Status code should be   404   ${response}
    Should Be Equal As Strings    ${response.json()["data"]["message"]}    Resource not found
    Log Many    Expected message: Resource not found - Message on response: ${response.json()["data"]["message"]}

TC07 - Should show a message when it doesn't find the comment to update
    [Documentation]   Acceptance Criteria: At the end of this test, the API should show the message "Resource not found"
    [Tags]    update_comment     negative

    ${new_comment_data}        Generate comment data

    ${response}    Send a PUT request on the URL to update comment    9999999    ${new_comment_data}
    Status code should be   404   ${response}
    Should Be Equal As Strings    ${response.json()["data"]["message"]}    Resource not found
    Log Many    Expected message: Resource not found - Message on response: ${response.json()["data"]["message"]}
