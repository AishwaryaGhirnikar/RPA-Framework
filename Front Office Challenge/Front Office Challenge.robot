
*** Settings ***
Documentation   Front Office Challenge
Library         RPA.Browser
Library         RPA.HTTP
Library         RPA.Desktop
Library         RPA.Tables


*** Keywords ***
Opens the browser and download csv file
    Open Available Browser      https://developer.automationanywhere.com/challenges/automationanywherelabs-customeronboarding.html 	    
    Download    https://s3-us-west-2.amazonaws.com/aai-devportal-media/wp-content/uploads/2021/07/08203317/MissingCustomers.csv    overwrite=True
    Maximize Browser Window
    #Sleep  1s
    Click Button    id:onetrust-accept-btn-handler


*** Keywords ***
Fill the form
    #Extract the customer details
    [Arguments]    ${Customer_details}
    
    #Loop over the custoer details
    FOR     ${Customer}  IN     @{Customer_details}
        
        #Fills up details from customerName to email
        Input Text    customerName    ${Customer}[Company Name]     
        Input Text    customerID    ${Customer}[Customer ID]
        Input Text    primaryContact    ${Customer}[Primary Contact]
        Input Text    street    ${Customer}[Street Address]
        Input Text    city    ${Customer}[City]

        Click Element When Visible      id:state
        Type Text       ${Customer}[State]
        RPA.Desktop.Press Keys      Tab

        Input Text    zip    ${Customer}[Zip]
        Input Text    email    ${Customer}[Email Address]

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

    END
    Sleep  0.1s
    Take Screenshot      path=C:/Users/Admin/Robots/Bot Games 1/ss.png 
    
    
*** Keywords ***
Open MissingCustomers.csv file  
    ${Customer_details}=     Read table from CSV      MissingCustomers.csv
    Fill the form     ${Customer_details}
   
   
*** Tasks ***
Submit the form
    Opens the browser and download csv file
    Open MissingCustomers.csv file  
