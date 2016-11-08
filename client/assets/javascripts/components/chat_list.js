import Chat from './chat';
import React from 'react';
import _ from 'lodash';

class ChatList extends React.Component {

  static get propTypes() {
    return {
      actions: React.PropTypes.object,
      agentId: React.PropTypes.number
    }
  }

  componentDidMount() {
    console.log("CHAT LIST PROPS");
    console.log(this.props);
  }

  /*
  chatsFiltered(chats, agentId) {
    return _.chain(chats)
      //.select(c => { return c && c.parent_id === parentId; })
      //  .sortBy('rank')
      //  .reverse()
        .value();
  }
  */

  render() {
    const { chats, agentId, actions } = this.props;
    //const filteredChats = this.chatsFiltered(chats, this.props.agent_id);

    return (
      <div>
        <div className="people-header">Current Chats</div>
        <div id="current-chat-container" className="custom-scroll">
          {chats.length === 0 &&
            <div id="no-current-chats-msg" className="chat-container-status">No current chats</div>}
          {chats.map( chat => {
            return (<Chat
              key={chat.id}
              {...this.props}
              {...chat}
              />)
          })}
        </div>
      </div>
    );
  }
}
export default ChatList
