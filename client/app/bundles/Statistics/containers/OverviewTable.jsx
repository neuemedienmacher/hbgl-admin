import { connect } from 'react-redux'
import toPairs from 'lodash/toPairs'
import values from 'lodash/values'
import settings from '../../../lib/settings'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import addEntities from '../../../Backend/actions/addEntities'
import OverviewTable from '../components/OverviewTable'

const mapStateToProps = (state, ownProps) => {
  const stateKey = `statisticsOverview_${ownProps.model}`
  const states = (state.ajax[stateKey] && state.ajax[stateKey].states) || []
  const data = (state.entities.count && state.entities.count[ownProps.model]) || {}
  const sections =
    values(state.entities.filters).filter(obj => obj.type == 'SectionFilter')
  const allDataLoaded = (
    values(data).length == states.length &&
      !toPairs(data).filter(pair => values(pair[1]).length != sections.length).length
  )

  return {
    data,
    allDataLoaded,
    states,
    stateKey,
    sections,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch
})

const mergeProps = (stateProps, dispatchProps, ownProps) => {
  const { model } = ownProps
  const { dispatch } = dispatchProps

  return({
    ...stateProps,
    ...dispatchProps,
    ...ownProps,

    loadData(states) {
      for (let aasm_state of states) {
        for (let section of stateProps.sections) {
          const params = {
            'filter[aasm_state]': aasm_state,
            'filter[section_filters.id]': section.id,
            per_page: 1
          }
          dispatch(
            loadAjaxData(
              model + 's', params, 'lastData', (json) => {
                let obj = {}
                obj[model] = {}
                obj[model][aasm_state] = {}
                obj[model][aasm_state][section.identifier] = json.meta.total_entries
                return { count: obj }
              }
            )
          )
        }
      }
    },

    loadStates() {
      dispatch(
        loadAjaxData(
          `states/${model}`, {}, stateProps.stateKey, () => ({})
        )
      )
    },

    calculateTotals(data) {
      let totalsObject = { count: {} }
      totalsObject.count[model] = {}
      for (let aasm_state of stateProps.states) {
        totalsObject.count[model][aasm_state] = {}
        totalsObject.count[model][aasm_state].total =
          toPairs(data[aasm_state]).filter(pair => pair[0] != 'total')
            .reduce((total, pair) => (total + pair[1]), 0)
      }

      dispatch(
        addEntities(totalsObject)
      )
    }
  })
}

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(
  OverviewTable
)
