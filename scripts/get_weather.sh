num_days=$1
if [ "num_days" == "" ]; then
	num_days=1
fi


response_filename=response_$(date +"%Y%m%d-%H%M%S").json
echo Response will be stored to: $response_filename

date_end=$(date +"%Y-%m-%d")
date_start=$(date +"%Y-%m-%d" -d "$date_start -$((num_days - 1)) days")

echo Getting weather for date range: \"$date_start\" to \"$date_end\"

url="https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/manila/$date_start/$date_end&include=obs,days&elements=temp,tempmax,tempmin,feelslike,feelslikemax,feelslikemin,humidity,precip,uvindex,sunrise,sunset,windspeed"
echo "url: $url"


#curl $url?key=$VISUALCROSSING_API_KEY > $response_filename
