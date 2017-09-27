import { connect } from 'react-redux'
import { browserHistory } from 'react-router'
import { registerSubmodelForm, setupAction } from 'rform'
import forIn from 'lodash/forIn'
import generateFormId, { uid } from '../../GenericForm/lib/generateFormId'
import seedDataFromEntity from '../../GenericForm/lib/seedDataFromEntity'
import { singularize } from '../../../lib/inflection'
import Duplicate from '../components/Duplicate'

const mapStateToProps = (state, ownProps) => {
  const id = ownProps.params.id
  const pathname = ownProps.location.pathname
  const model = pathname.split('/')[1]
  const heading = `${singularize(model)} #${id} duplizieren`

  return {
    heading,
    model,
    id,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch
})

const mergeProps = (stateProps, dispatchProps, ownProps) => {
  const { dispatch } = dispatchProps
  let submodelFormsToRegister = []

  return {
    ...stateProps,
    ...dispatchProps,
    ...ownProps,

    modifySeedData(seedData, entity, formObjectClass) {
      let submodelsToDuplicate = []
      forIn(formObjectClass.submodelConfig, (options, submodel) => {
        if (options.inverseRelationship == 'belongsTo')
          submodelsToDuplicate.push(submodel)
      })

      for (let submodel of submodelsToDuplicate) {
        seedData[submodel] = null
        for (let submodelEntity of entity[submodel]) {
          // fill the array in closure
          submodelFormsToRegister.push(
            {submodel, submodelEntity, formObjectClass}
          )
        }
      }

      return seedData
    },

    formStateDidMount(formId) {
      if (!submodelFormsToRegister.length) return

      // use the array in closure
      for (let data of submodelFormsToRegister) {
        const newFormId = generateFormId(data.submodel, stateProps.model, uid())
        const submodelData = seedDataFromEntity(
          data.submodelEntity,
          data.formObjectClass.submodelConfig[data.submodel].object
        )
        dispatch(setupAction(newFormId, submodelData))
        dispatch(registerSubmodelForm(formId, data.submodel, newFormId))
      }
    }
  }
}

// const duplicationCustomizations = (model, entity) => { // unused
//   switch(model) {
//   case 'offer':
//     entity['expires-at'] = DateTime.now + 1.year // ...
//     break
//   }
// }

export default connect(mapStateToProps, mapDispatchToProps, mergeProps)(
  Duplicate
)
