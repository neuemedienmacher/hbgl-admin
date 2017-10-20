import { connect } from 'react-redux'
import isArray from 'lodash/isArray'
import { updateAction, navigateThroughSubmodels } from 'rform'
import { pluralize } from '../../../lib/inflection'
import { loadForFilteringSelect } from '../actions/loadForFilteringSelect'
import { resetFilteringSelectData } from '../actions/resetFilteringSelectData'
import FilteringSelect from '../components/FilteringSelect'

const mapStateToProps = (state, ownProps) => {
  const { attribute, submodelPath, params } = ownProps
  // remove last "-id(s)" from attribute
  let resource = ownProps.resource || attribute.replace(/(-id|-ids)$/, '')
  // pluralize
  resource = pluralize(resource)
  const filterString =
    params && Object.keys(params).length && JSON.stringify(params) || ''
  const resourceKey = resource + filterString

  const formState = state.rform[ownProps.formId]
  const statePath = navigateThroughSubmodels(formState, submodelPath)

  let value = statePath && statePath[attribute]

  // Server gives array elements as list of ids. Transform it to simpleValue
  if (isArray(value)) value = value.join(',')

  const options = state.filteringSelect.options[resourceKey] || []
  const isLoading = state.filteringSelect.isLoading[resourceKey] || false
  const alreadyLoadedInputs =
    state.filteringSelect.alreadyLoadedInputs[resourceKey] || []

  const errors =
    (statePath && statePath._errors && statePath._errors[attribute]) || []

  let changed =
    (statePath._changes && statePath._changes.includes(attribute)) || false
  const wrapperClassNameWithChanged =
    (ownProps.wrapperClassName || '') + (changed ? ' changed' : '')
  const classNameWithChanged =
    (ownProps.className || '') + (changed ? ' changed' : '')

  return {
    value,
    errors,
    options,
    isLoading,
    resource,
    resourceKey,
    alreadyLoadedInputs,
    showSelect: ownProps.showSelect || true,
    classNameWithChanged,
    wrapperClassNameWithChanged,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({ dispatch })

const mergeProps = (stateProps, dispatchProps, ownProps) => {
  const { dispatch } = dispatchProps
  const { alreadyLoadedInputs, resource, resourceKey } = stateProps
  const { params, inverseRelationship, model } = ownProps

  return {
    ...ownProps,
    ...stateProps,

    onChange(selected) {
      let newValue
      if (selected) newValue =
        isArray(selected) ? selected.map(e => e.value) : selected.value

      dispatch(
        updateAction(
          ownProps.formId, ownProps.attribute, ownProps.submodelPath, newValue
        )
      )

      if (ownProps.onChange) ownProps.onChange(selected)
    },

    onMount() {
      dispatch(loadForFilteringSelect(
        '', resource, resourceKey, model, inverseRelationship, params
      ))
    },

    onUnmount() {
      if (inverseRelationship != 'belongsTo') return
      // only filtered FilteringSelect need to be cleaned up

      dispatch(resetFilteringSelectData(resourceKey))
    },

    onFirstValue(value) {
      let filter_ids = value.split(',').filter(
        value => alreadyLoadedInputs.includes(value) == false
      ).join(',')
      dispatch(loadForFilteringSelect(
        '', resource, resourceKey, model, inverseRelationship, params, filter_ids
      ))
    },

    onInputChange(input) {
      if (alreadyLoadedInputs.includes(input)) return

      if (lastInputChangeTimer) clearTimeout(lastInputChangeTimer)
      lastInputChangeTimer = setTimeout(function() {
        lastInputChangeTimer = null

        dispatch(loadForFilteringSelect(
          input, resource, resourceKey, model, inverseRelationship, params
        ))
      }, 400)
    },
  }
}

let lastInputChangeTimer = null

export default connect(
  mapStateToProps,
  mapDispatchToProps,
  mergeProps,
)(FilteringSelect)
