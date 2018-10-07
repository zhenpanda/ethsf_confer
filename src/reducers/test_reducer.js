import { TEST,PROOF,PROOF_TOO } from '../actions/types';

export default function(state={}, action) {
  switch (action.type) {
    case TEST:
      return {...state, data: action.payload};
    case PROOF:
      return {...state, data: action.payload};
    case PROOF_TOO:
      return {...state, prooftoo: action.payload};
    default: return state;
  }

}