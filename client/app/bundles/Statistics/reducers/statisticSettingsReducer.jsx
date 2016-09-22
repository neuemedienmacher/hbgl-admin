import merge from 'lodash/merge'
import assign from 'lodash/assign'
import without from 'lodash/without'

export const initialState = {
  statisticSettings: {
    startDate: undefined,
    endDate: undefined,
    selectedUsers: [],
  },
}

export default function statisticSettingsReducer(state = initialState, action) {
  switch (action.type) {
    case 'UPDATE_DATE_RANGE':
      return merge({}, state, {
        statisticSettings: {
          startDate: action.range.startDate,
          endDate: action.range.endDate,
        }
      })

    case 'SELECT_USER':
      let newState = assign({}, state)
      newState.statisticSettings.selectedUsers.push(action.user_id)
      return newState

    case 'UNSELECT_USER': {
      let newState = assign({}, state)
      newState.statisticSettings.selectedUsers =
        without(state.statisticSettings.selectedUsers, action.user_id)
      return newState
    }

    default:
      return state;
  }
}
