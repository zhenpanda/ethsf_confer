import { combineReducers } from 'redux';

import testReducer from './test_reducer';
import userReducer from './user_reducer';
import stageReducer from './stage_reducer';

const rootReducer = combineReducers({
  test: testReducer,
  user: userReducer,
  stage: stageReducer
});

export default rootReducer;