FROM python:3.9 as base

# Installiere die benötigte Bibliothek
RUN pip install paho-mqtt

# Setze das Arbeitsverzeichnis
WORKDIR /app

# Kopiere den gesamten mqtt-broker Ordner ins Image
COPY mqtt-broker /app/mqtt-broker

# Setze das Arbeitsverzeichnis auf den mqtt-broker Ordner
WORKDIR /app/mqtt-broker

# Starte das Broker-Skript
CMD ["python", "paho.mqtt.testing/interoperability/startbroker.py"]