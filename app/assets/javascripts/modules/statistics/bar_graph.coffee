# class Claradmin.LineGraph
#   constructor: (@containerSelector) ->
#     @_constructGraph()
#
#   toggleLine: (userId) ->
#     console.log 'toggling', userId
#     $.get "/api/v1/statistics/offer_created/#{userId}.json", (rawData) =>
#
#       lineData = @_transformData rawData
#       @_draw(userId, lineData)
#
#   _formatDate: d3.timeFormat("%Y-%m-%d")
#
#   _transformData: (rawData) ->
#     for point in rawData
#       {date: @_formatDate.parse(point.x), amount: +point.y}
#
#   _constructGraph: ->
#     margin =
#       top: 20
#       right: 20
#       bottom: 30
#       left: 50
#     @width = 850 - margin.left - margin.right
#     @height = 400 - margin.top - margin.bottom
#
#
#     @x = d3.time.scale().range [0, @width]
#     @y = d3.scale.linear().range [@height, 0]
#
#     @xAxis = d3.svg.axis().scale(@x).orient("bottom")
#     @yAxis = d3.svg.axis().scale(@y).orient("left")
#
#     @line = d3.svg.line()
#       .x( (d) => @x(d.date) )
#       .y( (d) => @y(d.amount) )
#
#     @svg = d3.select(@containerSelector).append("svg")
#         .attr("width", @width + margin.left + margin.right)
#         .attr("height", @height + margin.top + margin.bottom)
#       .append("g")
#         .attr("transform", "translate(#{margin.left},#{margin.top})")
#
#     @svg.append("g")
#       .attr("class", "x axis")
#       .attr("transform", "translate(0,#{@height})")
#       .call(@xAxis)
#
#     @svg.append("g")
#       .attr("class", "y axis")
#         .call(@yAxis)
#       .append("text")
#         .attr("transform", "rotate(-90)")
#         .attr("y", 6)
#         .attr("dy", ".71em")
#         .style("text-anchor", "end")
#         .text("Anzahl")
#
#     # INITIAL draw
#     $.get "/api/v1/statistics/offer_created/all.json", (rawData) =>
#       data = @_addRawData(rawData)
#       @_draw('all', data)
#       # @x.domain(d3.extent(data, (d) -> d.date))
#       # @y.domain(d3.extent(data, (d) -> d.amount))
#       #
#       # # @svg.append("path")
#       # #     .datum(data)
#       # #     .attr("class", "line")
#       # #     .attr("d", @line)
#       # @svg.selectAll(".bar")
#       #     .data(data)
#       #   .enter().append("rect")
#       #     .style("fill", "steelblue")
#       #     .attr("class", "bar")
#       #     .attr("x", (d) => @x(d.date))
#       #     .attr("width", 2)
#       #     .attr("y", (d) => @y(d.amount))
#       #     .attr("height", (d) => 350 - @y(d.amount))
#
#
#   _draw: (userId, data) =>
#     # Scale the range of the data
#     @x.domain(d3.extent(data, (d) -> d.date))
#     @y.domain(d3.extent(data, (d) -> d.amount))
#     # @x.domain(data.map((d) -> d.date))
#     # @y.domain([0, d3.max(data, (d) -> d.amount)])
#
#     # Select the section we want to apply our changes to
#     # svg2 = d3.select(@containerSelector).transition()
#
#     @svg.select(".x.axis").transition().duration(350).call(@xAxis)
#     @svg.select(".y.axis").transition().duration(350).call(@yAxis)
#
#     # Make the changes
#     # svg2.select(".line").duration(750).attr("d", @line(data))
#     bars = @svg.selectAll(".bar").data(data, (d) -> d.date)
#
#     if data.length
#       bars.exit().transition().duration(350)
#           .attr("y", @y(0))
#           # .attr("height", @height - @y(0))
#           .style("fill-opacity", 1e-6)
#           .remove()
#
#       bars.enter().append("rect")
#           .attr("class", "bar")
#           .attr("y", @y(0))
#           # .attr("height", @height - @y(0))
#
#       bars.transition().duration(350)
#           .attr("x", (d) => @x(d.date))
#           .attr("width", 2)
#           .attr("y", (d) => @y(d.amount))
#           .attr("height", (d) => @height - @y(d.amount))
#
#   _addRawData: (rawData) ->
#     data = {}
#     for point in rawData
#       if data[point.x]
#         data[point.x].amount += point.y
#       else
#         data[point.x] =
#           date: @_formatDate.parse(point.x)
#           amount: +point.y
#
#     for key, values of data
#       values
#
