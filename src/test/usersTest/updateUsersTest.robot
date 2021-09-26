*** Settings ***
Resource            ${EXECDIR}/src/resources/commonResource.robot
Resource            ${EXECDIR}/src/resources/usersResource.robot
Suite Setup         Connect to the API

*** Test Cases ***
TC01 - Should update user data
    [Documentation]   Acceptance Criteria: At the end of this test, a user should have been updated
    [Tags]    update_user     positive

    ${user_data_created}    Create a new user
    ${user_id}    Get value    ${user_data_created}   id

    ${new_user_data}    Generate user data

    ${response_user_updated}    Send a PUT request on the URL to update user    ${user_id}    ${new_user_data}
    Status code should be   200   ${response_user_updated}
    Values should be equal        ${user_id}                       ${response_user_updated.json()["data"]["id"]}

    Values should be equal        ${new_user_data["name"]}         ${response_user_updated.json()["data"]["name"]}
    Values should be equal        ${new_user_data["email"]}        ${response_user_updated.json()["data"]["email"]}
    Values should be equal        ${new_user_data["gender"]}       ${response_user_updated.json()["data"]["gender"]}
    Values should be equal        ${new_user_data["status"]}       ${response_user_updated.json()["data"]["status"]}

    ${response_search_user}    Send a GET request on the URL to get user data    ${user_id}
    Values should be equal        ${user_id}                                     ${response_search_user.json()["data"]["id"]}
    Values should be different    ${user_data_created.json()["data"]["name"]}    ${response_search_user.json()["data"]["name"]}
    Values should be equal        ${new_user_data["name"]}                       ${response_search_user.json()["data"]["name"]}

    Values should be different    ${user_data_created.json()["data"]["email"]}    ${response_search_user.json()["data"]["email"]}
    Values should be equal        ${new_user_data["email"]}                       ${response_search_user.json()["data"]["email"]}

    Values should be equal        ${new_user_data["gender"]}       ${response_search_user.json()["data"]["gender"]}
    Values should be equal        ${new_user_data["status"]}       ${response_search_user.json()["data"]["status"]}

TC02 - Should update user email
    [Documentation]   Acceptance Criteria: At the end of this test, the user email should have been updated
    [Tags]    update_user     positive

    ${user_data_created}    Create a new user
    ${user_id}    Get value    ${user_data_created}   id

    ${new_user_email}      Generate email
    ${new_user_data}       Create Dictionary    email=${new_user_email}

    ${response_user_updated}    Send a PUT request on the URL to update user    ${user_id}    ${new_user_data}
    Status code should be   200   ${response_user_updated}
    Values should be equal        ${user_id}                                      ${response_user_updated.json()["data"]["id"]}

    Values should be equal        ${new_user_data["email"]}                       ${response_user_updated.json()["data"]["email"]}

    Values should be equal        ${user_data_created.json()["data"]["name"]}     ${response_user_updated.json()["data"]["name"]}
    Values should be equal        ${user_data_created.json()["data"]["gender"]}   ${response_user_updated.json()["data"]["gender"]}
    Values should be equal        ${user_data_created.json()["data"]["name"]}     ${response_user_updated.json()["data"]["name"]}

    ${response_search_user}    Send a GET request on the URL to get user data    ${user_id}
    Values should be equal        ${user_id}                                     ${response_search_user.json()["data"]["id"]}

    Values should be different    ${user_data_created.json()["data"]["email"]}    ${response_search_user.json()["data"]["email"]}
    Values should be equal        ${new_user_data["email"]}                       ${response_search_user.json()["data"]["email"]}

    Values should be equal        ${user_data_created.json()["data"]["name"]}         ${response_search_user.json()["data"]["name"]}
    Values should be equal        ${user_data_created.json()["data"]["gender"]}       ${response_search_user.json()["data"]["gender"]}
    Values should be equal        ${user_data_created.json()["data"]["status"]}       ${response_search_user.json()["data"]["status"]}

