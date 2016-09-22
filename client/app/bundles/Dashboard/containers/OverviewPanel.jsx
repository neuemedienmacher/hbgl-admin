import { connect } from 'react-redux'
import valuesIn from 'lodash/valuesIn'
import OverviewPanel from '../components/OverviewPanel'

const mapStateToProps = (state, ownProps) => {
  const user = state.current_user

  let selectableTeams = valuesIn(state.user_teams).filter(
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
    seedData,
	}
}

const mapDispatchToProps = (dispatch, ownProps) => ({})

export default connect(mapStateToProps, mapDispatchToProps)(OverviewPanel)
