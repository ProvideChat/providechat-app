import Visitor from './visitor';
import React from 'react';
import _ from 'lodash';

class VisitorList extends React.Component {

  static get propTypes() {
    return {
      actions: React.PropTypes.object,
      agentId: React.PropTypes.number
    }
  }

  componentDidMount() {
    console.log("VISITOR LIST PROPS");
    console.log(this.props);
  }

  render() {
    const { offsite, visitors, agentId, actions } = this.props;

    return (
      <div>
        <div className="people-header">Visitors</div>
        <div id="visitor-container" className="custom-scroll">
          {visitors.length === 0 &&
            <div id="no-visitor-msg" className="chat-container-status">No current visitors</div>}
          {visitors.map( visitor => {
            return (<Visitor
              key={visitor.id}
              {...this.props}
              {...visitor}
              />)
          })}
          {offsite.map( visitor => {
            return (<Visitor
              key={visitor.id}
              {...this.props}
              {...visitor}
              />)
          })}
        </div>
      </div>
    );
  }
}
export default VisitorList
