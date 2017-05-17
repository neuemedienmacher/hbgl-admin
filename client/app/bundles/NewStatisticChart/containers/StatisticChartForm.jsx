import { connect } from 'react-redux'
import moment from 'moment'
import { browserHistory } from 'react-router'
import valuesIn from 'lodash/valuesIn'
import cloneDeep from 'lodash/cloneDeep'
import { changeFormData } from '../../../Backend/actions/changeFormData'
import addEntities from '../../../Backend/actions/addEntities'
import StatisticChartForm from '../components/StatisticChartForm'

const mapStateToProps = (state, ownProps) => {
  const formId = 'StatisticChartForm'
  const formSettings = state.settings.statistic_charts
  const formData = state.rform[formId] || {}

  const userTeams = valuesIn(state.entities['user-teams']).map((team) => ({
    name: team.name, value: team.id
  }))
  const targetModels = formSettings.target_models.map(transformOptions)
  const currentTargetModel = formData.target_model || targetModels[0].value
  const targetFieldNames =
    formSettings.target_field_names[currentTargetModel].map(transformOptions)
  const currentTargetFieldName = formData.target_field_name ||
    targetFieldNames[0].value
  let targetFieldValues
  if (
    formSettings.target_field_values[currentTargetModel][currentTargetFieldName]
  ) {
    targetFieldValues = formSettings.target_field_values[currentTargetModel]
      [currentTargetFieldName].map(transformOptions)
  } else {
    targetFieldValues = [{}]
  }

  const seedData = {
    fields: {
      user_team_id: userTeams[0].value,
      starts_at: moment().format('YYYY-MM-DD'),
      ends_at: moment().add(1, 'month').format('YYYY-MM-DD'),
      target_count: 10,
      target_model: currentTargetModel,
      target_field_name: currentTargetFieldName,
      target_field_value: targetFieldValues[0].value,
    }
  }

  return {
    formId,
    formData,
    formSettings,
    seedData,
    userTeams,
    targetModels,
    targetFieldNames,
    targetFieldValues,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch,

  handleResponse: (_formId, data) => dispatch(addEntities(data)),

  afterResponse(response) {
    if (response.data && response.data.id) {
      browserHistory.push(`/statistic_charts/${response.data.id}`)
    }
  }
})

const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...stateProps,
  ...dispatchProps,
  ...ownProps,

  afterInputChange(e) {
    const { dispatch } = dispatchProps
    const { formData, formId, formSettings } = stateProps

    const model = e.target.form['statistic_chart[target_model]'].value
    const availableFieldNames = formSettings.target_field_names[model]

    let fieldName
    if (e.target.name == 'statistic_chart[target_model]') {
      fieldName = availableFieldNames[0]
      dispatch(changeFormData(formId, 'target_field_name', fieldName))
    } else {
      fieldName = availableFieldNames[
        e.target.form['statistic_chart[target_field_name]'].value
      ]
    }

    const availableFieldValues =
      formSettings.target_field_values[model][fieldName]

    dispatch(changeFormData(formId, 'target_field_value',
      availableFieldValues[0]
    ))
  },
})


const translations = {
  Offer: 'Offers',
  Organization: 'Organizations',
  SplitBase: 'SplitBases',
  aasm_state: 'Status',
  logic_version: 'Version',
  'id?': 'Existenz',
  true: 'vorhanden'
}

const t = translation_key => translations[translation_key] || translation_key
const transformOptions = element => ({ name: t(element), value: element })

export default connect(
  mapStateToProps,
  mapDispatchToProps,
  mergeProps
)(StatisticChartForm)
