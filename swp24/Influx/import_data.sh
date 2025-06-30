#!/bin/sh

# Wait for InfluxDB to start
sleep 10

# Import data from a file
influx -import -path=/import/data.txt
