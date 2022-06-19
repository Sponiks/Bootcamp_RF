*** Settings ***
Documentation     This file has test cases for list of numbers
Library    Collections

*** Variables ***
@{Numbers}    ${1}  ${2}  ${3}  ${5}  ${1}  ${0}  ${-1}  ${10}

*** Test Cases ***
Show min and max of the list
    ${min}=    BuiltIn.Evaluate    min($numbers)
    ${max}=    BuiltIn.Evaluate    max($numbers)
    log    The minimum value is ${min}
    log    The maximum value is ${max}
    Set Test Message    The minimum (${min}) and maximum (${max}) of the list were found

Show unique list values
    ${Unique_numbers}     Create List
    ${Unique_numbers}=    Collections.Remove Duplicates    ${Numbers}
    Log    Unique list is ${Unique_numbers}
    Set Test Message    Now there are no duplicates here ${Unique_numbers}

Finding the sum of all values
    ${sum}=    BuiltIn.Evaluate    sum($numbers)
    log    The sum of all numbers is ${sum}
    Set Test Message    The calculated sum of all the numbers is ${sum}