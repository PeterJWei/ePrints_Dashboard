require "net/http"
require "uri"
require "json"

url = URI.parse("http://icsl.ee.columbia.edu:8000/api/appSupport/buildingFootprint/")

#send_event('mychart', points:[
#	['Time', 'Energy', 'Expenses'],
#	['1', 1000, 400],
#	['2', 1170, 460],
#	['3', 660, 1120],
#	['4', 1030, 540]
#])

data = [['Time', 'Energy'], [0, 20]]

(1..500).each do |i|
	data << [i, rand(0..1000)]
end
x = data.last[0]
SCHEDULER.every '2s' do
	response = Net::HTTP.get_response(url)
	parsed = JSON.parse(response.body)
	x += 1
	dataPoint = [x, parsed["value"]]
	data.shift
	data[0] = ['Time', 'Energy']
	data << dataPoint
	#puts data[0]
	send_event('mychart', points: data)
end
