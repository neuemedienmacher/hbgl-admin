import { connect } from 'react-redux'
import toPairs from 'lodash/toPairs'
import values from 'lodash/values'
import settings from '../../../lib/settings'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import addEntities from '../../../Backend/actions/addEntities'
import OverviewTable from '../components/OverviewTable'

const mapStateToProps = (state, ownProps) => {
  console.log(state)
  const stateKey = `statisticsOverview_${ownProps.model}`
  const states = (state.ajax[stateKey] && state.ajax[stateKey].states) || []
  const data = (state.entities.count && state.entities.count[ownProps.model]) || {}
  const sections = settings.SECTIONS
  const allDataLoaded = (
    values(data).length == states.length &&
      !toPairs(data).filter(pair => values(pair[1]).length != sections.length).length
  )

  return {
    data,
    allDataLoaded,
    states,
    stateKey
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch
})

const mergeProps = (stateProps, dispatchProps, ownProps) => {
  return({
    ...stateProps,
    ...dispatchProps,
    ...ownProps,

    loadData(states) {
      for (let state of states) {
        for (let section of settings.SECTIONS) {
          let params = { 'filter[aasm_state]': state, per_page: 1 }
          // let params = { 'filter[aasm_state]': state, per_page: 1, 'filter[section_filter_id]': 76 }
          dispatchProps.dispatch(
            loadAjaxData(
              ownProps.model + 's', params, 'lastData', (json) => {
                let obj = {}
                obj[ownProps.model] = {}
                obj[ownProps.model][state] = {}
                obj[ownProps.model][state][section] = json.meta.total_entries
                return { count: obj }
              }
            )
          )
        }
      }
    },

    loadStates() {
      dispatchProps.dispatch(
        loadAjaxData(
          `states/${ownProps.model}`, {}, stateProps.stateKey, () => ({})
        )
      )
    },

    calculateTotals(data) {
      let totalsObject = { count: {} }
      totalsObject.count[ownProps.model] = {}
      for (let state of stateProps.states) {
        totalsObject.count[ownProps.model][state] = {}
        totalsObject.count[ownProps.model][state].total =
          toPairs(data[state]).filter(pair => pair[0] != 'total')
            .reduce((total, pair) => (total + pair[1]), 0)
      }

      dispatchProps.dispatch(
        addEntities(totalsObject)
      )
    }
  })
}

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(
  OverviewTable
)
