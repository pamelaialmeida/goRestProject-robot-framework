*** Settings ***
Resource            ${EXECDIR}/src/resources/commonResource.robot
Resource            ${EXECDIR}/src/resources/usersResource.robot
Suite Setup         Connect to the API

*** Test Cases ***
TC01 - Should create a new user
    [Documentation]   Acceptance Criteria: At the end of this test, a new user should be created
    [Tags]    create_user     positive

    ${user}     Generate user data

    ${response}    Send a POST request on the URL to create a new user    ${user}
    Status code should be   201    ${response}
    Response payload should have an ID     ${response}
    Values should be equal    ${user["name"]}     ${response.json()["data"]["name"]}
    Values should be equal    ${user["email"]}    ${response.json()["data"]["email"]}
    Values should be equal    ${user["gender"]}   ${response.json()["data"]["gender"]}
    Values should be equal    ${user["status"]}   ${response.json()["data"]["status"]}

    ${user_id}    Get value    ${response}    id

    ${response_search_user}    Send a GET request on the URL to get user data    ${user_id}
    Values should be equal    ${user_id}          ${response_search_user.json()["data"]["id"]}
    Values should be equal    ${user["name"]}     ${response_search_user.json()["data"]["name"]}
    Values should be equal    ${user["email"]}    ${response_search_user.json()["data"]["email"]}
    Values should be equal    ${user["gender"]}   ${response_search_user.json()["data"]["gender"]}
    Values should be equal    ${user["status"]}   ${response_search_user.json()["data"]["status"]}

TC02 - Should not create a new user when a required field is not sent
    [Documentation]   Acceptance Criteria: At the end of this test, a new user should not be created
    [Tags]    create_user     negative

    ${user_status}    Generate status
    ${user}     Create Dictionary    status=${user_status}

    ${response}    Send a POST request on the URL to create a new user    ${user}
    Status code should be   422    ${response}
    "${response}" should have an error for "name" field with the message "can't be blank"
    "${response}" should have an error for "email" field with the message "can't be blank"
    "${response}" should have an error for "gender" field with the message "can't be blank"

TC03 - Should not create a new user with invalid data
    [Documentation]   Acceptance Criteria: At the end of this test, a new user should not be created
    [Tags]    create_user     negative

    ${user}     Create Dictionary    email=invalidemail.com    gender=invalidgender   status=invalidstatus

    ${response}    Send a POST request on the URL to create a new user    ${user}
    Status code should be   422    ${response}
    "${response}" should have an error for "name" field with the message "can't be blank"
    "${response}" should have an error for "email" field with the message "is invalid"
    "${response}" should have an error for "gender" field with the message "can't be blank"
    "${response}" should have an error for "status" field with the message "can't be blank"
