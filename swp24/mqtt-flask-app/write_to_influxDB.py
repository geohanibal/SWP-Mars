from influxdb_client import InfluxDBClient, Point
from influxdb_client.client.write_api import SYNCHRONOUS
from standardData import sensors, chat  # Importiere deine Daten

# InfluxDB Konfiguration
INFLUXDB_URL = "http://localhost:8086"  # Ersetze durch deine InfluxDB-Adresse
INFLUXDB_TOKEN = "my_secret_token"  # Ersetze durch deinen Token
INFLUXDB_ORG = "my_organization"  # Ersetze durch deinen Organization-Namen
INFLUXDB_BUCKET = "swp-data"  # Ersetze durch deinen Bucket-Namen

# InfluxDB-Client initialisieren
client = InfluxDBClient(url=INFLUXDB_URL, token=INFLUXDB_TOKEN, org=INFLUXDB_ORG)
write_api = client.write_api(write_options=SYNCHRONOUS)

def write_sensor_data_to_influxdb():
    for sensor in sensors:
        point = Point("sensor_data") \
            .tag("type", sensor.type.typeName) \
            .tag("topic", sensor.topic) \
            .field("minCriticalLower", float(sensor.type.minCriticalLower)) \
            .field("minCriticalUpper", float(sensor.type.minCriticalUpper)) \
            .field("acceptMin", float(sensor.type.acceptMin)) \
            .field("acceptMax", float(sensor.type.acceptMax)) \
            .field("maxCriticalLower", float(sensor.type.maxCriticalLower)) \
            .field("maxCriticalUpper", float(sensor.type.maxCriticalUpper))


        # Daten schreiben
        write_api.write(bucket=INFLUXDB_BUCKET, org=INFLUXDB_ORG, record=point)
    print("Sensor-Daten erfolgreich geschrieben.")


if __name__ == "__main__":
    write_sensor_data_to_influxdb()

    # Verbindung schließen
    client.close()