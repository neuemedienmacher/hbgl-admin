import { connect } from 'react-redux'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import AssignableContainer from '../components/AssignableContainer'

const mapStateToProps = (state, ownProps) => {
  const id = ownProps.assignment_id
  const assignableDataLoad = ownProps.assignableDataLoad
  const model = 'assignments'
  const assignment = id ? state.entities[model] && state.entities[model][id] : false
  const loaded = !!assignment
  const heading = id ? `Aktuelle Zuweisung: ${model}#${id}` : 'Keine Zuweisung gefunden!'
  const involved_entities = loaded ? {
    creator: assignment.creator_id ? state.entities.users[assignment.creator_id].name : '',
    creator_team: assignment.creator_team_id ? state.entities.user_teams[assignment.creator_team_id].name : '',
    receiver: assignment.receiver_id ? state.entities.users[assignment.receiver_id].name : '',
    receiver_team: assignment.receiver_team_id ? state.entities.user_teams[assignment.receiver_team_id].name : ''
  } : {creator: '', creator_team: '', receiver: '' , receiver_team: ''}

  return {
    id,
    model,
    loaded,
    assignment,
    heading,
    involved_entities,
    assignableDataLoad,
    may_edit: ownProps.may_edit
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch
})

const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...stateProps,
  ...dispatchProps,
  ...ownProps,

  loadData(model = stateProps.model, id = stateProps.id) {
    if (id) {
      dispatchProps.dispatch(
        loadAjaxData(`${model}/${id}`, '', model)
      )
    }
  }
})

export default connect(
  mapStateToProps,
  mapDispatchToProps,
  mergeProps
)(AssignableContainer)
