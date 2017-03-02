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
  handleResponse: (_formId, data) => dispatch(addEntities(data)),

  afterResponse(response) {
    if (response.data && response.data.id) {
      browserHistory.push(`/assignments/${response.data.id}`)
    }
  }
})

export default connect(
  mapStateToProps,
  mapDispatchToProps,
)(NewOrganizationForm)
