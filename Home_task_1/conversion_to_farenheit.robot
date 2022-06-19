*** Settings ***
Documentation    This file has test case for checking the degree conversion formula
Library    Collections

*** Test Cases ***
Celsios to Fahrenheit
    ${celsios}      Create List    ${0}    ${350}    ${-32}    ${100}
    ${fahrenheit}   Create List    ${32}    ${662}    ${-25.6}    ${212}
    ${result}=    Degree conversion formula       ${celsios}
    Should Be Equal     ${result}   ${fahrenheit}
    Set Test Message    The degree values are calculated correctly

*** Keywords ***
Degree conversion formula
    [Arguments]    ${t_c}
    ${result}       Create List
    FOR    ${t}    IN    @{t_c}
        ${step}=    Evaluate    9 / 5 * ${t} + 32
        Collections.Append To List    ${result}    ${step}
    END
    [Return]    ${result}