#!/bin/bash

# Generate a report filename based on the current data for the raw data
today=$(date +%Y%m%d)
weather_report=raw_data_$today

# Make a curl call to the API to get weather data
city=Casablanca
curl "wttr.in/$city" --output $weather_report

# Grab only the data we care about which has the tempratures in Celsius
grep °C $weather_report > temperatures.txt

# Exract out today's noon temperature out of the first line
obs_temp=$(head -1 temperatures.txt | tr -s " " | xargs | rev | cut -d " " -f2 | rev)

# Extract out tomorrow's noon temperature using a combination of filtering down to the 3rd line and cutting out the data we care about
fc_temp=$(head -3 temperatures.txt | tail -1 | tr -s " " | xargs | cut -d "C" -f2 | rev | cut -d " " -f2 |rev)

# Generate some Timezone information for our report using the Morocco/Casablnaca TZ.
hour=$(TZ='Morocco/Casablanca' date -u +%H) 
day=$(TZ='Morocco/Casablanca' date -u +%d) 
month=$(TZ='Morocco/Casablanca' date +%m)
year=$(TZ='Morocco/Casablanca' date +%Y)

# Record the readings from today into our report log
record=$(echo -e "$year\t$month\t$day\t$hour\t$obs_tmp\t$fc_temp")
echo $record>>rx_poc.log
