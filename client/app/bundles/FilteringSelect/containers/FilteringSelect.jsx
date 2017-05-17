import { connect } from 'react-redux'
import isArray from 'lodash/isArray'
import { updateAction, navigateThroughSubmodels } from 'rform'
import { pluralize } from '../../../lib/inflection'
import { loadForFilteringSelect } from '../actions/loadForFilteringSelect'
import FilteringSelect from '../components/FilteringSelect'

const mapStateToProps = (state, ownProps) => {
  const { attribute, submodel, submodelIndex } = ownProps
  // remove last "-id(s)" from attribute
  let resource = ownProps.resource || attribute.replace(/(-id|-ids)$/, '')
  // pluralize
  resource = pluralize(resource)

  const formState = state.rform[ownProps.formId]
  const statePath =
    navigateThroughSubmodels(formState, submodel, submodelIndex)

  let value = statePath && statePath[attribute]

  // Server gives array elements as list of ids. Transform it to simpleValue
  if (isArray(value)) value = value.join(',')

  const options = state.filteringSelect.options[resource] || []
  const isLoading = state.filteringSelect.isLoading[resource] || false
  const alreadyLoadedInputs =
    state.filteringSelect.alreadyLoadedInputs[resource] || []

  const errors = [] // TODO: Implement errors!

  return {
    value,
    errors,
    options,
    isLoading,
    resource,
    alreadyLoadedInputs,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({ dispatch })

const mergeProps = (stateProps, dispatchProps, ownProps) => {
  const { dispatch } = dispatchProps

  return {
    ...stateProps,
    ...ownProps,

    onChange(selected) {
      let newValue
      if (selected) newValue =
        isArray(selected) ? selected.map(e => e.value) : selected.value

      dispatch(
        updateAction(
          ownProps.formId, ownProps.attribute, ownProps.submodel,
          ownProps.submodelIndex, newValue
        )
      )

      if (ownProps.onChange) ownProps.onChange(selected)
    },

    onMount() {
      dispatch(loadForFilteringSelect('', stateProps.resource))
    },

    onFirstValue(value) {
      for (let id of value.split(',')) {
        dispatch(loadForFilteringSelect(id, stateProps.resource))
      }
    },

    onInputChange(input) {
      if (stateProps.alreadyLoadedInputs.includes(input)) return
      dispatch(loadForFilteringSelect(input, stateProps.resource))
    },
  }
}

export default connect(
  mapStateToProps,
  mapDispatchToProps,
  mergeProps,
)(FilteringSelect)
