import { connect } from 'react-redux'
import moment from 'moment'
import valuesIn from 'lodash/valuesIn'
import { getTimePointsBetween } from '../../../lib/timeUtils'
import { getAllocationForWeekAndUser } from '../../../lib/timeAllocations'
import GoalsStatisticTable from '../components/GoalsStatisticTable'

const mapStateToProps = (state, ownProps) => {
  const actualData = ownProps.actualData
  const tableArrays = sortActualDataPerMonth(actualData)
  const monthlySortedActualData = tableArrays[0]
  const monthlySum = tableArrays[1]

  const titleArray = ['Tag', 'Jan', 'Feb', 'Mär', 'Apr', 'Mai', 'Jun', 'Jul',
                      'Aug', 'Sep', 'Okt', 'Nov', 'Dez']

  // const monthlyGoal = Math.floor(ownProps.lastGoalAmount/12)

  return {
    lastGoalAmount: ownProps.lastGoalAmount,
    monthlySortedActualData,
    monthlySum,
    titleArray,
    // monthlyGoal
  }
}

function sortActualDataPerMonth(actualData) {
  let monthSumArray = Array(12).fill('-')
  let yearData = []

  for (var day = 0; day < 31; day++) {
    yearData.push(Array.from(monthSumArray))
  }

  let lastYValue = 0
  let monthOfArray = 0
  let monthSum = 0
  for (var i = 0; i < actualData.length; i++ ) {
    let dataDay = actualData[i]
    yearData[moment(dataDay.x).date() - 1][moment(dataDay.x).month()] =
      dataDay.y - lastYValue

    if (monthOfArray != moment(dataDay.x).month()) {
      monthSumArray[monthOfArray] =
        monthOfArray > 0 ? lastYValue - monthSum : lastYValue
      monthSum = monthSum + monthSumArray[monthOfArray]
      monthOfArray = moment(dataDay.x).month()
    }

    if (actualData.length == i + 1) {
      monthSumArray[moment(dataDay.x).month()] =
        monthOfArray > 0 ? dataDay.y - monthSum : dataDay.y
    }

    lastYValue = dataDay.y
  }

  return [yearData, monthSumArray]
}

const mapDispatchToProps = (dispatch, ownProps) => ({})

export default connect(mapStateToProps, mapDispatchToProps)(GoalsStatisticTable)
