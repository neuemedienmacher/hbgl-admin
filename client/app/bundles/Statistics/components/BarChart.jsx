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

		// Set the dimensions of the graph
    const margin = {top: 20, right: 20, bottom: 30, left: 50}
    const width = 700 - margin.left - margin.right
    const height = 400 - margin.top - margin.bottom

		// Parse the date, normalize Y
    const parseDate = d3.time.format('%Y-%m-%d').parse
    data.forEach(function (d) {
      d.x = parseDate(d.x)
      d.y = +d.y
    })

		// Set the ranges
    const x = d3.time.scale()
      .range([0, width])

    const y = d3.scale.linear()
      .range([height, 0])

		// Define the axes
    const xAxis = d3.svg.axis()
      .scale(x)
      .orient('bottom')

    const yAxis = d3.svg.axis()
      .scale(y)
      .orient('left')

		// Create in-memory DOM to construct the graph in
    const node = ReactFauxDOM.createElement('svg')

		// Add the SVG canvas
    const svg = d3.select(node)
				.attr('width', width + margin.left + margin.right)
				.attr('height', height + margin.top + margin.bottom)
      .append('g')
				.attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')

		// Scale the range of the data
    const xDomain = x.domain(d3.extent(data, function (d) { return d.x }))
    const yDomain = y.domain([0, d3.max(data, function (d) { return d.y })])

		// Add the axes
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

		// Add all data bars
    svg.selectAll('bar')
      .data(data)
    .enter().append('rect')
      .style('fill', 'steelblue')
      .attr('x', (d) => x(d.x) )
      .attr('width', (d) => {
        const next = d3.time.day.offset(d.x, 1)
        return (x(next) - x(d.x))
      })
      .attr('y', (d) => y(d.y) )
      .attr('height', (d) => height - y(d.y) )

    return node.toReact()
  }
}
