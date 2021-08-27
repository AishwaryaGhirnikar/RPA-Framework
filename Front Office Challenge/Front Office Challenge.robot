
*** Settings ***
Documentation   BotGames2021
Library         RPA.Browser
Library         RPA.HTTP
Library         RPA.Desktop
Library         RPA.Tables


*** Keywords ***
Opens the browser and download csv file
    Open Available Browser      https://developer.automationanywhere.com/challenges/automationanywherelabs-customeronboarding.html 	    
    Download    https://s3-us-west-2.amazonaws.com/aai-devportal-media/wp-content/uploads/2021/07/08203317/MissingCustomers.csv    overwrite=True
    #Maximize Browser Window
    #Sleep  1s
    Click Button    id:onetrust-accept-btn-handler

*** Keywords ***
Fill the form
    [Arguments]  ${name}    ${text}
    Execute Javascript    document.getElementById('${name}').value='${text}'    

*** Keywords ***
Fill row of data
    [Arguments]   ${Customer}
    Fill the form    customerName    ${Customer}[Company Name]     
    Fill the form    customerID    ${Customer}[Customer ID]
    Fill the form    primaryContact    ${Customer}[Primary Contact]
    Fill the form    street    ${Customer}[Street Address]
    Fill the form    city    ${Customer}[City]
    Fill the form    zip    ${Customer}[Zip]
    Fill the form    email    ${Customer}[Email Address]
        
    Click       id:state #Element When Visible
    Type Text       ${Customer}[State]
    RPA.Desktop.Press Keys      Tab
    #Selects whether the Offers Discount or not
    IF    "${Customer}[Offers Discounts]"=="YES"
        Select Radio Button   exampleRadios      option1
    ELSE
        Select Radio Button   exampleRadios      option2
    END
        
        #Selects whether there is Non-Disclosure On File or not
    IF    "${Customer}[Non-Disclosure On File]"=="YES"
        Select Checkbox    NDA
    END
    
    Click Button    id:submit_button
    Sleep  0.1s
    Take Screenshot      path=C:/Users/Admin/Robots/Bot Games 1/ss.png

*** Keywords ***
Fill all rows
    [Arguments]   ${Customer_details}
    FOR     ${Customer}  IN     @{Customer_details}
        Fill row of data   ${Customer}
    END

*** Keywords ***
Open MissingCustomers.csv file
    ${Customer_details}=     Read table from CSV      MissingCustomers.csv
    Fill all rows       ${Customer_details}

*** Tasks ***
Submit the form
    Opens the browser and download csv file
    Open MissingCustomers.csv file    

