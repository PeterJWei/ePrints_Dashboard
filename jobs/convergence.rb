require "net/http"
require "uri"
require "json"


url=URI.parse("http://icsl.ee.columbia.edu:8000/api/appSupport/buildingFootprint/")


# Populate the graph with some random points
points = []
(1..1000).each do |i|
  points << { x: i, y: rand(50) }
end
last_x = points.last[:x]

SCHEDULER.every '2s' do
  response = Net::HTTP.get_response(url)
  parsed = JSON.parse(response.body)
  puts parsed["value"]
  points.shift
  last_x += 1
  points << { x: last_x, y: parsed["value"] }

  send_event('convergence', points: points)
end
