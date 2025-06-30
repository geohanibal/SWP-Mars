import requests

url = "http://127.0.0.1:8080/publish"
payload = {
    "topic": "mqtt/test",
    "message": "Hello MQTT!",
    "qos": 1,
    "retain": False
}

response = requests.post(url, json=payload)
print(response.status_code)
print(response.json())