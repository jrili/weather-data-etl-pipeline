# Usage: get_weather.sh num_days
# - num_days: number of days worth data to get, from (today - num_days) up to today


num_days=$1
if [[ "$num_days" == "" ]]; then
	num_days=1
fi

echo Get weather data script started

response_filename=response_$(date +"%Y%m%d-%H%M%S").json
echo Response will be stored to: $response_filename

date_end=$(date +"%Y-%m-%d")
date_start=$(date +"%Y-%m-%d" -d "$date_end -$((num_days - 1)) days")

location=manila

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

url="$url&include=obs,days&elements=temp,tempmax,tempmin,feelslike,feelslikemax,feelslikemin,humidity,precip,uvindex,sunrise,sunset,windspeed"
echo
echo "url: $url"


#curl $url?key=$VISUALCROSSING_API_KEY > $response_filename
