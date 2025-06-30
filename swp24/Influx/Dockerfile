FROM influxdb:1.7.4

RUN mkdir /import
COPY influx_data.txt /import/data.txt
COPY import_data.sh /docker-entrypoint-initdb.d/
RUN chmod a+x /docker-entrypoint-initdb.d/import_data.sh

ENV DOCKER_INFLUXDB_INIT_USERNAME=admin
ENV DOCKER_INFLUXDB_INIT_PASSWORD=123abc
ENV INFLUXDB_DB=openhab_db
ENV INFLUXDB_READ_USER=openhab
ENV INFLUXDB_READ_USER_PASSWORD=passwort
