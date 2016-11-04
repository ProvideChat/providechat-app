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
    this.setState({isReplying: !this.state.isReplying});
  }

  onUpvote(event) {
    this.props.actions.upvoteComment(this.props.restaurantId, this.props);
  }

  onCommentSubmitted(event) {
    this.setState({isReplying: false });
  }

  render() {
    return (
      <div>
        <div className="content">
          <img src="/images/monitor/waiting-to-chat.png" className="visitor-image" />
          <span className="visitor-name">{ this.props.name }</span>&nbsp;&nbsp;
          <span className="visitor-detail">
            { this.props.status_extended }
          </span>
          <div className="visitor-detail">{ this.props.last_message }</div>
        </div>
        <div className="button">
          <a onClick={this.onAcceptChat.bind(this)} className="btn btn-default btn-xs" style="float: right;">
            <i className="fa fa-comments-o"></i> Accept
          </a>
        </div>
      </div>
    );
  }
}
export default Waiting;
