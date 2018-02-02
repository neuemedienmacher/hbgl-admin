import { connect } from 'react-redux'
import Dashboard from '../components/Dashboard'

const mapStateToProps = (state, ownProps) => {
  // read current_user from users with current_user.id (current_user not updated)
  const user = state.entities.users[state.entities['current-user-id']]

  return {
    user
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({})

export default connect(mapStateToProps, mapDispatchToProps)(Dashboard)
