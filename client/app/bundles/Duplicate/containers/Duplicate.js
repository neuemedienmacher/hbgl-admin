import { connect } from 'react-redux'
import { registerSubmodelForm, setupAction } from 'rform'
import forIn from 'lodash/forIn'
import generateFormId, { uid } from '../../GenericForm/lib/generateFormId'
import seedDataFromEntity from '../../GenericForm/lib/seedDataFromEntity'
import { singularize } from '../../../lib/inflection'
import Duplicate from '../components/Duplicate'
import { BELONGS_TO } from '../../../lib/constants'

const mapStateToProps = (state, ownProps) => {
  const { model, id } = ownProps
  const heading = `${singularize(model)} #${id} duplizieren`

  return {
    heading,
    model,
    id,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch,
})

const mergeProps = (stateProps, dispatchProps, ownProps) => {
  const { dispatch } = dispatchProps
  const submodelFormsToRegister = []

  return {
    ...stateProps,
    ...dispatchProps,
    ...ownProps,

    modifySeedData(seedData, entity, formObjectClass) {
      const submodelsToDuplicate = []

      forIn(formObjectClass.submodelConfig, (options, submodel) => {
        if (options.inverseRelationship === BELONGS_TO) {
          submodelsToDuplicate.push(submodel)
        }
      })

      for (const submodel of submodelsToDuplicate) {
        seedData[submodel] = null
        for (const submodelEntity of entity[submodel]) {
          // fill the array in closure
          submodelFormsToRegister.push({
            submodel,
            submodelEntity,
            formObjectClass,
          })
        }
      }

      // customize fields of duplicated object
      duplicationCustomizations(ownProps.model, entity)

      return seedData
    },

    formStateDidMount(formId) {
      if (!submodelFormsToRegister.length) {
        return
      }

      // use the array in closure
      for (const data of submodelFormsToRegister) {
        const newFormId = generateFormId(data.submodel, stateProps.model, uid())
        const submodelData = seedDataFromEntity(
          data.submodelEntity,
          data.formObjectClass.submodelConfig[data.submodel].object
        )

        dispatch(setupAction(newFormId, submodelData))
        dispatch(registerSubmodelForm(formId, data.submodel, newFormId))
      }
    },
  }
}

const duplicationCustomizations = (model, entity) => {
  switch (model) {
    case 'offers':
      // entity['expires-at'] = DateTime.now + 1.year // ...
      entity['aasm-state'] = 'initialized'
      break
  }
}

export default connect(
  mapStateToProps,
  mapDispatchToProps,
  mergeProps
)(Duplicate)
