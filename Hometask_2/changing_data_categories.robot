*** Settings ***
Resource    resource.robot
Test Setup      Test Setup
Test Teardown   Test Teardown

*** Variables ***
${SQL QUERY}       SELECT * FROM bootcamp.categories

*** Test Cases ***
Changing data
    ${new_data}    Create Dictionary    category=17   categoryname=Thriller
    Add new data   ${new_data}
Check Horizontal Filtering
    ${category}     ${categoryname}   Get category and categoryname From PostgRest    table=categories
    @{result}     Get category and categoryname From DB
    Compare results   ${result}    ${category}     ${categoryname}

*** Keywords ***
Add new data
    [Arguments]     ${new_data}
    ${resp_post}       Req.POST On Session     alias       /categories?    data=${new_data}    json=application/json

Get category and categoryname From PostgRest
    [Arguments]   ${table}
    ${resp_get}       Req.GET On Session     alias    /${table}?
    ${category}          Js.get elements   ${resp_get.json()}    $..category
    ${categoryname}      Js.get elements   ${resp_get.json()}    $..categoryname
    [Return]     ${category}     ${categoryname}

Get category and categoryname From DB
    @{result}     DB.Execute Sql String Mapped   ${SQL QUERY}
    [Return]    @{result}

Compare results
    [Arguments]    ${result_from_db}   ${category}     ${categoryname}
    ${category_db}    Create List
    ${categoryname_db}    Create List

    FOR    ${k}  IN  @{result_from_db}
        ${k2}   convert to number  ${k}[category]
        Col.Append To List   ${categoryname_db}    ${k}[categoryname]
        Col.Append To List   ${category_db}        ${k2}
    END
    Col.Lists Should Be Equal   ${category}    ${category_db}
    Col.Lists Should Be Equal   ${categoryname}      ${categoryname_db}