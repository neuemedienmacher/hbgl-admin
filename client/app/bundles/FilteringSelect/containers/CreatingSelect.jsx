import { connect } from 'react-redux'
import { pluralize } from '../../../lib/inflection'
import CreatingSelect from '../components/CreatingSelect'

const mapStateToProps = (state, ownProps) => {

  const additionalSubmodelCount = 2
  const additionalSubmodelForms = [1, 2]
  const attribute = ownProps.input.attribute
  const attributeWithoutId = attribute.replace(/_id(s?)/, '')
  const submodelName =
    attribute.match(/s$/) ? pluralize(attributeWithoutId) : attributeWithoutId

  return {
    additionalSubmodelCount,
    additionalSubmodelForms,
    submodelName,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({ dispatch })

const mergeProps = (stateProps, dispatchProps, ownProps) => {
  const { dispatch } = dispatchProps

  return {
    ...stateProps,
    ...ownProps,

    onAdditionalObjectClick(event) {
      asdf
    },
  }
}

export default connect(
  mapStateToProps,
  mapDispatchToProps,
  mergeProps,
)(CreatingSelect)
