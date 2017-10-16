import { connect } from 'react-redux'
import capitalize from 'lodash/capitalize'
import camelCase from 'lodash/camelCase'
import { singularize } from '../../../lib/inflection'
import settings from '../../../lib/settings'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import History from '../components/History'

const mapStateToProps = (state, ownProps) => {
  const { model, parent } = ownProps
  const klass = capitalize(camelCase(singularize(model)))

  let historyItems =
    state.entities.versions && Object.values(state.entities.versions).filter(
      (v) => v['item-type'] == klass && v['item-id'] == parent.id
    ) || []

  historyItems = historyItems.map(transformHistoryItem(state.entities))
  console.log('items', historyItems)

  return {
    hasHistory: settings.HISTORY_ENABLED.includes(model),
    historyItems
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  loadData() {
    const basePath = `${ownProps.model}/${ownProps.parent.id}/versions`
    dispatch(loadAjaxData(basePath, {}, 'versions'))
  }
})

function transformHistoryItem(entities) {
  return (item) => {
    item.user = entities.users && entities.users[item.whodunnit]
    item.changes = []
    const getChange =
      (_, field, before, after) => item.changes.push({field, before, after})
    item['object-changes'].replace(/\n(.+):\n- (.*)\n- (.*)/g, getChange)
    item.date = new Date(item['created-at']).toLocaleString('de-de')

    return item
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(History)
