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
    height = (Dashing.widget_base_dimensions[1] * container.data("sizey")) / 3

    colors = null
    if @get('colors')
      colors = @get('colors').split(/\s*,\s*/)

    
    #if @get('title1')
    title1 = @get('title1')
    title2 = @get('title2')
    title3 = @get('title3')

    @chart = new google.visualization.AreaChart($(@node).find(".chart")[0])
    @options =
      title: title1
      titleTextStyle: {color:'#F7F09B'}
      height: height
      width: width
      isStacked: 'true'
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
       viewWindowMode: 'pretty'
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
        minorGridlines: {
        count:0
        color: '#303030'
        }
      }
      

    if @get('points')
      @data = google.visualization.arrayToDataTable @get('points')
    else
      @data = google.visualization.arrayToDataTable []

    @chart.draw @data, @options

    ocolor = null
    if @get('ocolor')
      ocolor = @get('ocolor').split(/\s*,\s*/)

    #title2 = ""
    #if @get('title2')
    #  title2 = @get('title2')



    @chart2 = new google.visualization.AreaChart($(@node).find(".chart2")[0])
    @options2 =
      title: title2
      titleTextStyle: {color:'#F7F09B'}
      height: height
      width: width
      isStacked: 'true'
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
       viewWindowMode: 'pretty'
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
        minorGridlines: {
        count:0
        color: '#303030'
        }

      }
      

    if @get('points2')
      @data = google.visualization.arrayToDataTable @get('points2')
    else
      @data = google.visualization.arrayToDataTable []

    @chart2.draw @data, @options2

    #title3 = ""
    #if @get('title3')
    #  title3 = @get('title3')



    @chart3 = new google.visualization.AreaChart($(@node).find(".chart3")[0])
    @options3 =
      title: title3
      titleTextStyle: {color:'#F7F09B'}
      height: height
      width: width
      isStacked: 'true'
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
       viewWindowMode: 'pretty'
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
        minorGridlines: {
        count:0
        color: '#303030'
        }

      }
      

    if @get('points3')
      @data = google.visualization.arrayToDataTable @get('points3')
    else
      @data = google.visualization.arrayToDataTable []

    @chart3.draw @data, @options3




  onData: (data) ->
    if @chart
      @data = google.visualization.arrayToDataTable data.points
      @options.title = data.title1
      @chart.draw @data, @options

    if @chart2
      @data = google.visualization.arrayToDataTable data.points2
      @options2.title = data.title2
      @chart2.draw @data, @options2

    if @chart3
      @data = google.visualization.arrayToDataTable data.points3
      @options3.title = data.title3
      @chart3.draw @data, @options3


