import { connect } from 'react-redux'
import IndexHeaderFilterOption from '../components/IndexHeaderFilterOption'

const mapStateToProps = (state, ownProps) => {
  const { operator } = ownProps
  const value = operator.value
  const displayName = operator.displayName

  return {
    value,
    displayName
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({})

export default connect(mapStateToProps, mapDispatchToProps)(IndexHeaderFilterOption)
