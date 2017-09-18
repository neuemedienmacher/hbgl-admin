import { connect } from 'react-redux'
import IndexHeaderFilterOption from '../components/IndexHeaderFilterOption'

const mapStateToProps = (state, ownProps) => {
  const { operator } = ownProps
  const value = operator
  const displayName = operator

  return {
    value,
    displayName
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({})

export default connect(mapStateToProps, mapDispatchToProps)(IndexHeaderFilterOption)
