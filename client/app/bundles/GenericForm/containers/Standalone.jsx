import { connect } from 'react-redux'
import Standalone from '../components/Standalone'

const mapStateToProps = (state, ownProps) => {
  const [ model, idOrNew, edit ] = getBaseData(ownProps)
  const editId = edit ? idOrNew : null
  const heading = headingFor(model, editId)

  return {
    heading,
    model,
    editId,
  }
}

const mapDispatchToProps = (dispatch, ownProps) => ({
})

function headingFor(model, id) {
  let heading
  switch(model) {
  case 'user-teams':
    heading = 'Team'
    break
  case 'divisions':
    heading = 'Division'
    break
  case 'organizations':
    heading = 'Organisation'
    break
  case 'locations':
    heading = 'Standort'
    break
  case 'cities':
    heading = 'Stadt'
    break
  case 'openings':
    heading = 'Öffnungszeiten'
    break
  case 'definitions':
    heading = 'Definitions'
    break
  case 'tags':
    heading = 'Tags'
    break
  case 'federal-states':
    heading = 'Bundesland'
    break
  case 'contact-people':
    heading = 'Kontaktperson'
    break
  case 'solution-categories':
    heading = 'Lösungskategorien'
    break
  case 'emails':
    heading = 'Email'
    break
  case 'offers':
    heading = 'Angebote'
    break
  case 'split-bases':
    heading = 'Split Base'
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

export default connect(mapStateToProps, mapDispatchToProps)(Standalone)
