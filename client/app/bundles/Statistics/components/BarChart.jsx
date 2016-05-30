import React, { PropTypes } from 'react'
import ReactFauxDOM from 'react-faux-dom'
import d3 from 'd3'

export default class BarChart extends React.Component {
  static propTypes = {
    data: PropTypes.arrayOf(
      PropTypes.shape({
        x: PropTypes.string.isRequired,
        y: PropTypes.number.isRequired,
        id: PropTypes.number.isRequired,
        topic: PropTypes.string.isRequired,
      })
    ).isRequired
  }

  render() {
    const data = this.props.data
    const margin = {top: 20, right: 20, bottom: 30, left: 50}
    const width = 700 - margin.left - margin.right
    const height = 400 - margin.top - margin.bottom

    const parseDate = d3.time.format('%Y-%m-%d').parse

    const x = d3.time.scale()
      .range([0, width])

    const y = d3.scale.linear()
      .range([height, 0])

    const xAxis = d3.svg.axis()
      .scale(x)
      .orient('bottom')

    const yAxis = d3.svg.axis()
      .scale(y)
      .orient('left')

    const line = d3.svg.line()
      .x(function (d) { return x(d.x) })
      .y(function (d) { return y(d.y) })

    const node = ReactFauxDOM.createElement('svg')
    const svg = d3.select(node)
				.attr('width', width + margin.left + margin.right)
				.attr('height', height + margin.top + margin.bottom)
      .append('g')
				.attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')

    data.forEach(function (d) {
      d.x = parseDate(d.x)
      d.y = +d.y
    })

    x.domain(d3.extent(data, function (d) { return d.x }))
    y.domain(d3.extent(data, function (d) { return d.y }))

    svg.append('g')
      .attr('class', 'x axis')
      .attr('transform', 'translate(0,' + height + ')')
      .call(xAxis)

    svg.append('g')
				.attr('class', 'y axis')
				.call(yAxis)
      .append('text')
				.attr('transform', 'rotate(-90)')
				.attr('y', 6)
				.attr('dy', '.71em')
				.style('text-anchor', 'end')
				.text('Anzahl')

    svg.append('path')
      .datum(data)
      .attr('class', 'line')
      .attr('d', line)

		// Scale the range of the data
    x.domain(d3.extent(data, (d) => d.x))
    y.domain(d3.extent(data, (d) => d.y))
    // @x.domain(data.map((d) => d.x))
    // @y.domain([0, d3.max(data, (d) => d.y)])

    // Select the section we want to apply our changes to
    // svg2 = d3.select(@containerSelector).transition()

    svg.select(".x.axis").transition().duration(350).call(xAxis)
    svg.select(".y.axis").transition().duration(350).call(yAxis)

    // Make the changes
    // svg2.select(".line").duration(750).attr("d", @line(data))
    const bars = svg.selectAll(".bar").data(data, (d) => d.x)
    console.log('bars', bars)

    if (data.length) {
      bars.exit().transition().duration(350)
          .attr("y", y(0))
          // .attr("height", @height - @y(0))
          .style("fill-opacity", 1e-6)
          .remove()

      bars.enter().append("rect")
          .attr("class", "bar")
          .attr("y", y(0))
          // .attr("height", @height - @y(0))

      bars.transition().duration(350)
          .attr("x", (d) => x(d.x))
          .attr("width", 2)
          .attr("y", (d) => y(d.y))
          .attr("height", (d) => height - y(d.y))
		}

    return node.toReact()



    // const margin = {
    //   top: 20,
    //   right: 20,
    //   bottom: 30,
    //   left: 50
    // }
    // const width = 850 - margin.left - margin.right
    // const height = 400 - margin.top - margin.bottom
    //
    //
    // const x = d3.time.scale().range [0, width]
    // const y = d3.scale.linear().range [height, 0]
    //
    // const xAxis = d3.svg.axis().scale(x).orient("bottom")
    // const yAxis = d3.svg.axis().scale(y).orient("left")
    //
    // const line = d3.svg.line()
    //   .x( (d) => x(d.x) )
    //   .y( (d) => y(d.y) )
    //
    // const svgNode = ReactFauxDOM.createElement('div')
    // const svg = d3.select(svgNode).append("svg")
    //     .attr("width", width + margin.left + margin.right)
    //     .attr("height", height + margin.top + margin.bottom)
    //   .append("g")
    //   .attr("transform", `translate(${margin.left},${margin.top})`)
    //
    // svg.append("g")
    //   .attr("class", "x axis")
    //   .attr("transform", `translate(0,${height})`)
    //   .call(xAxis)
    //
    // svg.append("g")
    //   .attr("class", "y axis")
    //     .call(yAxis)
    //   .append("text")
    //     .attr("transform", "rotate(-90)")
    //     .attr("y", 6)
    //     .attr("dy", ".71em")
    //     .style("text-anchor", "end")
    //     .text("Anzahl")
    //
		// // INITIAL draw
    // // $.get "/api/v1/statistics/offer_created/all.json", (rawData) =>
    // const data = [] //- _addRawData(rawData)
    //   //- @_draw('all', data)
    //   // @x.domain(d3.extent(data, (d) => d.x))
    //   // @y.domain(d3.extent(data, (d) => d.y))
    //   //
    //   // // @svg.append("path")
    //   // //     .datum(data)
    //   // //     .attr("class", "line")
    //   // //     .attr("d", @line)
    //   // @svg.selectAll(".bar")
    //   //     .data(data)
    //   //   .enter().append("rect")
    //   //     .style("fill", "steelblue")
    //   //     .attr("class", "bar")
    //   //     .attr("x", (d) => @x(d.x))
    //   //     .attr("width", 2)
    //   //     .attr("y", (d) => @y(d.y))
    //   //     .attr("height", (d) => 350 - @y(d.y))
    //
    //
		// // DRAW
		// // Scale the range of the data
    // x.domain(d3.extent(data, (d) => d.x))
    // y.domain(d3.extent(data, (d) => d.y))
    // // @x.domain(data.map((d) => d.x))
    // // @y.domain([0, d3.max(data, (d) => d.y)])
    //
    // // Select the section we want to apply our changes to
    // // svg2 = d3.select(@containerSelector).transition()
    //
    // svg.select(".x.axis").transition().duration(350).call(xAxis)
    // svg.select(".y.axis").transition().duration(350).call(yAxis)
    //
    // // Make the changes
    // // svg2.select(".line").duration(750).attr("d", @line(data))
    // bars = svg.selectAll(".bar").data(data, (d) => d.x)
    //
    // if (data.length) {
    //   bars.exit().transition().duration(350)
    //       .attr("y", y(0))
    //       // .attr("height", @height - @y(0))
    //       .style("fill-opacity", 1e-6)
    //       .remove()
    //
    //   bars.enter().append("rect")
    //       .attr("class", "bar")
    //       .attr("y", y(0))
    //       // .attr("height", @height - @y(0))
    //
    //   bars.transition().duration(350)
    //       .attr("x", (d) => x(d.x))
    //       .attr("width", 2)
    //       .attr("y", (d) => y(d.y))
    //       .attr("height", (d) => height - y(d.y))
		// }
    //
    // return svgNode.toReact()
  }
  // _addRawData: (rawData) =>
  //   data = {}
  //   for point in rawData
  //     if data[point.x]
  //       data[point.x].amount += point.y
  //     else
  //       data[point.x] =
  //         date: @_formatDate.parse(point.x)
  //         amount: +point.y
  //
  //   for key, values of data
  //     values
}
