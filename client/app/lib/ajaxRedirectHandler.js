import { browserHistory } from 'react-router'
import addFlashMessage from '../Backend/actions/addFlashMessage'

export function handleError(model, dispatch) {
  return function(response) {
    browserHistory.replace(`/${model}`)
    dispatch(addFlashMessage('failure', 'Das Objekt gibt es nicht (mehr)!'))
  }
}
