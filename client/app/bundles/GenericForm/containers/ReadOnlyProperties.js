import { connect } from 'react-redux'
import compact from 'lodash/compact'
import ReadOnlyProperties from '../components/ReadOnlyProperties'

const mapStateToProps = (state, ownProps) => {
  const { instance, formObjectClass } = ownProps
  let propertyData = formObjectClass.readOnlyProperties || []

  if (instance) {
    propertyData = compact(propertyData.map(property => {
      if (!instance[property]) return
      return {
        property: property,
        value: instance[property]
      }
    }))
  }

  return {
    propertyData,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({})


export default connect(
  mapStateToProps,
  mapDispatchToProps,
)(ReadOnlyProperties)
