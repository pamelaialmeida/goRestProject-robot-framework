*** Settings ***
Resource            ${EXECDIR}/src/resources/commonResource.robot
Resource            ${EXECDIR}/src/resources/postsResource.robot
Suite Setup         Connect to the API

*** Test Cases ***
TC01 - Should update all post data
    [Documentation]   Acceptance Criteria: At the end of this test, a post should have been updated
    [Tags]    update_post     positive

    ${post_created}    Create a new post
    ${post_id}         Get value    ${post_created}   id

    ${new_post_data}        Generate post data

    ${response_post_updated}    Send a PUT request on the URL to update post    ${post_id}    ${new_post_data}
    Status code should be   200   ${response_post_updated}
    Values should be equal        ${post_id}                       ${response_post_updated.json()["data"]["id"]}

    Values should be equal        ${new_post_data["title"]}        ${response_post_updated.json()["data"]["title"]}
    Values should be equal        ${new_post_data["body"]}         ${response_post_updated.json()["data"]["body"]}

    ${response_search_post}    Send a GET request on the URL to get post data    ${post_id}
    Values should be equal        ${post_id}         ${response_search_post.json()["data"]["id"]}

    Values should be different    ${post_created.json()["data"]["title"]}    ${response_search_post.json()["data"]["title"]}
    Values should be equal        ${new_post_data["title"]}                  ${response_search_post.json()["data"]["title"]}

    Values should be different    ${post_created.json()["data"]["body"]}    ${response_search_post.json()["data"]["body"]}
    Values should be equal        ${new_post_data["body"]}                  ${response_search_post.json()["data"]["body"]}

TC02 - Should update post title
    [Documentation]   Acceptance Criteria: At the end of this test, the post title should have been updated
    [Tags]    update_post     positive

    ${post_created}    Create a new post
    ${post_id}         Get value    ${post_created}   id

    ${new_post_title}      Generate title
    ${new_post_data}       Create Dictionary    title=${new_post_title}

    ${response_post_updated}    Send a PUT request on the URL to update post    ${post_id}    ${new_post_data}
    Status code should be   200   ${response_post_updated}
    Values should be equal        ${post_id}            ${response_post_updated.json()["data"]["id"]}
    Values should be equal        ${new_post_data["title"]}    ${response_post_updated.json()["data"]["title"]}
    Values should be equal        ${post_created.json()["data"]["body"]}     ${response_post_updated.json()["data"]["body"]}

    ${response_search_post}    Send a GET request on the URL to get post data    ${post_id}
    Values should be equal        ${post_id}          ${response_search_post.json()["data"]["id"]}

    Values should be different    ${post_created.json()["data"]["title"]}    ${response_search_post.json()["data"]["title"]}
    Values should be equal        ${new_post_data["title"]}                  ${response_search_post.json()["data"]["title"]}
    Values should be equal        ${post_created.json()["data"]["body"]}     ${response_search_post.json()["data"]["body"]}

TC03 - Should update post body
    [Documentation]   Acceptance Criteria: At the end of this test, the post body should have been updated
    [Tags]    update_post     positive

    ${post_created}    Create a new post
    ${post_id}         Get value    ${post_created}   id

    ${new_post_body}      Generate body
    ${new_post_data}      Create Dictionary    body=${new_post_body}

    ${response_post_updated}    Send a PUT request on the URL to update post    ${post_id}    ${new_post_data}
    Status code should be   200   ${response_post_updated}
    Values should be equal        ${post_id}            ${response_post_updated.json()["data"]["id"]}
    Values should be equal        ${new_post_data["body"]}    ${response_post_updated.json()["data"]["body"]}
    Values should be equal        ${post_created.json()["data"]["title"]}     ${response_post_updated.json()["data"]["title"]}

    ${response_search_post}    Send a GET request on the URL to get post data    ${post_id}
    Values should be equal        ${post_id}          ${response_search_post.json()["data"]["id"]}

    Values should be different    ${post_created.json()["data"]["body"]}    ${response_search_post.json()["data"]["body"]}
    Values should be equal        ${new_post_data["body"]}                  ${response_search_post.json()["data"]["body"]}
    Values should be equal        ${post_created.json()["data"]["title"]}   ${response_search_post.json()["data"]["title"]}

TC04 - Should not update a post to invalid data
    [Documentation]   Acceptance Criteria: At the end of this test, a post should not have been updated
    [Tags]    update_post     negative

    ${post_created}    Create a new post
    ${post_id}         Get value    ${post_created}   id

    ${new_post_data}     Create Dictionary    title=${EMPTY}    body=${EMPTY}

    ${response}    Send a PUT request on the URL to update post    ${post_id}    ${new_post_data}
    Status code should be   422   ${response}
    "${response}" should have an error for "title" field with the message "can't be blank"
    "${response}" should have an error for "body" field with the message "can't be blank"

    ${response_search_post}    Send a GET request on the URL to get post data    ${post_id}
    Values should be equal        ${post_id}                                    ${response_search_post.json()["data"]["id"]}
    Values should be equal        ${post_created.json()["data"]["title"]}       ${response_search_post.json()["data"]["title"]}
    Values should be equal        ${post_created.json()["data"]["body"]}        ${response_search_post.json()["data"]["body"]}

TC05 - Should not update a post when an invalid id is provided
    [Documentation]   Acceptance Criteria: At the end of this test, the API should show an error message
    [Tags]    update_post     negative

    ${new_post_data}        Generate post data

    ${response}    Send a PUT request on the URL to update post    BNHJY    ${new_post_data}
    Status code should be   404   ${response}
    Should Be Equal As Strings    ${response.json()["data"]["message"]}    Resource not found
    Log Many    Expected message: Resource not found - Message on response: ${response.json()["data"]["message"]}

TC06 - Should show a message when it doesn't find the post to update
    [Documentation]   Acceptance Criteria: At the end of this test, the API should show the message "Resource not found"
    [Tags]    update_post     negative

    ${new_post_data}       Generate post data

    ${response}    Send a PUT request on the URL to update post    99999999    ${new_post_data}
    Status code should be   404   ${response}
    Should Be Equal As Strings    ${response.json()["data"]["message"]}    Resource not found
    Log Many    Expected message: Resource not found - Message on response: ${response.json()["data"]["message"]}
