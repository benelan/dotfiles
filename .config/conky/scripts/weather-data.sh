#!/usr/bin/env sh

# Show weather from openweathermap.org, requires an API key
if [ -z "$OPEN_WEATHER_MAP_API_KEY" ]; then
    return
fi

loc="$(curl -Ls ipinfo.io | jq -r '.loc')"
lat="$(echo "$loc" | cut -d ',' -f 1)"
lon="$(echo "$loc" | cut -d ',' -f 2)"

curl -Lso ~/.dotfiles/cache/weather.json \
    "https://api.openweathermap.org/data/2.5/weather?cnt=5&lang=en&units=imperial&lat=${lat}&lon=${lon}&appid=${OPEN_WEATHER_MAP_API_KEY}"
