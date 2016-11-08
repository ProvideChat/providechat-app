import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import ChatList from "./chat_list";
import VisitorList from "./visitor_list";
import WaitingList from "./waiting_list";
import ChatFilter from './chat_filter';
import * as Actions from '../actions';
import { watch } from '../actions';


class ActivityContainer extends Component {

  constructor() {
    super();
  }

  componentDidMount() {
    console.log (this.props);
    const { actions: { watch } } = this.props;
    this.interval = setInterval(watch, 1000, this.props.agentId);
  }

  componentDidUnMount() {
    clearInterval(this.interval);
  }

  render() {
    const { offsite, visitors, waiting, chats, actions, agentId } = this.props;

    return (
      <div className="jarviswidget" id="your-chats" data-widget-editbutton="false" 
                                                data-widget-fullscreenbutton="false" 
                                                data-widget-colorbutton="false" 
                                                data-widget-deletebutton="false"
                                                data-widget-togglebutton="false">

        <header role="heading">
          <h2> Current Activity </h2>
          <div className="widget-toolbar">
            <ChatFilter agentId={this.agentId} />
          </div>
        </header>

        <div role="content">
          <div className="widget-body no-padding">
            <div className="people-container">
              <ChatList agentId={agentId} actions={actions} chats={chats} />

              <WaitingList agentId={agentId} actions={actions} waiting_list={waiting} />

              <VisitorList agentId={agentId} actions={actions} visitors={visitors} offsite={offsite} />

            </div>
          </div>
        </div>
      </div>
    );
  }
}

function mapStateToProps(state) {

  return ({
    chats: state.activities.chats,
    waiting: state.activities.waiting,
    visitors: state.activities.visitors,
    offsite: state.activities.offsite
  });
}

function mapDispatchToProps(dispatch) {
  return { actions: bindActionCreators(Actions, dispatch) };
}

export default connect(mapStateToProps, mapDispatchToProps)(ActivityContainer);
