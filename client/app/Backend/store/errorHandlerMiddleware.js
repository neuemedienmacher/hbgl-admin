export default function errorHandlerMiddleware({getState}) {
  return next => action => {
    if (action.error && action.error.statusText == 'Unauthorized') {
      alert('Session ist abgelaufen, bitte neu anmelden')
      window.location.reload()
    } else {
      return next(action);
    }
  };
}

module.exports = errorHandlerMiddleware;
