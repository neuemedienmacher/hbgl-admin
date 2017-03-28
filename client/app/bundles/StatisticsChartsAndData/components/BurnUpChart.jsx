import React, { PropTypes } from 'react'
import ReactFauxDOM from 'react-faux-dom'
import { line } from 'd3-shape'
import { max, extent } from 'd3-array'
import { select } from 'd3-selection'
import * as d3 from 'd3'

export default class BurnUpChart extends React.Component {
  // static propTypes = {
  //   data: PropTypes.arrayOf(
  //     PropTypes.shape({
  //       x: PropTypes.string.isRequired,
  //       y: PropTypes.number.isRequired,
  //       id: PropTypes.number.isRequired,
  //       topic: PropTypes.string.isRequired,
  //     })
  //   ).isRequired
  // }

  render() {
    const { cursorX, cursorY, visibility, fixedCursorY, x, y, xAxis,
            yAxis, width, height, margin, allData, parseDate,
            xValueOnCursorX, yValueOnCursorX,
            dailyYValueOnCursorX, graphHeightFactor, scopeData, actualData,
            idealData, projectionData } = this.props

    // Create in-memory DOM to construct the graph in
    const node = ReactFauxDOM.createElement('svg');

    // Add the SVG canvas
    const svg = d3.select(node)
      .attr('width', width + margin.left + margin.right)
      .attr('height', height + margin.top + margin.bottom)
      .append('g')
      .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')


    // Scale the range of the data
    const xDomain = x.domain(extent(allData, function (d) { return d.x }))
    const yDomain = y.domain([
      0,
      Math.round(Math.max(
        max(actualData, function (d) { return d.y }),
        max(scopeData, function (d) { return d.y })
      ) * graphHeightFactor)
    ])

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

    // Add orientation line for the deadline
    const actualDeadline = svg.append('g')
      .attr('class', 'deadline-group')
    actualDeadline.append('line')
      .attr('x1', x(idealData[1].x))
      .attr('y1', y(0))
      .attr('x2', x(idealData[1].x))
      .attr('y2', y(max(allData, (d) => d.y)))
      .attr('class', 'line deadline')

    actualDeadline.append('text')
      .attr('x', x(idealData[1].x) - 42)
      .attr('y', height - 9)
      .attr('dy', '.71em')
      .text('Deadline')

    const xCoordLine = svg.append('g')
      .attr('class', 'x coord line')
    xCoordLine.append('line')
      .style('stroke', 'lightgrey')
      .style('stroke-width', 1)
      .style('visibility', visibility)
      .attr('x1', cursorX)
      .attr('y1', 0)
      .attr('x2', cursorX)
      .attr('y2', height)
      .attr('class', 'line x')

    const yCoordLine = svg.append('g')
      .attr('class', 'y coord line')
    yCoordLine.append('line')
      .style("stroke", "lightgrey")
      .style("stroke-width", 1)
      .style('visibility', visibility)
      .attr('x1', 0)
      .attr('y1', y(fixedCursorY))
      .attr('x2', width)
      .attr('y2', y(fixedCursorY))
      .attr('class', 'line y')

    // Add ideal line
    const idealLine = line()
      .x(function(d) { return x(d.x) })
      .y(function(d) { return y(d.y) })

    svg.append('path')
      .datum(idealData)
      .attr('class', 'line ideal')
      .attr('d', idealLine)

    // Add actual line
    const actualLine = line()
      .x(function(d) { return x(d.x) })
      .y(function(d) { return y(d.y) })

    svg.append('path')
      .datum(actualData)
      .attr('class', 'line actual')
      .attr('d', actualLine)

    svg.append('path')
      .datum(actualData)
      .attr('class', 'line actual')
      .attr('d', actualLine)
      .style('stroke-width', 10)
      .style('stroke-opacity', 0)
      .on('mousemove', () => {
          this.props.handleMousePosition(d3.event.offsetX,
                                         d3.event.offsetY, 'visible')
        })
      .on('mouseout', () => {
          this.props.handleMousePosition(d3.event.offsetX,
                                         d3.event.offsetY, 'hidden')
        })

    const cursorPositionData = svg.append('g')
      .attr('class', 'cursor_value')
      .style('visibility', visibility)

    cursorPositionData.append('text')
      .attr('x', cursorX + 20)
      .attr('y', cursorY - 60)
      .attr('dy', '.71em')
      .text('Datum:')

    cursorPositionData.append('text')
      .attr('x', cursorX + 20)
      .attr('y', cursorY - 50)
      .attr('dy', '.71em')
      .text(xValueOnCursorX)

    cursorPositionData.append('text')
      .attr('x', cursorX + 20)
      .attr('y', cursorY - 40)
      .attr('dy', '.71em')
      .text('Tagesergebnis: ' + dailyYValueOnCursorX)

    cursorPositionData.append('text')
      .attr('x', cursorX + 20)
      .attr('y', cursorY - 30)
      .attr('dy', '.71em')
          .text('Gesamtergebnis: ' + yValueOnCursorX)

    // Add scope line
    // const scopeLine = line()
    //   .x(function(d) { return x(d.x) })
    //   .y(function(d) { return y(d.y) })
    //
    // svg.append('path')
    //   .datum(scopeData)
    //   .attr('class', 'line scope')
    //   .attr('d', scopeLine)

    // // Add projection line
    // const projectionLine = line()
    //   .x(function(d) { return x(d.x) })
    //   .y(function(d) { return y(d.y) })
    //
    // svg.append('path')
    //   .datum(projectionData)
    //   .attr('class', 'line projection')
    //   .attr('d', projectionLine)

    return node.toReact()
  }
}
