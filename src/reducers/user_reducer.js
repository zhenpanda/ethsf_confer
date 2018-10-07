import { USER } from '../actions/types';

export default function(state={}, action) {

  switch (action.type) {
    case USER:
      return {...state, data: action.payload};
    default: return state;
  }

}