import React from 'react';
class ChatFilter extends React.Component {

  static get propTypes() {
    return {
      chatFilter: React.PropTypes.string,
      agent_id: React.PropTypes.number
    }
  }

  constructor(props) {
    super()
    this.defaultState = { chatFilter: 'all' };
    this.state = this.defaultState;
  }

  submitFilter(event) {
    event.preventDefault()
    this.props.addComment(this.props.agentId, _.merge(this.state, {parent_id: this.props.parent_id}));
    this.setState(this.defaultState);
    if (this.props.onCommentSubmitted) {
      this.props.onCommentSubmitted();
    }
  }

  onFieldChange(event) {
    let prop = {}
      prop[event.target.name] = event.target.value;
    this.setState(prop)
  }

  render() {
    return <div>
      <div className="btn-group">
        <button id="filter-results" className="btn dropdown-toggle btn-xs btn-default" data-toggle="dropdown">
          Filter Results <i className="fa fa-caret-down"></i>
        </button>
        <ul className="dropdown-menu pull-right filter-result-update">
          <li>
            <a href="javascript:void(0);" data-filter="mine">My Chats</a>
          </li>
          <li>
            <a href="javascript:void(0);" data-filter="all">All Chats</a>
          </li>
        </ul>
      </div>
    </div>;
  }
}
export default ChatFilter
