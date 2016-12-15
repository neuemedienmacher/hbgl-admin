import { connect } from 'react-redux'
import isArray from 'lodash/isArray'
import { updateAction } from 'rform'
import { pluralize } from '../../../lib/inflection'
import loadForFilteringSelect from '../actions/loadForFilteringSelect'
import FilteringSelect from '../components/FilteringSelect'

const mapStateToProps = (state, ownProps) => {
  // remove last "_id" from attribute
  let associatedModel = ownProps.associatedModel ||
    ownProps.attribute.replace(/_id([^_id]*)$/, '$1')
  // pluralize
  associatedModel = pluralize(associatedModel)

  let value = state.rform[ownProps.formId] &&
    state.rform[ownProps.formId][ownProps.attribute]

  // Server gives array elements as list of ids. Transform it to simpleValue
  if (isArray(value)) value = value.join(',')

  const options = state.filteringSelect.options[associatedModel] || []
  const isLoading = state.filteringSelect.isLoading[associatedModel] || false
  const alreadyLoadedInputs =
    state.filteringSelect.alreadyLoadedInputs[associatedModel] || []

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

    onChange(selected) {
      let newValue
      if (selected) newValue =
        isArray(selected) ? selected.map(e => e.value) : selected.value

      dispatch(
        updateAction(ownProps.formId, ownProps.attribute, null, newValue)
      )

      if (ownProps.onChange) ownProps.onChange(selected)
    },

    onMount() {
      dispatch(loadForFilteringSelect('', stateProps.associatedModel))
    },

    onFirstValue(value) {
      for (let id of value.split(',')) {
        dispatch(loadForFilteringSelect(id, stateProps.associatedModel))
      }
    },

    onInputChange(input) {
      if (stateProps.alreadyLoadedInputs.includes(input)) return
      dispatch(loadForFilteringSelect(input, stateProps.associatedModel))
    },
  }
}

export default connect(
  mapStateToProps,
  mapDispatchToProps,
  mergeProps,
)(FilteringSelect)
