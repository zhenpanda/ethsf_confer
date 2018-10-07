import { STAGE } from '../actions/types';

export default function(state={}, action) {
  switch (action.type) {
    case STAGE:
      return {...state, data: action.payload};
    default: return state;
  }

}