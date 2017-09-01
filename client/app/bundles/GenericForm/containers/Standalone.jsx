import { connect } from 'react-redux'
import Standalone from '../components/Standalone'

const mapStateToProps = (state, ownProps) => {
  const [ model, idOrNew, edit ] = getBaseData(ownProps)
  const editId = edit ? idOrNew : null

  return {
    model,
    editId,
    location: ownProps.location
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({ })

function getBaseData(ownProps) {
  if (ownProps.location && ownProps.location.pathname) {
    const pathname = ownProps.location.pathname
    const [_, model, idOrNew, edit] = pathname.split('/')
    return [model, idOrNew, edit]
  } else {
    return [ownProps.model, ownProps.idOrNew, ownProps.edit]
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Standalone)
