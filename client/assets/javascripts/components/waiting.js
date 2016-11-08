import WaitingList from './waiting_list';
import React from 'react';

class Waiting extends React.Component{

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

  onAcceptChat() {
    ProvideChat.initiate_accept_chat(this.props.id);
  }

  render() {
    return (
      <div className="visitor-snapshot">
        <div className="content">
          <img src="/images/monitor/waiting-to-chat.png" className="visitor-image" />
          <span className="visitor-name">{ this.props.name }</span>&nbsp;&nbsp;
          <span className="visitor-detail">
            { this.props.status_extended }
          </span>
          <div className="visitor-detail">{ this.props.last_message }</div>
        </div>
        <div className="button">
          <a onClick={this.onAcceptChat.bind(this)} className="btn btn-default btn-xs pull-right">
            <i className="fa fa-comments-o"></i> Accept
          </a>
        </div>
      </div>
    );
  }
}
export default Waiting;
