import requests

def handler(event, context):
    # Insira o código para comunicação com a API do Google Chat aqui
    # Por exemplo:
    message = "Hello from Lambda!"
    requests.post("https://chat.googleapis.com/v1/spaces/XXX/messages", data={"text": message})
    return message
