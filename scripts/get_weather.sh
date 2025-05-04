# Usage: get_weather.sh location date_start date_end
#
# e.g get_weather.sh london 2020-01-01 2020-01-02
#
# Description:
#	Get weather daily historical weather data for `location`
#	from `date_start` to `date_end.
#	
# Arguments:
# - location: string describing a location, e.g. 'manila'
#	default: manila
# - date_start: start date in YYYY-mm-dd format
#	default: current date
# - date_end: end date in YYYY-mm-dd format
#	default: current date
#


# Get command-line arguments with defaults
location=$1
if [[ "$location" == "" ]]; then
	location=manila
fi

date_start=$2
if [[ "$date_start" == "" ]]; then
	date_start=$(date +"%Y-%m-%d")
fi
date_end=$3
if [[ "$date_end" == "" ]]; then
	date_end=$date_start
fi

echo Get weather data script started

num_days=$(( ($(date -d "$date_end" +%s) - $(date -d "$date_start" +%s))/86400 + 1 ))

response_filename="response_${date_start}_${date_end}.json"
echo Response will be stored to: $response_filename


url_base="https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline"

# Construct url for location
echo Location set to \"$location\"
url="$url_base/$location"

# Construct url with date or date range
echo
echo "Getting weather for date range: \"$date_start\" to \"$date_end\" ($num_days day/s)"
url="$url/$date_start"
if [[ $num_days -gt 1 ]]; then
	url="$url/$date_end"
fi
echo
echo "url (no key, before include): $url"

url_include="include=obs,days&elements=datetime,conditions,temp,tempmax,tempmin,feelslike,feelslikemax,feelslikemin,humidity,precip,snow,uvindex,sunrise,sunset,windspeed"
echo
echo "url_include: $url_include"

echo
response=$(curl -s -w "\\n%{http_code}" "$url?key=$VISUALCROSSING_API_KEY&$url_include")

http_code=$(tail -n1 <<< "$response")

echo
if [[ "$http_code" == "200" ]]; then
	content=$(sed '$ d' <<< "$response")
	echo $content > $response_filename
	echo Response received successfully, saved to $response_filename
fi

if [[ "$http_code" != "200" ]]; then
	echo Received response with not-OK http_code=$http_code. 
	exit 1
fi



