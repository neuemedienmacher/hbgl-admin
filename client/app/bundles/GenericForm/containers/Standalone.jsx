import { connect } from 'react-redux'
import parseLocation from '../lib/parseLocation'
import Standalone from '../components/Standalone'

const mapStateToProps = (state, ownProps) => {
  const [ model, idOrNew, edit ] = parseLocation(ownProps)
  const editId = edit ? idOrNew : null

  return {
    model,
    editId,
    location: ownProps.location
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({ })

export default connect(mapStateToProps, mapDispatchToProps)(
  Standalone
)
