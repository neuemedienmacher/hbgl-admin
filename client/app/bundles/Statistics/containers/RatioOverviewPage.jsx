import { connect } from 'react-redux'
import values from 'lodash/values'
import round from 'lodash/round'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import RatioOverviewPage from '../components/RatioOverviewPage'

const mapStateToProps = (state, ownProps) => {
  const data = state.entities.count
  const sections =
    values(state.entities.filters).filter(obj => obj.type == 'SectionFilter')

  const allDataLoaded = (
    data && data.offer && data.offer.ratio && data.offer.ratio.family &&
      data.offer.ratio.refugees && data.organization &&
      data.organization.ratio.family && data.organization.ratio.refugees
  )

  const calculateRatio = (section) =>
    round(data.offer.ratio[section] / data.organization.ratio[section], 2)

  let familyRatio = 'Lade…'
  let refugeesRatio = 'Lade…'
  let totalRatio = 'Lade…'

  if (allDataLoaded) {
    familyRatio = calculateRatio('family')
    refugeesRatio = calculateRatio('refugees')
    totalRatio = calculateRatio('total')
  }

  return {
    familyRatio,
    refugeesRatio,
    totalRatio,
    sections,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch
})

const mergeProps = (stateProps, dispatchProps, ownProps) => {
  const { dispatch } = dispatchProps

  const entryCountGrabberTransformer = function(model, section) {
    return function(json) {
      let obj = {}
      obj[model] = {}
      obj[model].ratio = {}
      obj[model].ratio[section.identifier || section] =
        json.meta.total_entries
      return { count: obj }
    }
  }

  const entryCountGrabberParams = function(model, section) {
    let params = { per_page: 1 }
    params['filters[organizations.aasm_state]'] = 'all_done'

    if (typeof section == 'object') {
      params['filters[section_filters.id]'] = section.id
    }

    return params
  }

  const dispatchDataLoad = function(section) {
    for (let model of ['offer', 'organization'])
    dispatch(
      loadAjaxData(
        `${model}s`, entryCountGrabberParams(model, section),
        'lastData', entryCountGrabberTransformer(model, section)
      )
    )
  }

  return({
    ...stateProps,
    ...dispatchProps,
    ...ownProps,

    loadData(states) {
      for (let section of stateProps.sections) {
        dispatchDataLoad(section)
      }
      dispatchDataLoad('total')
    },
  })
}

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(
  RatioOverviewPage
)
