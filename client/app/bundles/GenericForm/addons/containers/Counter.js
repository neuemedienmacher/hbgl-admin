import { connect } from 'react-redux'
import Counter from '../components/Counter'

const mapStateToProps = (state, ownProps) => {
  const { input, formId, formObjectClass } = ownProps
  const rformInputData =
    state.rform[formId] && state.rform[formId][input.attribute]
  const count = rformInputData && rformInputData.length || 0

  const maximum =
    formObjectClass.inputMaxLengths &&
    formObjectClass.inputMaxLengths[input.attribute] || 0

  let className = 'GenericFormAddon-Counter'
  if (maximum) {
    className += ' GenericFormAddon-Counter--'
    if (count < maximum) className += 'under'
    if (count == maximum) className += 'equal'
    if (count > maximum) className += 'over'
  }

  return {
    count,
    maximum,
    className
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({})

const mergeProps = (stateProps, dispatchProps, ownProps) => ({
  ...stateProps, ...dispatchProps, ...ownProps
})

export default connect(mapStateToProps, mapDispatchToProps)(Counter)
