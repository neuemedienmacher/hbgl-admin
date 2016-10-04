import { connect } from 'react-redux'
import settings from '../../../lib/settings'
import routeForAction from '../../../lib/routeForAction'
import TableRow from '../components/TableRow'

const mapStateToProps = (state, ownProps) => {
  const actions = settings.index[ownProps.model].member_actions.map(action => ({
    icon: iconFor(action),
    href: routeForAction(action, ownProps.model, ownProps.row.id)
  }))

  return {
    actions,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
})

function iconFor(action) {
  switch(action) {
  case 'edit':
    return 'fui-new'
  case 'show':
    return 'fui-eye'
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(TableRow)
