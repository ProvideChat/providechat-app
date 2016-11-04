import ChatList from './chat_list';
import React from 'react';

class Chat extends React.Component{

  static get propTypes() {
    return {
      id: React.PropTypes.number,
      name: React.PropTypes.string,
      status_extended: React.PropTypes.string,
      last_message: React.PropTypes.string
    }
  }

  constructor() {
    super()
    this.state = { isReplying: false }
  }

  onToggleReply() {
    this.setState({isReplying: !this.state.isReplying});
  }

  onUpvote(event) {
    this.props.actions.upvoteComment(this.props.restaurantId, this.props);
  }

  onViewChat(event) {
    this.setState({isReplying: false });
  }

  render() {
    return (
      <div>
        <div className="content">
          <img src="/images/monitor/current-chat.png" className="visitor-image" />
          <span className="visitor-name">{ this.props.name }</span>&nbsp;&nbsp;
          <span className="visitor-detail">
            { this.props.status_extended }
          </span>
          <div className="visitor-detail">{ this.props.last_message }</div>
        </div>
        <div className="button">
          <a onClick={this.onViewChat.bind(this)} className="btn btn-default btn-xs" style={{float: "right"}}>
            <i className="fa fa-user"></i> View
          </a>
        </div>
      </div>
    );
  }
}
export default Chat;
