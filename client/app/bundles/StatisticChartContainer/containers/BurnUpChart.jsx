import { connect } from 'react-redux'
import merge from 'lodash/merge'
import cloneDeep from 'lodash/cloneDeep'
import { timeParse } from 'd3-time-format'
import { scaleTime, scaleLinear } from 'd3-scale'
import { axisBottom, axisLeft } from 'd3-axis'
import moment from 'moment'
import { setUi } from '../../../Backend/actions/setUi'
import BurnUpChart from '../components/BurnUpChart'

const mapStateToProps = function(state, ownProps) {
  const data = cloneDeep(ownProps.data)

  const actualData = data.actual
  const idealData = data.ideal
  const projectionData = data.projection
  const scopeData = data.scope

  // Scale Factor for scope of yAxis
  const graphHeightFactor = 1.1

  // Set the dimensions of the graph
  const margin = { top: 20, right: 20, bottom: 30, left: 50 }
  const width = 700 - margin.left - margin.right
  const height = 400 - margin.top - margin.bottom

  const cursorY =
    state.ui.chartCursorData && state.ui.chartCursorData.cursorY ?
      state.ui.chartCursorData.cursorY-margin.top : null
  const cursorX =
    state.ui.chartCursorData && state.ui.chartCursorData.cursorX &&
      (state.ui.chartCursorData.chartId == ownProps.chartId) ?
        state.ui.chartCursorData.cursorX-margin.left : null

  //transforms cursorX to actualData arrayIndex
  const cursorArrayIndex = Math.floor(cursorX/((width-2)/365))

  //used to fix Y-line to actualData line, even when cursor is above it
  const fixedCursorY =
    actualData[cursorArrayIndex] ? actualData[cursorArrayIndex].y : null

  //statistics chart data
  const yValueOnCursorX =
    actualData[cursorArrayIndex] ?
      actualData[cursorArrayIndex].y : actualData[actualData.length -1].y
  const lastDaysValue =
    (cursorArrayIndex>0) && actualData[cursorArrayIndex-1] ?
      actualData[cursorArrayIndex-1].y : 0
  const dailyYValueOnCursorX =
    actualData[cursorArrayIndex] ?
      actualData[cursorArrayIndex].y - lastDaysValue : 0
  const rawXValueOnCursorX =
    actualData[cursorArrayIndex] ?
      actualData[cursorArrayIndex].x : actualData[actualData.length -1].x
  const xValueOnCursorX = moment(rawXValueOnCursorX).format('DD.MM.YYYY')
  const hasActiveCursor =
    state.ui.chartCursorData && state.ui.chartCursorData.hasActiveCursor &&
     (state.ui.chartCursorData.chartId == ownProps.chartId)

  // Parse the date, normalize Y
  const parseDate = timeParse('%Y-%m-%d')
  for (let dataSegment of Object.keys(data)) {
    data[dataSegment].forEach(function (d) {
      d.x = parseDate(d.x)
      d.y = +d.y
    })
  }

  // Combine data for min/max evaluation
  const allData = merge([], actualData, projectionData, scopeData, idealData)

  // Set the ranges
  const x = scaleTime()
    .range([0, width])

  const y = scaleLinear()
    .range([height, 0])

  // Define the axes
  const xAxis = axisBottom()
    .scale(x)

  const yAxis = axisLeft()
    .scale(y)

  return {
    cursorX, cursorY, hasActiveCursor, fixedCursorY,
    x, y, xAxis, yAxis, width, height, margin, allData, parseDate,
    xValueOnCursorX, yValueOnCursorX,
    dailyYValueOnCursorX, graphHeightFactor, scopeData, actualData,
    idealData, projectionData, hasActiveCursor,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  handleMousePosition(cursorX, cursorY, hasActiveCursor) {
    let uiObjectToSave = {
      cursorX,
      cursorY,
      hasActiveCursor,
      chartId: ownProps.chartId
    }
    dispatch(setUi('chartCursorData', uiObjectToSave))
  }
})

export default connect(mapStateToProps, mapDispatchToProps)(BurnUpChart)
