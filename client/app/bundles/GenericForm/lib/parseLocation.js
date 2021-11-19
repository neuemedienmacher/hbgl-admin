export default function parseLocation(ownProps) {
  if (ownProps.location && ownProps.location.pathname) {
    const pathname = ownProps.location.pathname
    const [_, model, idOrNew, edit] = pathname.split('/')
    return [model, idOrNew, edit]
  }

  return [ownProps.model, ownProps.idOrNew, ownProps.edit]
}
