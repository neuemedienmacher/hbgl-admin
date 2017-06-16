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
  const filterValue = getValue(ownProps.filter[1], 0)
  const secondFilterValue = getValue(ownProps.filter[1], 1)
  const nilChecked = ownProps.filter[1] == 'nil'
  // only show filters that are not locked (currently InlineIndex only)
  const fields =
    analyzeFields(settings.index[model].fields, model).filter(value =>
      !ownProps.lockedParams ||
        !ownProps.lockedParams.hasOwnProperty(`filters[${value.field}]`)
    )
  const operatorName = ownProps.params[`operators[${filterName}]`] || '='
  const range = 
    (operatorName == "..." && filterType != 'text') ? 'visible' : 'hidden'
  const operators = settings.OPERATORS.map(operator => {
    return {
      value: operator,
      displayName: textForOperator(operator, filterType, ownProps)
    }
  })

  return {
    filterName,
    nilChecked,
    filterType,
    fields,
    operators,
    operatorName,
    range,
    filterValue,
    secondFilterValue
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  onTrashClick(event) {
    let filterId = ownProps.filter[0].split('[')
    const params = omit(clone(ownProps.params),
                  [ownProps.filter[0], 'operators[' + filterId[1]])

    let query = searchString(ownProps.model, params)
    browserHistory.replace(`/${query}`)

    // if(ownProps.uiKey){
    //   debugger
    //   dispatch(setUiAction(ownProps.uiKey, params))
    // }
    // else{
    //   browserHistory.replace(`/${ownProps.model}?${encode(params)}`)
    // }
  },

  onFilterNameChange(event) {
    let params = omit(clone(ownProps.params), ownProps.filter[0])
    let newParam = {}
    newParam[`filters[${event.target.value}]`] = ''
    params = merge(params, newParam)

    let query = searchString(ownProps.model, params)
    browserHistory.replace(`/${query}`)

    // if(ownProps.uiKey){
    //   debugger
    //   dispatch(setUiAction(ownProps.uiKey, params))
    // }
    // else{
    //   debugger
    //   browserHistory.replace(`/${ownProps.model}?${encode(params)}`)
    // }
  },

  onFilterOperatorChange(event) {
    let params = clone(ownProps.params)
    let newParam = {}
    let operator = event.target.value
    let filterName =
        ownProps.filter[0].substring(8, ownProps.filter[0].length - 1)
    newParam[`operators[${filterName}]`] = operator
    params = merge(params, newParam)

    let query = searchString(ownProps.model, params)
    browserHistory.replace(`/${query}`)

    // if(ownProps.uiKey){
    //   let search = {}
    //   search[ownProps.uiKey] = params
    //   let searchString = jQuery.param(search)
    //   debugger
    //   browserHistory.replace(`/?${searchString}`)
    // }
    // else{
    //   debugger
    //   browserHistory.replace(`/${ownProps.model}?${encode(params)}`)
    // }
  },

  onCheckboxChange(event) {
    let params = clone(ownProps.params)
    if (event.target.checked) {
      params[ownProps.filter[0]] = 'nil'
    } else {
      params[ownProps.filter[0]] = ''
    }

    let query = searchString(ownProps.model, params)
    browserHistory.replace(`/${query}`)
    // if (ownProps.uiKey){
    //   debugger
    //   dispatch(setUiAction(ownProps.uiKey, params))
    // }
    // else{
    //   debugger
    //   browserHistory.replace(`/${ownProps.model}?${encode(params)}`)
    // }
  },

  onFilterValueChange(event) {
    let params = clone(ownProps.params)

    if(params['operators[id]'] != '...') {
      params[ownProps.filter[0]] = [event.target.value]
    } else {
      params[ownProps.filter[0]] = 
        [params[ownProps.filter[0]][1]].concat([event.target.value]).slice(-2).
          sort(function(a, b) {return a - b;}); //only take last two elements and sort them
    }
    // console.log(ownProps.uiKey)
    // let searchString = ownProps.uiKey ? '' : ownProps.model

    // browserHistory.replace(`/${searchString}?${encode(params)}`)

    let query = searchString(ownProps.model, params)
    browserHistory.replace(`/${query}`)
    
    // if(ownProps.uiKey){
    //   //dispatch(setUiAction(ownProps.uiKey, params))
    //   let search = {}
    //   search[ownProps.uiKey] = params
    //   let searchString = jQuery.param(search)
    //   debugger
    //   browserHistory.replace(`/?${searchString}`)
    // }
    // else{
    //   debugger
    //   browserHistory.replace(`/${ownProps.model}?${encode(params)}`)
    // }
  },

  onSecondFilterValueChange(event) {
    let params = clone(ownProps.params)
    
    params[ownProps.filter[0]] = 
      [params[ownProps.filter[0]][0]].concat([event.target.value]).slice(-2).
        sort(function(a, b) {return a - b;}); //only take last two elements and sort them
    if(!params[ownProps.filter[0]][0].length){
      alert('Bitte gib einen Anfangswert ein');

      params[ownProps.filter[0]] = params[ownProps.filter[0]].filter(Boolean);
    };

    let query = searchString(ownProps.model, params)
    browserHistory.replace(`/${query}`)
    
    // let searchString = ownProps.uiKey ? '' : ownProps.model

    // browserHistory.replace(`/${searchString}?${encode(params)}`)

    // if(ownProps.uiKey){
    //   //dispatch(setUiAction(ownProps.uiKey, params))
    //   let search = {}
    //   search[ownProps.uiKey] = params
    //   let searchString = jQuery.param(search)
    //   debugger
    //   browserHistory.replace(`/?${searchString}`)
    // }
    // else{
    //   debugger
    //   browserHistory.replace(`/${ownProps.model}?${encode(params)}`)
    // }
  },
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

function getValue(props, index) {
  if(Array.isArray(props)) {
    return props[index]
  } else {
    if(props == 'nil') {
      return ''
    } else {
      return [props]
    }
  }
}


function textForOperator(operator, filterType, ownProps) {
  switch(true) {
    case operator == '<':
      return 'kleiner als'
    case operator == '>':
      return 'größer als'
    case operator == '=':
      return 'genau gleich'
    case operator == '!=':
      return 'nicht gleich'
    case operator == '...' && filterType != 'text':
      return 'zwischen'
    default:
      return ''
  }
}

function searchString(model, params) {
  if(window.location.href.includes(model)) {
    return `${model}?${encode(params)}`
  } else {
    return `?${encode(params)}`
  }
}


export default connect(mapStateToProps, mapDispatchToProps)(IndexHeaderFilter)
