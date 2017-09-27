import { connect } from 'react-redux'
import toPairs from 'lodash/toPairs'
import values from 'lodash/values'
import keys from 'lodash/keys'
import settings from '../../../lib/settings'
import { pluralize } from '../../../lib/inflection'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import addEntities from '../../../Backend/actions/addEntities'
import TopicTable from '../components/TopicTable'

const ALL = 'all'

const mapStateToProps = (state, ownProps) => {
  const columnName = ownProps.columns
  const teamKey = `statisticsOverview_${ownProps.model}_${columnName}`
  const teams = ['Screening', 'Not-Screening']
  const selectedCity = state.rform[teamKey] && state.rform[teamKey].city
  const data =
    (state.entities.count && state.entities.count[ownProps.model] &&
      state.entities.count[ownProps.model][columnName] &&
      state.entities.count[ownProps.model][columnName][selectedCity || ALL]
    ) || {}
  const columnElements = (state.ajax[columnName] &&
                          state.ajax[columnName].data.map(datum =>
                          datum.attributes.name)
                         ) || []
  const loadedCities =
    (state.entities.count && state.entities.count[ownProps.model] &&
      keys(state.entities.count[ownProps.model][columnName])
    ) || []

  return {
    data,
    teams,
    teamKey,
    columnElements,
    selectedCity,
    loadedCities,
    columnName
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch
})

const mergeProps = (stateProps, dispatchProps, ownProps) => {
  const { model } = ownProps
  const { dispatch } = dispatchProps

  const entryCountGrabberTransformer = function(
    columnName, team, element, cityId
  ) {
    return function(json) {
      const elementKey = element
      const teamKey = team || 'total'
      const cityKey = cityId || ALL
      const modelKey = columnName

      let obj = {}
      obj[model] = {}
      obj[model][modelKey] = {}
      obj[model][modelKey][cityKey] = {}
      obj[model][modelKey][cityKey][teamKey] = {}
      obj[model][modelKey][cityKey][teamKey][elementKey] =
        json.meta.total_entries

      return { count: obj }
    }
  }

  const entryCountGrabberParams = function(columnName, team, element, cityId) {
    let params = { per_page: 1 }
    // set city.id filter
    if (cityId && cityId != 'all')
      params[`filters[division-cities.id]`] = cityId
    // set receiver-team.name filter
    if (team == 'Screening') {
      params[`filters[current-assignment.receiver-team.name]`] = 'Screening'
    }
    else if (team == 'Not-Screening') {
      params[`filters[current-assignment.receiver-team.name]`] = 'Screening'
      params[`operators[current-assignment.receiver-team.name]`] = '!='
    }
    // set topic.name or section.name filter
    if (element != 'total' && columnName == 'topics') {
      params[`filters[topics.name]`] = element
    }
    else if (element != 'total' && columnName == 'sections') {
      params[`filters[sections.name]`] = element
    }
    return params
  }

  const dispatchDataLoad = function(columnName, team, element, cityId) {
    dispatch(
      loadAjaxData(
        pluralize(model),
        entryCountGrabberParams(columnName, team, element, cityId),
        'lastData',
        entryCountGrabberTransformer(columnName, team, element, cityId)
      )
    )
  }

  const loadData = function(columnName, teams, columnElements, cityId) {
    for (let team of teams.concat(null)) { // null for the "total" row
      for (let element of columnElements) {
        dispatchDataLoad(columnName, team, element, cityId)
      }
      dispatchDataLoad(columnName, team, 'total', cityId)
    }
  }

  return({
    ...stateProps,
    ...dispatchProps,
    ...ownProps,

    loadData,

    loadColumns(columns) {
      dispatch(
        loadAjaxData(columns, {}, columns)
      )
    },

    onCityChange(selected) {
      let city = (selected && selected.value) || ALL
      if (!stateProps.loadedCities.includes(city)) {
        loadData(
          stateProps.columnName, stateProps.teams, stateProps.columnElements,
          city
        )
      }
    }
  })
}

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(
  TopicTable
)
