import { connect } from 'react-redux'
import UserSelection from '../components/UserSelection'
import { selectUser, unselectUser } from '../actions/updateUsers'

const mapStateToProps = (state, ownProps) => ({
})

const mapDispatchToProps = (dispatch, ownProps) => ({
  toggleUser(id) {
    if (ownProps.selectedUsers.includes(id)) {
      return () => dispatch(unselectUser(id))
    } else {
      return () => dispatch(selectUser(id))
    }
  },
})

export default connect(mapStateToProps, mapDispatchToProps)(UserSelection)
