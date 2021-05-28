# +
*** Settings ***
Documentation     Orders robots from RobotSpareBin Industries Inc.
...               Saves the order HTML receipt as a PDF file.
...               Saves the screenshot of the ordered robot.
...               Embeds the screenshot of the robot to the PDF receipt.
...               Creates ZIP archive of the receipts and the images.

Library           RPA.Browser.Selenium
Library           RPA.Excel.Files
Library           RPA.HTTP
Library           RPA.Tables
Library           RPA.PDF
Library           RPA.Archive
Library           RPA.Dialogs
Library           RPA.Robocloud.Secrets
Library           RPA.Desktop
# -

*** Variables ***
#${CSV_FILE_URL}=    https://robotsparebinindustries.com/orders.csv
#${GLOBAL_RETRY_AMOUNT}=    10x
#${GLOBAL_RETRY_INTERVAL}=    1s
${order_number}

*** Keywords ***
Open the robot order website  
    ${url}=    Get Secret    credentials
    Open Available Browser      ${url}[robotsparebin]
    
    Create Form    Orders.csv URL
    Add Text Input    URL    url
    &{response}    Request Response
    [Return]    ${response["url"]}

*** Keywords ***
Get orders
    Download    https://robotsparebinindustries.com/orders.csv      overwrite=True
    ${table}=    Read Table From Csv    orders.csv
    FOR     ${row}  IN  @{table}
        Log     ${row}
    END
    [Return]    ${table}

*** Keywords ***
Close the annoying modal
    Click Button	xpath=/html/body/div/div/div[2]/div/div/div/div/div/button[1]

*** Keywords ***
Fill the form
    [Arguments]    ${localrow}
    #${head}=    Convert To Integer    ${localrow}[Head]
    #${body}=    Convert To Integer    ${localrow}[Body]
    #${legs}=    Convert To Integer    ${localrow}[Legs]
    #${address}=    Convert To String    ${localrow}[Address]
    
    Select From List By Value   id:head   ${localrow}[Head]
    #Click Element When Visible        id:head
    #Type Text       ${localrow}[Head]
    #RPA.Desktop.Press Keys      Tab
    Click Element   id-body-${localrow}[Body]
    Input Text      id:address    ${localrow}[Address]
    Input Text      xpath:/html/body/div/div/div[1]/div/div[1]/form/div[3]/input    ${localrow}[Legs]

*** Keywords ***
Preview the robot
    Click Element    id:preview
    Wait Until Element Is Visible    id:robot-preview

*** Keywords ***
Submit the order And Keep Checking Until Success
    Click Element    order
    Element Should Be Visible    xpath://div[@id="receipt"]/p[1]
    Element Should Be Visible    id:order-completion

*** Keywords ***
Submit the order
    Wait Until Keyword Succeeds    10x    1s     Submit the order And Keep Checking Until Success
    

*** Keywords ***
Store the receipt as a PDF file
    [Arguments]    ${order_number}
    Wait Until Element Is Visible    id:order-completion
    ${order_number}=    Get Text    xpath://div[@id="receipt"]/p[1]
    #Log    ${order_number}
    ${receipt_html}=    Get Element Attribute    id:order-completion    outerHTML
    Html To Pdf    ${receipt_html}    ${CURDIR}${/}output${/}receipts${/}${order_number}.pdf
    [Return]    ${CURDIR}${/}output${/}receipts${/}${order_number}.pdf

*** Keywords ***
Take a screenshot of the robot
    [Arguments]    ${order_number}
    Screenshot     id:robot-preview    ${CURDIR}${/}output${/}${order_number}.png
    [Return]       ${CURDIR}${/}output${/}${order_number}.png


*** Keywords ***
Embed the robot screenshot to the receipt PDF file
    [Arguments]    ${screenshot}   ${pdf}
    Open Pdf Document       ${pdf}
    Add Watermark Image To PDF  ${screenshot}    ${pdf}
    Close Pdf Document      ${pdf}


*** Keywords ***
Go to order another robot
    Click Button    order-another

*** Keywords ***
Create a ZIP file of the receipts
    Archive Folder With Zip  ${CURDIR}${/}output${/}receipts   ${CURDIR}${/}output${/}receipt.zip

*** Tasks ***
Order robots from RobotSpareBin Industries Inc
    Open the robot order website
    ${orders}=    Get orders
    FOR    ${row}    IN    @{orders}
        Close the annoying modal
        Fill the form    ${row}
        Preview the robot
        Submit the order
        ${pdf}=    Store the receipt as a PDF file    ${row}[Order number]
        ${screenshot}=    Take a screenshot of the robot    ${row}[Order number]
        #Embed the robot screenshot to the receipt PDF file    ${screenshot}    ${pdf}
        Go to order another robot
    END
    Create a ZIP file of the receipts
    [Teardown]      Close Browser


