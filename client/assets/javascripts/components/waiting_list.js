import Waiting from './waiting';
import React from 'react';
import _ from 'lodash';

class WaitingList extends React.Component {

  static get propTypes() {
    return {
      actions: React.PropTypes.object,
      agentId: React.PropTypes.number
    }
  }

  /*
  componentDidMount() {
    console.log("WAITING LIST PROPS");
    console.log(this.props);
  }
  */

  render() {
    const { waiting_list, agentId, actions } = this.props;

    return (
      <div>
        <div className="people-header">Waiting to Chat</div>
        <div id="waiting-to-chat-container" className="custom-scroll">
          {waiting_list.length === 0 &&
            <div id="no-waiting-chats-msg" className="chat-container-status">No one is currently waiting to chat</div>}
          {waiting_list.map( waiting => {
            return (<Waiting
              key={waiting.id}
              {...this.props}
              {...waiting}
              />)
          })}
        </div>
      </div>
    );
  }
}
export default WaitingList
