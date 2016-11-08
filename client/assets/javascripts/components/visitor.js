import VisitorList from './visitor_list';
import React from 'react';

class Visitor extends React.Component{

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

  onInviteChat(event) {
    ProvideChat.initiate_invitation(this.props.id);
  }

  render() {
    return (
      <div className="visitor-snapshot">
        <div className="content">
          <img src="/images/monitor/current-chat.png" className="visitor-image" />
          <div className="visitor-location">
            { this.props.location }&nbsp;&nbsp;
            <img src={ '/images/flags/' + this.props.country_code + '.png' } className="visitor-flag" />
          </div>
          <span className="visitor-detail">
            { this.props.current_page }
          </span>
        </div>
        {this.props.status === "no_chat" &&
          <div className="button">
            <a onClick={this.onInviteChat.bind(this)} className="btn btn-default btn-xs pull-right">
              <i className="fa fa-external-link"></i> Invite
            </a>
          </div>}
      </div>
    );
  }
}
export default Visitor;
