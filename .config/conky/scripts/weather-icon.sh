#!/usr/bin/env sh

# Nerd font icons for openweathermap.org data
# https://openweathermap.org/weather-conditions
ICON_01D="󰖙 "
ICON_01N="󰖔 "
ICON_02D="󰖕 "
ICON_02N="󰼱 "
ICON_03="󰖐 "
ICON_04="󰖞 "
ICON_09="󰖖 "
ICON_10="󰖗 "
ICON_11="󰖓 "
ICON_13="󰖘 "
ICON_50="󰖑 "
NO_DATA=" "

WEATHER_CACHE="$DOTFILES/cache/weather.json"
mkdir -p "$(dirname "$WEATHER_CACHE")"
WEATHER_ICON=$(jq -r '.weather[0].icon' <"$WEATHER_CACHE")

case $WEATHER_ICON in
    *01d*) echo "${ICON_01D}" ;;
    *01n*) echo "${ICON_01N}" ;;
    *02d*) echo "${ICON_02D}" ;;
    *02n*) echo "${ICON_02N}" ;;
    *03d* | *03n*) echo "${ICON_03}" ;;
    *04d* | *04n*) echo "${ICON_04}" ;;
    *09d* | *09n*) echo "${ICON_09}" ;;
    *10d* | *10n*) echo "${ICON_10}" ;;
    *11d* | *11n*) echo "${ICON_11}" ;;
    *13d* | *13n*) echo "${ICON_13}" ;;
    *50d* | *50n*) echo "${ICON_50}" ;;
    *) echo "${NO_DATA}" ;;
esac
