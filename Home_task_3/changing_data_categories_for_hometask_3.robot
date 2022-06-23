*** Settings ***
Resource    resource.robot
Library     categories.Category   WITH NAME   cat
Test Setup      Test Setup
Test Teardown   Test Teardown
Documentation    Проверка поиска данных из нескольких таблиц
Metadata    Автор   Чекмарева Софья
Metadata    Номер домашнего задания    3.2
Metadata    Папка с логами    output2
Test Timeout  10s

*** Test Cases ***
Changing data
    [tags]      New data
    ${new_data}    Create Dictionary    category=17   categoryname=Thriller
    cat.Add New Data    alias    new_data=${new_data}    json=application/json
Check Horizontal Filtering
    [tags]      Сategory and Сategoryname
    ${category}     ${categoryname}  cat.Get category and categoryname From PostgRest  alias    expected_status=200

    ${result}   cat.Get category and categoryname From DB
    ${category_db}     ${categoryname_db}   cat.Get Columns  data=${result}

    Col.Lists Should Be Equal   ${category}    ${category_db}
    Col.Lists Should Be Equal   ${categoryname}      ${categoryname_db}

