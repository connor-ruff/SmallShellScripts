#!/bin/sh

#Globals
URL="https://forecast.weather.gov/zipcity.php"
ZIPCODE=46556
FORECAST=0
CELSIUS=0

# Functions

usage() {
	cat 1>&2 <<EOF
Usage: $(basename $0) [zipcode]

-c	Use Celsius degrees instead of Fahrenheit for temperature
-f	Display forecast text

If zipcode is not provided, then it default to $ZIPCODE.
EOF
	exit $1
}


weather_information() {
	curl -sL $URL?inputstring=$ZIPCODE | grep "myforecast-current" | grep -o '>.*<' | sed 's/>//' | sed 's/<//'
}

temperature() {
	

	if [ $CELSIUS -eq 1 ] ; then
	weather_information | sed 1d | sed 1d | grep -Eo '^[^&]*'
	else
	weather_information | grep -Eo '.*;F' | grep -Eo '^[^&]*'
	fi
}

forecast(){
	if [ $FORECAST -eq 1 ] ; then
		weather_information | sed 2d | sed 2d | sed 's/^\s*//'
	fi
}


while [ $# -gt 0 ]; do
	case $1 in
		-h) usage 0 ;;
		-f) FORECAST=1 ;;
		-c) CELSIUS=1 ;;
		*) ZIPCODE=$1 ;;
	esac
	shift
done

if [ $FORECAST -eq 1 ] ; then
	echo "Forecast:    $(forecast)"
fi
 echo "Temperature: $(temperature) degrees"
