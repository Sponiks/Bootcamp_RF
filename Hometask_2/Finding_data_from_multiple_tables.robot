*** Settings ***
Resource    resource.robot
Test Setup      Test Setup
Test Teardown   Test Teardown

*** Variables ***
${SQL QUERY}                SELECT customers.address1, customers.email, products.title, products.price
...                         FROM bootcamp.customers
...                         JOIN bootcamp.cust_hist ON customers.customerid = cust_hist.customerid
...                         JOIN bootcamp.products ON cust_hist.prod_id = products.prod_id
...                         WHERE customers.age > 40 AND customers.state = 'NV'

*** Test Cases ***
Check Horizontal Filtering
    ${address}   ${email}   ${title}   ${price}   Get columns from Customers and Products From PostgRest
...                         common_table=cust_hist    params=select=customers!inner(address1,email),products!inner(title,price)&customers.age=gt.40&customers.state=eq.NV
    @{result}     Get columns from Customers and Products From DB    age=40     state=NV
    Compare results   ${result}    ${address}   ${email}   ${title}   ${price}

*** Keywords ***
Get columns from Customers and Products From PostgRest
    [Arguments]   ${common_table}   ${params}
    ${resp}       Req.GET On Session     alias    /${common_table}?     params=${params}
    ${address}    Js.get elements   ${resp.json()}    $..address1
    ${email}      Js.get elements   ${resp.json()}    $..email
    ${title}      Js.get elements   ${resp.json()}    $..title
    ${price}      Js.get elements   ${resp.json()}    $..price
    [Return]     ${address}   ${email}   ${title}   ${price}

Get columns from Customers and Products From DB
    [Arguments]     &{args}
    ${params}     create dictionary     &{args}
    @{result}     DB.Execute Sql String Mapped   ${SQL QUERY}   &{params}
    [Return]    @{result}
Compare results
    [Arguments]    ${result_from_db}   ${address}   ${email}   ${title}   ${price}
    ${address_db}    Create List
    ${email_db}    Create List
    ${title_db}    Create List
    ${price_db}    Create List

    FOR    ${k}  IN  @{result_from_db}
        ${k2}   convert to number  ${k}[price]
        Col.Append To List   ${address_db}     ${k}[address1]
        Col.Append To List   ${email_db}     ${k}[email]
        Col.Append To List   ${title_db}     ${k}[title]
        Col.Append To List   ${price_db}           ${k2}
    END
    Col.Lists Should Be Equal   ${address}    ${address_db}
    Col.Lists Should Be Equal   ${email}      ${email_db}
    Col.Lists Should Be Equal   ${title}    ${title_db}
    Col.Lists Should Be Equal   ${price}      ${price_db}
