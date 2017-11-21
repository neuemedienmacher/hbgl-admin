import { connect } from 'react-redux'
import setupSubscription from '../actions/setupSubscription'
import changeEntity from '../actions/changeEntity'
import { setUi } from '../actions/setUi'
import addEntities from '../actions/addEntities'
import transformJsonApi from '../transformers/json_api'
import Routes from '../components/Routes'

const mapStateToProps = (state, ownProps) => {
  return {}
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  initialSetup() {
    // Subscribe to model instance changes
    dispatch(setupSubscription({ channel: 'ChangesChannel' }, {
      received(data) {
        switch(data.action) {
        case 'change':
          dispatch(changeEntity(data.model, data.id, data.changes))
          break
        case 'addition':
          dispatch(addEntities(transformJsonApi(data.json, data.model)))
          break
        case 'deletion':
          dispatch(changeEntity(data.model, data.id, { _deleted: true }))
          break
        }
      }
    }))
  }
})

export default connect(mapStateToProps, mapDispatchToProps)(Routes)
