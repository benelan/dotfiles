#!/usr/bin/env bash

# Show weather from openweathermap.org, requires an API key
[ -z "$OPENWEATHER_API_KEY" ] && return

if [ -n "$LONGITUDE" ] && [ -n "$LATITUDE" ]; then
    lat="$LATITUDE"
    lon="$LONGITUDE"
elif command -v jq &>/dev/null; then
    loc=$(curl --silent --show-error --fail --ipv4 \
        "https://location.services.mozilla.com/v1/geolocate?key=geoclue")
    lat=$(jq -r .location.lat <<<"$loc")
    lon=$(jq -r .location.lng <<<"$loc")
else
    loc="$(curl -Ls ipinfo.io/loc)"
    lat="$(cut -d, -f 1 <<<"$loc")"
    lon="$(cut -d, -f 2 <<<"$loc")"
fi

curl -Lso ~/.dotfiles/cache/weather.json \
    "https://api.openweathermap.org/data/2.5/weather?cnt=5&lang=en&units=imperial&lat=${lat}&lon=${lon}&appid=${OPENWEATHER_API_KEY}"
