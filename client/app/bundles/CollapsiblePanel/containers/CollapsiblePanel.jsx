import { connect } from 'react-redux'
import CollapsiblePanel from '../components/CollapsiblePanel'

const mapStateToProps = (state, ownProps) => {
  const identifier = 'collapsable-panel-' + ownProps.identifier
  const className =
    'panel-collapse collapse' + (ownProps.visible == true ? ' in' : '')

  return {
    identifier,
    className,
    title: ownProps.title,
    content: ownProps.content
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({ })

export default connect(mapStateToProps, mapDispatchToProps)(CollapsiblePanel)
