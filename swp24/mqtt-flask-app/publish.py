import random
import sys
import time
import paho.mqtt.client as mqtt_client

broker = 'localhost'
port = 1883
topic = 'mqtt/test'
client_id = f'python-mqtt-{random.randint(0,1000)}'

def connect_mqtt():
    def on_connect(client, userdata, falgs, rc, properties):
        if rc == 0:
            print("Connected to MQTT Broker!")
        else:
            print("Failed to connect.")

    client = mqtt_client.Client(client_id=client_id, callback_api_version=mqtt_client.CallbackAPIVersion.VERSION2)
    client.on_connect = on_connect
    client.connect(broker, port)
    return client
    

def publish(client, topic, msg, qos = 0, retain = False):
    result = client.publish(topic, msg, qos, retain)
    status = result[0]
    if status == 0:
        print(f"Send `{msg}` to topic `{topic}`")
    else:
        print(f"Failed to send message to topic {topic}")

def run(topic, msg, qos = 0, retain = False):
    client = connect_mqtt()
    client.loop_start()
    time.sleep(1)
    publish(client, topic, msg, qos, retain)
    client.loop_stop()

def strToBool(s):
    if s.lower() in ('true', '1', 't', 'y', 'yes'):
        return True
    elif s.lower() in ('false', '0', 'f', 'n', 'no'):
        return False
    else:
        raise ValueError("Cannot convert string to bool.")

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print("Not enough arguments. Use `python publish.py topic message`'")
        sys.exit(1)
    elif len(sys.argv) < 4:
        run(sys.argv[1],sys.argv[2])
    else:
        qos = int(sys.argv[3])
        if qos > 2 or qos < 0:
            print("Invalid Quality of Service! Use a value between 0 and 2.")
        else:
            run(sys.argv[1], sys.argv[2], int(sys.argv[3]), strToBool(sys.argv[4]))
