import { connect } from 'react-redux'
import moment from 'moment'
import { browserHistory } from 'react-router'
import valuesIn from 'lodash/valuesIn'
import cloneDeep from 'lodash/cloneDeep'
import addEntities from '../../../Backend/actions/addEntities'
import NewAssignmentForm from '../components/NewAssignmentForm'

const mapStateToProps = (state, ownProps) => {
  const formId = 'AssignmentForm'
  const formSettings = state.settings.assignments
  const formData = state.rform[formId] || {}

  // TODO: match users to teams and vice versa
  const creatorUsers = valuesIn(state.entities.users).map((user) => ({
    name: user.name, value: user.id
  }))
  const creatorTeams = valuesIn(state.entities.user_teams).map((team) => ({
    name: team.name, value: team.id
  }))
  const receiverUsers = valuesIn(state.entities.users).map((user) => ({
    name: user.name, value: user.id
  }))
  const receiverTeams = valuesIn(state.entities.user_teams).map((team) => ({
    name: team.name, value: team.id
  }))

  const assignableModels = formSettings.assignable_models.map((model) => ({
    name: model, value: model
  }))
  const currentAssignableModel = formData.assignable_type ||
    assignableModels[0].value

  // TODO: later: all available fields of model plus empty string as option
  // const assignableFields = formSettings.assignable_field_names[currentAssignableModel].map((field) => ({
  //   name: field, value: ''
  // }))
  // const currentTargetFieldName = formData.assignable_field_type ||
  //   assignableFields[0].value

  const seedData = {
    fields: {
      assignable_type: currentAssignableModel,
      // assignable_field_type: '',
      creator_id: creatorUsers[0].value,
      creator_team_id: creatorTeams[0].value,
      receiver_id: receiverUsers[1].value,
      receiver_team_id: receiverTeams[1].value,
      message: '',
    }
  }

  return {
    formId,
    seedData,
    assignableModels,
    // assignableFields,
    creatorUsers,
    creatorTeams,
    receiverUsers,
    receiverTeams
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch,

  afterResponse(_formId, data, _errors, _meta, response) {
    dispatch(addEntities(data))

    if (response.data && response.data.id) {
      browserHistory.push(`/assignments/${response.data.id}`)
    }
  }
})

const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...stateProps,
  ...dispatchProps,
  ...ownProps
})

export default connect(
  mapStateToProps,
  mapDispatchToProps,
  mergeProps
)(NewAssignmentForm)
