*** Settings ***    
Library     RPA.FileSystem
Library     RPA.HTTP


*** Variables ***
${img_path}     C:/Users/Admin/Desktop/my tasks/sample_images
${code_path}    C:/Users/Admin/Desktop/my tasks/sign_language.py

*** Test Cases ***
Save sample images
    Copy Directory   ${img_path}  sample_images      #Copy sample images into robo

*** Test Cases ***
Save python code
    Create File  sign_language.py   overwrite= True
    Copy File  ${code_path}  sign_language.py

*** Settings ***
Library     sign_language.py 

*** Keywords ***
Apply python script
    ${images}=     List Files In Directory      sample_images
    Log   ${images}
    Create Directory   C:/Users/Admin/Robots/Sign_language/Output
    FOR   ${img}  IN    @{images}
        ${new_img}=  sign_language.sign_language   ${img}
    END



