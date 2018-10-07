import { TEST,PROOF } from '../actions/types';

export default function(state={}, action) {

  switch (action.type) {
    case TEST:
      return {...state, data: action.payload};
    case PROOF:
      return {...state, data: action.payload};
    default: return state;
  }

}