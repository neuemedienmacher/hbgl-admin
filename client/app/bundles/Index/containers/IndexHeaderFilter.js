import { connect } from 'react-redux'
import omit from 'lodash/omit'
import clone from 'lodash/clone'
import merge from 'lodash/merge'
import filter from 'lodash/filter'
import { encode } from 'querystring'
import { browserHistory } from 'react-router'
import settings from '../../../lib/settings'
import setUiAction from '../../../Backend/actions/setUi'
import { analyzeFields } from '../../../lib/settingUtils'
import IndexHeaderFilter from '../components/IndexHeaderFilter'

const mapStateToProps = (state, ownProps) => {
  const model = ownProps.model
  const filterName =
    ownProps.filter[0].substring(8, ownProps.filter[0].length - 1)
  const filterType = setFilterType(filterName)
  const filterValue = ownProps.filter[1] == 'nil' ? '' : ownProps.filter[1]
  const nilChecked = ownProps.filter[1] == 'nil'
  // only show filters that are not locked (currently InlineIndex only)
  const fields =
    analyzeFields(settings.index[model].fields, model).filter(value =>
      !ownProps.lockedParams ||
        !ownProps.lockedParams.hasOwnProperty(`filters[${value.field}]`)
    )
  const operatorName = ownProps.params[`operators[${filterName}]`] || '='
  const operators = settings.OPERATORS.map(operator => {
    return {
      value: operator,
      displayName: textForOperator(operator)
    }
  })

  return {
    filterName,
    filterValue,
    nilChecked,
    filterType,
    fields,
    operators,
    operatorName
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  onTrashClick(event) {
    let filterId = ownProps.filter[0].split('[')
    const params = omit(clone(ownProps.params),
                  [ownProps.filter[0], 'operators[' + filterId[1]])
    if(ownProps.uiKey){
      dispatch(setUiAction(ownProps.uiKey, params))
    }
    else{
      browserHistory.replace(`/${ownProps.model}?${encode(params)}`)
    }
  },

  onFilterNameChange(event) {
    let params = omit(clone(ownProps.params), ownProps.filter[0])
    let newParam = {}
    newParam[`filters[${event.target.value}]`] = ''
    params = merge(params, newParam)
    if(ownProps.uiKey){
      dispatch(setUiAction(ownProps.uiKey, params))
    }
    else{
      browserHistory.replace(`/${ownProps.model}?${encode(params)}`)
    }
  },

  onFilterOperatorChange(event) {
    let params = clone(ownProps.params)
    let newParam = {}
    let operator = event.target.value
    let filterName =
        ownProps.filter[0].substring(8, ownProps.filter[0].length - 1)
    newParam[`operators[${filterName}]`] = operator
    params = merge(params, newParam)

    if(ownProps.uiKey){
      dispatch(setUiAction(ownProps.uiKey, params))
    }
    else{
      browserHistory.replace(`/${ownProps.model}?${encode(params)}`)
    }
  },

  onCheckboxChange(event) {
    let params = clone(ownProps.params)
    if (event.target.checked) {
      params[ownProps.filter[0]] = 'nil'
    } else {
      params[ownProps.filter[0]] = ''
    }
    if (ownProps.uiKey){
      dispatch(setUiAction(ownProps.uiKey, params))
    }
    else{
      browserHistory.replace(`/${ownProps.model}?${encode(params)}`)
    }
  },

  onFilterValueChange(event) {
    let params = clone(ownProps.params)
    params[ownProps.filter[0]] = event.target.value
    if(ownProps.uiKey){
      dispatch(setUiAction(ownProps.uiKey, params))
    }
    else{
      browserHistory.replace(`/${ownProps.model}?${encode(params)}`)
    }
  }
})

function setFilterType (filterName) {
  let splitArray = filterName.split('_')
  switch(splitArray[splitArray.length - 1]) {
    case 'at':
      return 'date'
    case 'id':
    case 'count':
      return 'number'
    default:
      return 'text'
  }
}

function textForOperator(operator) {
  switch(operator) {
    case '<':
      return 'kleiner als'
    case '>':
      return 'größer als'
    case '=':
      return 'genau gleich'
    case '!=':
      return 'nicht gleich'
    default:
      return '??'
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(IndexHeaderFilter)
