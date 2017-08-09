import { connect } from 'react-redux'
import moment from 'moment'
import { browserHistory } from 'react-router'
import valuesIn from 'lodash/valuesIn'
import cloneDeep from 'lodash/cloneDeep'
import addEntities from '../../../Backend/actions/addEntities'
import NewOrganizationForm from '../components/NewOrganizationForm'

const mapStateToProps = (state, ownProps) => {
  const formId = 'OrganizationForm'

  return {
    formId,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  afterResponse(_formId, data, _errors, _meta, response) {
    dispatch(addEntities(data))

    if (response.data && response.data.id) {
      browserHistory.push(`/assignments/${response.data.id}`)
    }
  }
})

export default connect(
  mapStateToProps,
  mapDispatchToProps,
)(NewOrganizationForm)
