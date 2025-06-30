import publish
import standardData
import random
import time

if __name__ == '__main__':
    client = publish.connect_mqtt()
    client.loop_start()
    time.sleep(1)
    for sensor in standardData.sensors:
        publish.publish(client, sensor.topic, random.uniform(sensor.type.acceptMin, sensor.type.acceptMax))
    client.loop_stop()