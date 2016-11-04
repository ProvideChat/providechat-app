import Api from './api';
import {
  SET_CHAT_FILTER,
  SET_ACTIVITIES,
  ACCEPT_CHAT,
  CANCEL_CHAT,
  INVITE_VISITOR
} from './actionTypes'

export function setChatFilter(agentId) {
  return dispatch => {
    Api.put('/restaurants/${agentId}//upvote').then( json => {
      dispatch({
        type: SET_CHAT_FILTER,
        comment: json
      });
    });
  }
}

export function acceptChat(agentId, params) {
  return dispatch => {
    Api.post('/restaurants/${agentId}/comments', { comment: params }).then(chat => {
      dispatch({
        type: ACCEPT_CHAT,
        visitor: visitor
      });
    });
  };
}

export function watch(agentId) {
  return dispatch => {
    Api.get('/activities').then( activities => {
      dispatch({
        type: SET_ACTIVITIES,
        activities: activities
      });
    });
  };
}
