import { connect } from 'react-redux'
import isArray from 'lodash/isArray'
import { updateAction } from 'rform'
import loadForMultiSelect from '../actions/loadForMultiSelect'
import MultiSelect from '../components/MultiSelect'

const mapStateToProps = (state, ownProps) => {
  const associatedModel = 'users' // TODO: make variable

  let value = state.rform[ownProps.formId] &&
    state.rform[ownProps.formId][ownProps.attribute]

  // Server gives array elements as list of ids. Transform it to simpleValue
  if (isArray(value)) value = value.join(',')

  const options = state.multiSelect.options[associatedModel] || []
  const isLoading = state.multiSelect.isLoading[associatedModel] || false
  const alreadyLoadedInputs =
    state.multiSelect.alreadyLoadedInputs[associatedModel] || []

  return {
    value,
    options,
    isLoading,
    associatedModel,
    alreadyLoadedInputs,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({ dispatch })

const mergeProps = (stateProps, dispatchProps, ownProps) => {
  const { dispatch } = dispatchProps

  return {
    ...stateProps,
    ...ownProps,

    onChange(selectValue) {
      dispatch(
        updateAction(
          ownProps.formId, ownProps.attribute, null,
          selectValue.map(e => e.value)
        )
      )
    },

    onMount() {
      dispatch(loadForMultiSelect('', stateProps.associatedModel))
    },

    onFirstValue(value) {
      for (let id of value.split(',')) {
        dispatch(loadForMultiSelect(id, stateProps.associatedModel))
      }
    },

    onInputChange(input) {
      console.log('input changed', input)
      if (stateProps.alreadyLoadedInputs.includes(input)) return
      console.log('new input!')
      dispatch(loadForMultiSelect(input, stateProps.associatedModel))
    },
  }
}

export default connect(
  mapStateToProps,
  mapDispatchToProps,
  mergeProps,
)(MultiSelect)