TC03 - Should update user name
    [Documentation]   Acceptance Criteria: At the end of this test, the user name should have been updated
    [Tags]    update_user     positive

    ${user_data_created}    Create a new user
    ${user_id}    Get value    ${user_data_created}   id

    ${new_user_name}       Generate name
    ${new_user_data}       Create Dictionary    name=${new_user_name}

    ${response_user_updated}    Send a PUT request on the URL to update user    ${user_id}    ${new_user_data}
    Status code should be   200   ${response_user_updated}
    Values should be equal        ${user_id}                                      ${response_user_updated.json()["data"]["id"]}

    Values should be equal        ${new_user_data["name"]}                        ${response_user_updated.json()["data"]["name"]}

    Values should be equal        ${user_data_created.json()["data"]["email"]}    ${response_user_updated.json()["data"]["email"]}
    Values should be equal        ${user_data_created.json()["data"]["gender"]}   ${response_user_updated.json()["data"]["gender"]}
    Values should be equal        ${user_data_created.json()["data"]["status"]}     ${response_user_updated.json()["data"]["status"]}

    ${response_search_user}    Send a GET request on the URL to get user data    ${user_id}
    Values should be equal        ${user_id}                                     ${response_search_user.json()["data"]["id"]}

    Values should be different    ${user_data_created.json()["data"]["name"]}    ${response_search_user.json()["data"]["name"]}
    Values should be equal        ${new_user_data["name"]}                       ${response_search_user.json()["data"]["name"]}

    Values should be equal        ${user_data_created.json()["data"]["email"]}        ${response_search_user.json()["data"]["email"]}
    Values should be equal        ${user_data_created.json()["data"]["gender"]}       ${response_search_user.json()["data"]["gender"]}
    Values should be equal        ${user_data_created.json()["data"]["status"]}       ${response_search_user.json()["data"]["status"]}

TC04 - Should update user status
    [Documentation]   Acceptance Criteria: At the end of this test, the user status should have been updated
    [Tags]    update_user     positive

    ${user_data_created}    Create a new user
    ${user_id}    Get value    ${user_data_created}   id

    ${new_user_status}      Generate status
    ${new_user_data}       Create Dictionary    status=${new_user_status}

    ${response_user_updated}    Send a PUT request on the URL to update user    ${user_id}    ${new_user_data}
    Status code should be   200   ${response_user_updated}
    Values should be equal        ${user_id}                                      ${response_user_updated.json()["data"]["id"]}

    Values should be equal        ${new_user_data["status"]}                      ${response_user_updated.json()["data"]["status"]}

    Values should be equal        ${user_data_created.json()["data"]["email"]}    ${response_user_updated.json()["data"]["email"]}
    Values should be equal        ${user_data_created.json()["data"]["gender"]}   ${response_user_updated.json()["data"]["gender"]}
    Values should be equal        ${user_data_created.json()["data"]["name"]}     ${response_user_updated.json()["data"]["name"]}

    ${response_search_user}    Send a GET request on the URL to get user data    ${user_id}
    Values should be equal        ${user_id}                                     ${response_search_user.json()["data"]["id"]}

    Values should be equal        ${new_user_data["status"]}                       ${response_search_user.json()["data"]["status"]}

    Values should be equal        ${user_data_created.json()["data"]["name"]}         ${response_search_user.json()["data"]["name"]}
    Values should be equal        ${user_data_created.json()["data"]["email"]}        ${response_search_user.json()["data"]["email"]}
    Values should be equal        ${user_data_created.json()["data"]["gender"]}       ${response_search_user.json()["data"]["gender"]}

