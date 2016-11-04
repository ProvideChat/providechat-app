import _ from 'lodash';
import {
  SET_ACTIVITIES
} from '../actionTypes';

const initialState = [];

export default function activities(state = initialState, action) {
  switch (action.type) {
    case SET_ACTIVITIES:
      return action.activities;

 default:
   return state;
  }

};
