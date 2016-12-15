import { connect } from 'react-redux'
import omit from 'lodash/omit'
import clone from 'lodash/clone'
import merge from 'lodash/merge'
import { encode } from 'querystring'
import { browserHistory } from 'react-router'
import settings from '../../../lib/settings'
import setUiAction from '../../../Backend/actions/setUi'
import { analyzeFields } from '../../../lib/settingUtils'
import IndexHeaderFilter from '../components/IndexHeaderFilter'

const mapStateToProps = (state, ownProps) => {
  const model = ownProps.model
  const filterName =
    ownProps.filter[0].substring(7, ownProps.filter[0].length - 1)
  const filterValue = ownProps.filter[1]
  const fields = analyzeFields(settings.index[model].fields, model)
  const operatorName = ownProps.params[`operator[${filterName}]`] || '='
  const operators = settings.OPERATORS.map(operator => {
    return {
      value: operator,
      displayName: textForOperator(operator)
    }
  })

  return {
    filterName,
    filterValue,
    fields,
    operators,
    operatorName
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  onTrashClick(event) {
    const params = omit(clone(ownProps.params), ownProps.filter[0])
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
    newParam[`filter[${event.target.value}]`] = ownProps.filter[1]
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
        ownProps.filter[0].substring(7, ownProps.filter[0].length - 1)
    newParam[`operator[${filterName}]`] = operator
    params = merge(params, newParam)

    if(ownProps.uiKey){
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
