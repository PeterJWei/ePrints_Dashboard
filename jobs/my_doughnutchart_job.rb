source = 'http://some.remote.host/doughnutchart.xml'
require "net/http"
require "uri"
require "json"


url=URI.parse("http://icsl.ee.columbia.edu:8000/api/appSupport/buildingFootprint/")


labels = ['Lights / ', 'Electrical / ', 'HVAC / ']

SCHEDULER.every '10s', :first_in => 0 do |job|
  response = Net::HTTP.get_response(url)
  puts response.body
  parsed = JSON.parse(response.body)
  puts parsed["Light"]
  puts parsed["Electrical"]
  puts parsed["HVAC"]
  labels = ['Lights / ' + parsed["Light"].to_s + ' W', 'Electrical / ' + parsed["Electrical"].to_s + ' W', 'HVAC / ' + parsed["HVAC"].to_s + ' W']
  data = [
    {
      # Create a random set of data for the chart
      #data: Array.new(3) { rand(30) },
      data: [parsed["Light"], parsed["Electrical"], parsed["HVAC"]],
      backgroundColor: [
        '#F7464A', #F7464A
        '#60BD68', #60BD68
        '#CAF270', #CAF270
      ],
      hoverBackgroundColor: [
        '#FF6384',
        '#36A2EB',
        '#FFCE56',
      ],
    },
  ]

  send_event('doughnutchart', { labels: labels, datasets: data })
end
