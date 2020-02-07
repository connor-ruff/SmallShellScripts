#!/bin/sh

# Globals

URL=https://www.zipcodestogo.com/ 
STATE=Indiana
CITYBOOL=0

# Functions

usage() {
	cat 1>&2 <<EOF
USAGE: $(basename $0)

	-c		CITY  Which city to search
	-s		STATE Which state to search (Indiana)

If no CITY is specified, then all the zip codes for the STATE are displayed.
EOF
	exit $1
}

isolate() {
	 grep -Eo '>[0-9]{5}<' | sed 's/<//' | sed 's/>//'
}





# Parse Command Line Options
while [ $# -gt 0 ]; do
	case $1 in
		-h) usage 0;;
		-s) STATE=$( echo $2 | sed 's/ /%20/')
			shift  ;;
		-c)	CITY=$2
			CITYBOOL=1 
			shift ;;
		*) usage 1;;
	esac
	shift
done

# Filter Pipelines

if [ $CITYBOOL -eq 0 ] ; then
	curl -s $URL$STATE/ | isolate
else
	curl -s $URL$STATE/ | grep -E '>[0-9]{5}<' | grep "/$CITY/" | isolate 
fi
