*** Settings ***
Resource    resource.robot
Library     Customers_and_Products.Customers_Products   WITH NAME   cust_prod
Test Setup      Test Setup
Test Teardown   Test Teardown
Documentation    Проверка поиска данных из нескольких таблиц
Metadata    Автор   Чекмарева Софья
Metadata    Номер домашнего задания    3.1
Metadata    Папка с логами    output1
Test Timeout  10s

*** Test Cases ***
Check Horizontal Filtering
    [tags]      Customers and Products
    ${address}   ${email}   ${title}   ${price}  cust_prod.Get columns from Customers and Products From PostgRest  alias   params=select=customers!inner(address1,email),products!inner(title,price)&customers.age=gt.40&customers.state=eq.NV   expected_status=200

    ${params}    create dictionary    age=40     state=NV
    ${result}   cust_prod.Get columns from Customers and Products From DB      age=${params}[age]   state=${params}[state]
    ${address_db}   ${email_db}   ${title_db}   ${price_db}   cust_prod.Get Columns  data=${result}

    Col.Lists Should Be Equal   ${address}    ${address_db}
    Col.Lists Should Be Equal   ${email}      ${email_db}
    Col.Lists Should Be Equal   ${title}      ${title_db}
    Col.Lists Should Be Equal   ${price}      ${price_db}