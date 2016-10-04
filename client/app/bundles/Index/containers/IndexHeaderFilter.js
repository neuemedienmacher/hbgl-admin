import { connect } from 'react-redux'
import omit from 'lodash/omit'
import clone from 'lodash/clone'
import merge from 'lodash/merge'
import { encode } from 'querystring'
import { browserHistory } from 'react-router'
import settings from '../../../lib/settings'
import { analyzeFields } from '../../../lib/settingUtils'
import IndexHeaderFilter from '../components/IndexHeaderFilter'

const mapStateToProps = (state, ownProps) => {
  const model = ownProps.model
  const filterName =
    ownProps.filter[0].substring(7, ownProps.filter[0].length - 1)
  const filterValue = ownProps.filter[1]
  const fields = analyzeFields(settings.index[model].fields, model)

  return {
    filterName,
    filterValue,
    fields,

    onTrashClick(event) {
      const params = omit(clone(ownProps.params), ownProps.filter[0])
      browserHistory.replace(`/${ownProps.model}?${encode(params)}`)
    },

    onFilterNameChange(event) {
      let params = omit(clone(ownProps.params), ownProps.filter[0])
      let newParam = {}
      newParam[`filter[${event.target.value}]`] = ownProps.filter[1]
      params = merge(params, newParam)
      browserHistory.replace(`/${ownProps.model}?${encode(params)}`)
    },

    onFilterValueChange(event) {
      let params = clone(ownProps.params)
      params[ownProps.filter[0]] = event.target.value
      browserHistory.replace(`/${ownProps.model}?${encode(params)}`)
    }
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({})

export default connect(mapStateToProps, mapDispatchToProps)(IndexHeaderFilter)
