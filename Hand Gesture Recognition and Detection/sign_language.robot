*** Settings ***    
Library     RPA.FileSystem
Library     RPA.HTTP


*** Variables ***
${img_path}     C:/Users/Admin/Desktop/my tasks/sample_images
${code_path}    C:/Users/Admin/Desktop/my tasks/sign_language.py

*** Test Cases ***
Save sample images
    Copy Directory   ${img_path}  images                #Copy sample images into images directory

*** Test Cases ***
Save python code
    Create File  sign_language.py   overwrite= True     #Create python file
    Copy File  ${code_path}  sign_language.py           #Copy python script

*** Settings ***
Library     sign_language.py                            #Declare python file in robot code

*** Keywords ***
Apply python script
    ${images}=     List Files In Directory      images                  #Create list of sample_images
    Log   ${images}
    Create Directory   C:/Users/Admin/Robots/Sign_language/Output       #Create 'Output' directory to store output signed images
    FOR   ${img}  IN    @{images}                                       #Loop through sample_images
        ${new_img}=  sign_language.sign_language   ${img}               #Calling of python script into robot code
    END



