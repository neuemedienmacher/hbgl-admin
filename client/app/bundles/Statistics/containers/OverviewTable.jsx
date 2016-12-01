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

  const entryCountGrabberTransformer = function(aasm_state, section) {
    return function(json) {
      let obj = {}
      obj[model] = {}
      obj[model][aasm_state] = {}
      obj[model][aasm_state][section.identifier || section] =
        json.meta.total_entries
      return { count: obj }
    }
  }

  const entryCountGrabberParams = function(aasm_state, section) {
    let params = {
      'filter[aasm_state]': aasm_state,
      per_page: 1
    }
    if (typeof section == 'object') {
      params['filter[section_filters.id]'] = section.id
    }
    return params
  }

  const dispatchDataLoad = function(aasm_state, section) {
    dispatch(
      loadAjaxData(
        model + 's', entryCountGrabberParams(aasm_state, section), 'lastData',
        entryCountGrabberTransformer(aasm_state, section)
      )
    )
  }

  return({
    ...stateProps,
    ...dispatchProps,
    ...ownProps,

    loadData(states) {
      for (let aasm_state of states) {
        for (let section of stateProps.sections) {
          dispatchDataLoad(aasm_state, section)
        }
        dispatchDataLoad(aasm_state, 'total')
      }
    },

    loadStates() {
      dispatch(
        loadAjaxData(
          `states/${model}`, {}, stateProps.stateKey, () => ({})
        )
      )
    },
  })
}

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(
  OverviewTable
)
