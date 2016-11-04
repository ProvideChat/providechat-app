import React from 'react';
import thunk from 'redux-thunk';
import { createStore, combineReducers, applyMiddleware } from 'redux';
import { Provider }  from 'react-redux';
import * as reducers from  '../reducers';
import ActivityContainer from './activity_container';

const reducer = combineReducers(reducers);
const createStoreWithMiddleware = applyMiddleware(thunk)(createStore);


class ActivitySection extends React.Component {
  constructor(props) {
    console.log("ACTIVITY SECTION PROPS");
    console.log(props);
    super();
    this.agentId = props.agentId;
    this.activities = props.activities;
  }

  render() {
    const store = createStoreWithMiddleware(reducer, { activities: this.activities } );
    return <Provider store={store}>
      { () => <ActivityContainer agentId={this.agentId} /> }
        </Provider>
  }

}
export default ActivitySection;
