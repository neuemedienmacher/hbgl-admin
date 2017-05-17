import { connect } from 'react-redux'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import AssignableContainer from '../components/AssignableContainer'

const mapStateToProps = (state, ownProps) => {
  const id = ownProps.assignmentId
  const assignableDataLoad = ownProps.assignableDataLoad
  const model = 'assignments'
  const assignment = id ? state.entities[model] && state.entities[model][id] : false
  const loaded = !!assignment
  const heading = id ? `Aktuelle Zuweisung: ${model}#${id}` : 'Keine Zuweisung gefunden!'
  const involvedEntities = loaded ? {
    creator: assignment['creator-id'] ? state.entities.users[assignment['creator-id']].name : '',
    creatorTeam: assignment['creator-team-id'] ? state.entities['user-teams'][assignment['creator-team-id']].name : '',
    receiver: assignment['receiver-id'] ? state.entities.users[assignment['receiver-id']].name : '',
    receiverTeam: assignment['receiver-team-id'] ? state.entities['user-teams'][assignment['receiver-team-id']].name : ''
  } : {creator: '', creatorTeam: '', receiver: '' , receiverTeam: ''}

  return {
    id,
    model,
    loaded,
    assignment,
    heading,
    involvedEntities,
    assignableDataLoad,
    mayEdit: ownProps.mayEdit
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