TC05 - Should update user gender
    [Documentation]   Acceptance Criteria: At the end of this test, the user gender should have been updated
    [Tags]    update_user     positive

    ${user_data_created}    Create a new user
    ${user_id}    Get value    ${user_data_created}   id

    ${new_user_gender}      Generate gender
    ${new_user_data}        Create Dictionary    gender=${new_user_gender}

    ${response_user_updated}    Send a PUT request on the URL to update user    ${user_id}    ${new_user_data}
    Status code should be   200   ${response_user_updated}
    Values should be equal        ${user_id}                                      ${response_user_updated.json()["data"]["id"]}

    Values should be equal        ${new_user_data["gender"]}                      ${response_user_updated.json()["data"]["gender"]}

    Values should be equal        ${user_data_created.json()["data"]["email"]}    ${response_user_updated.json()["data"]["email"]}
    Values should be equal        ${user_data_created.json()["data"]["status"]}   ${response_user_updated.json()["data"]["status"]}
    Values should be equal        ${user_data_created.json()["data"]["name"]}     ${response_user_updated.json()["data"]["name"]}

    ${response_search_user}    Send a GET request on the URL to get user data    ${user_id}
    Values should be equal        ${user_id}                                     ${response_search_user.json()["data"]["id"]}

    Values should be equal        ${new_user_data["gender"]}                       ${response_search_user.json()["data"]["gender"]}

    Values should be equal        ${user_data_created.json()["data"]["name"]}         ${response_search_user.json()["data"]["name"]}
    Values should be equal        ${user_data_created.json()["data"]["email"]}        ${response_search_user.json()["data"]["email"]}
    Values should be equal        ${user_data_created.json()["data"]["status"]}       ${response_search_user.json()["data"]["status"]}

TC06 - Should not update a user to invalid data
    [Documentation]   Acceptance Criteria: At the end of this test, a user should not have been updated
    [Tags]    update_user     negative

    ${user_data_created}    Create a new user
    ${user_id}    Get value    ${user_data_created}   id

    ${new_user_data}     Create Dictionary    email=invalidemail.com    gender=invalidgender   status=invalidstatus

    ${response}    Send a PUT request on the URL to update user    ${user_id}    ${new_user_data}
    Status code should be   422   ${response}
    "${response}" should have an error for "email" field with the message "is invalid"
    "${response}" should have an error for "gender" field with the message "can't be blank"
    "${response}" should have an error for "status" field with the message "can't be blank"

    ${response_search_user}    Send a GET request on the URL to get user data    ${user_id}
    Values should be equal        ${user_id}                                          ${response_search_user.json()["data"]["id"]}
    Values should be equal        ${user_data_created.json()["data"]["name"]}         ${response_search_user.json()["data"]["name"]}
    Values should be equal        ${user_data_created.json()["data"]["email"]}        ${response_search_user.json()["data"]["email"]}
    Values should be equal        ${user_data_created.json()["data"]["gender"]}       ${response_search_user.json()["data"]["gender"]}
    Values should be equal        ${user_data_created.json()["data"]["status"]}       ${response_search_user.json()["data"]["status"]}

TC07 - Should not update a user when an invalid id is provided
    [Documentation]   Acceptance Criteria: At the end of this test, the API should show an error message
    [Tags]    update_user     negative

    ${new_user_data}    Generate user data

    ${response}    Send a PUT request on the URL to update user    KJLO    ${new_user_data}
    Status code should be   404   ${response}
    Should Be Equal As Strings    ${response.json()["data"]["message"]}    Resource not found
    Log Many    Expected message: Resource not found - Message on response: ${response.json()["data"]["message"]}

TC02 - Should show a message when it doesn't find the user to update
    [Documentation]   Acceptance Criteria: At the end of this test, the API should show the message "Resource not found"
    [Tags]    update_user     negative

    ${new_user_data}    Generate user data

    ${response}    Send a PUT request on the URL to update user    99999999    ${new_user_data}
    Status code should be   404   ${response}
    Should Be Equal As Strings    ${response.json()["data"]["message"]}    Resource not found
    Log Many    Expected message: Resource not found - Message on response: ${response.json()["data"]["message"]}
