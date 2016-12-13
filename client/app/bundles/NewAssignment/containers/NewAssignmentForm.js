import { connect } from 'react-redux'
import moment from 'moment'
import { browserHistory } from 'react-router'
import valuesIn from 'lodash/valuesIn'
import cloneDeep from 'lodash/cloneDeep'
import { changeFormData } from '../../../Backend/actions/changeFormData'
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
  const recieverUsers = valuesIn(state.entities.users).map((user) => ({
    name: user.name, value: user.id
  }))
  const recieverTeams = valuesIn(state.entities.user_teams).map((team) => ({
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
      reciever_id: recieverUsers[1].value,
      reciever_team_id: recieverTeams[1].value,
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
    recieverUsers,
    recieverTeams
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch,

  handleResponse: (_formId, data) => dispatch(addEntities(data)),

  afterResponse(response) {
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
