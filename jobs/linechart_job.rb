points = []
(1..10).each do |i|
	points << {x: i, y: rand(50) }
end
last_x = points.last[:x]


#SCHEDULER.EVERY '2s' do
#	points.shift
#	last_x += 1
#	points << { x: last_x, y: rand(50) }
#	send_event('linechart', {labels: points[x], datasets: points[y], options: options})
#end

#labels = [1,2,3,4,5,6]
labels = [ points.last[:x] ]
puts points
data = [
	{
		label: 'test',
		data: Array.new(labels.length) { rand(0..10) },
		backgroundColor: [ 'rgba(255, 99, 132, 0.2)' ] * labels.length,
		borderColor: [ 'rgba(255, 99, 132, 1)' ] * labels.length,
		borderWidth: 1,
	}
]
#last_points = 
options = {}
SCHEDULER.every '5s' do
	send_event('linechart', { labels: labels, datasets: data, options: options })
end
