class Dashing.GoogleMultiline extends Dashing.Widget

  @accessor 'current', ->
    return @get('displayedValue') if @get('displayedValue')
    points = @get('points')
    points2 = @get('points2')
    if points
      points[points.length - 1].y

    if points2
      points2[points2.length - 1].y

  ready: ->
    container = $(@node).parent()
  # Gross hacks. Let's fix this.
    width = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
    height = (Dashing.widget_base_dimensions[1] * container.data("sizey")) / 2

    colors = null
    if @get('colors')
      colors = @get('colors').split(/\s*,\s*/)

    @chart = new google.visualization.AreaChart($(@node).find(".chart")[0])
    @options =
      height: height
      width: width
      #isStacked: 'true'
      colors: colors
      backgroundColor:
        fill:'transparent'
      legend: {
        position: @get('legend_position')
        textStyle: {color: '#fff'}
      }
      animation:
        duration: 500,
        easing: 'out'
      vAxis: {
       format: @get('vaxis_format')
       curveType: @get('curve_type')
       textStyle:{color: '#fff'}
       gridlines: {
       count:-1
       color:'#303030'
       }
      }
      hAxis: {
        textStyle:{color: '#fff'}
        gridlines: {
        count:-1
        color:'#303030'
        }
      }
      

    if @get('points')
      @data = google.visualization.arrayToDataTable @get('points')
    else
      @data = google.visualization.arrayToDataTable []

    @chart.draw @data, @options

    @chart2 = new google.visualization.AreaChart($(@node).find(".chart2")[0])
    @options =
      height: height
      width: width
      #isStacked: 'true'
      colors: colors
      backgroundColor:
        fill:'transparent'
      legend: {
        position: @get('legend_position')
        textStyle: {color: '#fff'}
      }
      animation:
        duration: 500,
        easing: 'out'
      vAxis: {
       format: @get('vaxis_format')
       curveType: @get('curve_type')
       textStyle:{color: '#fff'}
       gridlines: {
       count:-1
       color:'#303030'
       }
      }
      hAxis: {
        textStyle:{color: '#fff'}
        gridlines: {
        count:-1
        color:'#303030'
        }
      }
      

    if @get('points2')
      @data = google.visualization.arrayToDataTable @get('points2')
    else
      @data = google.visualization.arrayToDataTable []

    @chart2.draw @data, @options





  onData: (data) ->
    if @chart
      @data = google.visualization.arrayToDataTable data.points
      @chart.draw @data, @options

    if @chart2
      @data = google.visualization.arrayToDataTable data.points2
      @chart2.draw @data, @options
