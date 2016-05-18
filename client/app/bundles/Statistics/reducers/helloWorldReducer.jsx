export const initialState = {
  name: '',
}

export default function helloWorldReducer(state = initialState, action) {
  const { type, name } = action;

  switch (type) {
    // case actionTypes.HELLO_WORLD_NAME_UPDATE:
    //   return state.set('name', name);

    default:
      return state;
  }
}
