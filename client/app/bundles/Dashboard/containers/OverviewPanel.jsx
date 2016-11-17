import { connect } from 'react-redux'
import valuesIn from 'lodash/valuesIn'
import addEntities from '../../../Backend/actions/addEntities'
import OverviewPanel from '../components/OverviewPanel'

const mapStateToProps = (state, ownProps) => {
  // read current_user from users with current_user.id (current_user not updated)
  const user = state.entities.users[state.entities.current_user.id]

  let selectableTeams = valuesIn(state.entities.user_teams).filter(
    team => user.user_team_ids.includes(team.id)
  ).map(team => ({value: String(team.id), name: team.name}))
  if (!user.current_team_id) selectableTeams.unshift({value: '', name: '-'})

  const seedData = {
    fields: {
      id: user.id,
      current_team_id: user.current_team_id || ''
    }
  }

  return {
    user,
    selectableTeams,
    seedData
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  handleResponse: (_formId, data) => dispatch(addEntities(data))
})

export default connect(mapStateToProps, mapDispatchToProps)(OverviewPanel)
