require "net/http"
require "uri"
require "json"


url=URI.parse("http://icsl.ee.columbia.edu:8000/api/appSupport/buildingFootprint/")

# labels = ['Day1', 'Day2', 'Day3', 'Day4', 'Day5', 'Yesterday', 'Today']
# data = [
#   {
#     label: 'First dataset',
#     data: Array.new(labels.length) { rand(40..80) },
#     backgroundColor: [ 'rgba(253, 180, 92, 0.2)' ] * labels.length,
#     borderColor: [ 'rgba(253, 180, 92, 1)' ] * labels.length,
#     borderWidth: 1,
#   }]
options = { }



SCHEDULER.every '300s' do
	response = Net::HTTP.get_response(url)
  	parsed = JSON.parse(response.body)
  	# puts parsed["history"]
  	data_array = parsed["history"]
  	data_array << parsed["energy"]
  	labels = parsed["historyStrings"]
  	puts labels
	data = [
  	{
    	label: 'Energy (Watt Hour)',
    	data: data_array,
	    # data: Array.new(labels.length) { rand(40..80) },
    	backgroundColor: [ 'rgba(253, 180, 92, 0.2)' ] * labels.length,
	    borderColor: [ 'rgba(253, 180, 92, 1)' ] * labels.length,
	    borderWidth: 1,
	}]
	send_event('barchart', { labels: labels, datasets: data, options: options })
end
