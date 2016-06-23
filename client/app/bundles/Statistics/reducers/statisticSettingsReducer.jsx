import assign from 'lodash/object/assign'

export const initialState = {
  statisticSettings: {
    startDate: undefined,
    endDate: undefined,
  },
}

export default function statisticSettingsReducer(state = initialState, action) {
  const { type, range } = action

  switch (type) {
    case 'UPDATE_DATE_RANGE':
      return assign({}, state, {
        statisticSettings: {
          startDate: range.startDate,
          endDate: range.endDate,
        }
      })

    default:
      return state;
  }
}
