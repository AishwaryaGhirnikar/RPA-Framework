import requests, base64, json
import shutil

def sign_language(img):
    url = "https://6n38e2kkk6.execute-api.us-east-1.amazonaws.com/0ML/"
    #read the image
    file = open(img,'rb')
    data = file.read()

    #base64 encoding
    data = base64.b64encode(data)
    data = data.decode()
    encoded_image = 'data:image/jpeg;base64,'+data
    #print(encoded_image)

    headers = {
        'Content-Type': 'application/json',
        'x-api-key': 'RZI6s6kimlaPkS1SjYClf8nNjCsi1Zma5rRJxRC3'
    }

    data = {
        'data': {
            'encoded_image': ''
        }
    }

    data['data']['encoded_image'] = encoded_image

    #api call
    response = requests.request("POST", url, headers=headers, data=json.dumps(data))

    #print(response)
    #print(response.text)
    #print(response.status_code)
    if response.status_code == 504:
        print("The model is being set up. Please try after a minute!")
    else:
        #collecting the response and save it
        response = json.loads(response.text)
        encoded_image = response['response']
        print("Detections and their confidence values")
        detections = response['detections']
        for each in detections:
            print(each)
        suffix = "." + encoded_image.split(";")[0].split("/")[1]    #checking if it is jpg or png
        encoded_image = encoded_image.split("base64,")[1].encode()  #separating "data:image/jpg;base64," and then encoding the remaining part
        
        #print(base64.b64decode(encoded_image))
        filename = str(img)+suffix
        with open(filename, 'wb') as image_file:
            image_file.write(base64.b64decode(encoded_image))
        filename = shutil.move(filename, "C:/Users/Admin/Robots/Bot Games 1/Output")    #Moves the signed images into another folder(Output)
        print("The image is saved as "+filename)
        
