*** Settings ***
Documentation   Browser opening and Log In
Library         RPA.Browser.Selenium
Library         RPA.HTTP
Library         RPA.Excel.Files
Library         Collections
Library         RPA.PDF


*** Keywords ***
Open the internet browser
    Open Available Browser      https://robotsparebinindustries.com/#/

*** Keywords ***
Log In
    Input Text          id:username  maria
    Input Password      id:password  thoushallnotpass
    Submit Form

*** Keywords ***
Download The Excel file
    Download           https://robotsparebinindustries.com/SalesData.xlsx    overwrite=True

*** Keywords ***
Fill And Submit The Form For One Person
    [Arguments]    ${Sales_D}
    #${fname}=   Set Variable    ${Sales_D}[First Name]
    Sleep       5s
    Input Text    firstname    ${Sales_D}[First Name]
    Input Text    lastname    ${Sales_D}[Last Name]
    Input Text    salesresult    ${Sales_D}[Sales]
    ${target_as_string}=    Convert To String    ${sales_D}[Sales Target]
    Select From List By Value    salestarget    ${target_as_string}
    #Click Button    Submit
    Submit Form

*** Keywords ***
Fill the form using the data read from excel file
    Open Workbook       SalesData.xlsx
    ${Sales_Data}=      Read Worksheet As Table         header=True
    Close Workbook
    
    FOR     ${Sales_D}  IN     @{Sales_Data}
        Fill And Submit The Form For One Person     ${Sales_D}
    END

*** Keywords ***
Collect the result
    Screenshot    css:div.sales-summary     ${CURDIR}${/}output${/}sales_summary.png

*** Keywords ***
Export the table as PDF
    Wait Until Element Is Visible       id:sales-results
    ${sales_HTML}    Get Element Attribute    id:sales-results     outerHTML
    Html To Pdf    ${sales_HTML}    ${CURDIR}${/}output${/}sales_output.pdf 

*** Keywords ***
Logging out and close the broser
    Click Button    Log out
    Close Browser

*** Tasks ***
fill and submit form
    Open the internet browser
    Log In
    Download The Excel file
    Fill the form using the data read from excel file
    Collect the result
    Export the table as PDF
    [Teardown]      Logging out and close the broser


