import { connect } from 'react-redux'
import loadAjaxData from '../../../Backend/actions/loadAjaxData'
import setUi from '../../../Backend/actions/setUi'
import NewEdit from '../components/NewEdit'

const mapStateToProps = (state, ownProps) => {
  const [ model, idOrNew, edit ] = getBaseData(ownProps)
  const editId = edit ? idOrNew : null
  const heading = headingFor(model, editId)
  const uiDataLoadedFlag = `GenericForm-edit-loaded-${model}-${editId}`
  const loadedOriginalData = state.ui[uiDataLoadedFlag] || false

  return {
    heading,
    model,
    editId,
    loadedOriginalData,
    uiDataLoadedFlag,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
  dispatch
})

const mergeProps = (stateProps, dispatchProps, ownProps) => {
  return {
    ...stateProps,
    ...dispatchProps,
    ...ownProps,

    loadData() {
      const { model, editId } = stateProps
      if (!editId) return

      dispatchProps.dispatch(
        loadAjaxData(
          `${model}/${editId}`, '', model, undefined, undefined, () => {
            dispatchProps.dispatch(setUi(stateProps.uiDataLoadedFlag, true))
          }
        )
      )
    },
  }
}

function headingFor(model, id) {
  let heading
  switch(model) {
  case 'user_teams':
    heading = 'Team'
    break
  case 'divisions':
    heading = 'Abteilung'
    break
  default:
    throw new Error(`Please provide a GenericForm heading for ${model}`)
  }
  return heading + ( id ? ` #${id} bearbeiten` : ' anlegen' )
}

function getBaseData(ownProps) {
  if (ownProps.location && ownProps.location.pathname) {
    const pathname = ownProps.location.pathname
    const [_, model, idOrNew, edit] = pathname.split('/')
    return [model, idOrNew, edit]
  } else {
    return [ownProps.model, ownProps.idOrNew, ownProps.edit]
  }
}

export default connect(
  mapStateToProps,
  mapDispatchToProps,
  mergeProps,
)(NewEdit)
