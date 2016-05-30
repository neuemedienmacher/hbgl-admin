// This file is our manifest of all reducers for the app.
// See also /client/app/bundles/HelloWorld/store/statisticsStore.jsx
// A real world app will likely have many reducers and it helps to organize them in one file.
// `https://github.com/shakacode/react_on_rails/tree/master/docs/additional_reading/generated_client_code.md`
import merge from 'lodash/object/merge'
import fetchStatisticsReducer from './fetchStatisticsReducer';
import { initialState as fetchStatisticsState } from './fetchStatisticsReducer';

export default fetchStatisticsReducer

export const initialStates = merge(fetchStatisticsState)
