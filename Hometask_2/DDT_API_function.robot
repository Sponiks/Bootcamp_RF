*** Settings ***
Test Setup      Test Setup
Test Teardown   Test Teardown
Test Template    Get And Check Response
Resource    resource.robot

*** Test Cases ***
Check Search One Table 200      products             price=gt.15&category=eq.2
Check Search One Table 404      prod1uctss             price=gt.15&category=eq.2
Check Search One Table 400      products            price=gt15&category=eq.2
Check Search One Table 400      products            price=gt.1ooe5&category=eq.2t

*** Keywords ***
Get And Check Response
    [Arguments]     ${table}     ${params}
    ${response}             Req.GET On Session     alias    /${table}?   params=${params}     expected_status=any
    ${response_number}      BuiltIn.Convert To String     ${response}

    run keyword if          ${response_number}[11:14] != 200    BuiltIn.Set Test Message    Error ${response_number}[11:14]     ELSE    BuiltIn.Set Test Message    Correct
