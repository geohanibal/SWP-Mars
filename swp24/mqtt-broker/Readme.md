
Zunächst müsst ihr, das Repository klonen. Da hier ein Git-Submodule
verwendet wird, müsst ihr git Clone allerdings wie folgt aufrufen:

```
git clone --recurse-submodules git@gitlab.informatik.uni-bremen.de:swp2024/mqtt-broker.git
```

Dadurch wird das Modul automatisch von GitHub mitgeklont. Um nun die
Skripte benutzen zu können, müsst ihr aber noch das Paho MQTT Python
Package installieren:

```
pip install paho-mqtt
```

Im mitgelieferten Verzeichnis sind zwei Dateien für euch besonders
wichtig:

1. **__startBroker.py:__**

   Wird benötigt, um den Broker zu starten.  
   Der Broker wird so lange ausgeführt, wie die Konsole geöffnet bleibt.
2. **__publish.py:__**

   Wird zum Senden von Nachrichten an den Broker verwendet.

   Zum Senden muss entweder

   ```
   python publish.py topic message
   ```

   oder

   ```
   python publish.py topic message qos retain
   ```

   verwendet werden.

   Dabei ist Quality of Service (QoS) eine Ganzzahl zwischen einschließlich 0 und 2.

   Retain wird als Boolean oder boolische Interpretation angegeben.

Die Datei **__SubscribeClientTest.py__** dient lediglich dazu, zu
Überprüfen, ob der Broker die gesendete Nachricht korrekt verteilt.
Alternativ könnt ihr auch einen anderen MQTT-Explorer verwenden, wie
beispielsweise [diesen hier](https://github.com/thomasnordquist/MQTT-Explorer/tree/v0.3.5).
Die verschiedenen Versionen des Explorers sind [hier](https://github.com/thomasnordquist/MQTT-Explorer/releases/tag/v0.3.5)
zu finden.

Das Unterverzeichnis \`**paho.mqtt.testing**\` enthält den Broker und darf nicht modifiziert werden.

In dem Unterverzeichnis \`**Optional**\` befinden sich folgende Dateien:

- **publishOnAllTopicsInAcceptance.py:**

  Kann verwendet werden, um auf allen Topics einen zufälligen Wert im Akzeptanzbereich zu veröffentlichen.
- **publishOnAllTopicsInCritMax.py:**

  Kann verwendet werden, um auf allen Topics einen zufälligen Wert im Maximalbereich zu veröffentlichen.
- **publishOnAllTopicsInCritMin.py:**

  Kann verwendet werden, um auf allen Topics einen zufälligen Wert im Minimalbereich zu veröffentlichen.
- **standardData.py:**

  Diese Datei stellt die Daten für die zuvor genannten drei Skripte bereit.
