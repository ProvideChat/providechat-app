(function(ProvideChat, $,undefined) {
  "use strict";

  ProvideChat.agent_id = 0;
  ProvideChat.agent_name = '';
  ProvideChat.organization_id = 0;
  ProvideChat.initialized = false;

  ProvideChat.activeChatId = 0;	// the chat id of the currently active tab

  ProvideChat.chatStatus = [];	// associate array holding the status of all active chats - chatStatus[chatId] = status
  ProvideChat.last_sender = []; // associate array holding the last sender in active chats - last_sender[chatId] = last_sender
  ProvideChat.last_message_id = []; // associate array holding the last message id in active chats - last_message_id[chatId] = last_sender

  ProvideChat.chat_message_queue = []; // associate array holding queue of unsent messages - chat_message_queue[] = messages

  ProvideChat.chatTimer = [];	// array of timers for each active chat - chatTimer[chatId]
  ProvideChat.keypressStatusTimer = [];	// array of timers for getting the keypress status of each active chat: keypressStatusTimer[chatId]
  ProvideChat.clearKeypressTimer = [];		// array of timers for clearing an agent keypress state
  ProvideChat.visitorWaitingTimer;
  ProvideChat.visitorTimer;	// timer that controls the visitor info updates
  ProvideChat.chatQueueTimer;	// timer that controls posting agent message to the server

  ProvideChat.numChats = 0;

  ProvideChat.init = function (agent_id, agent_name, organization_id) {
    if (ProvideChat.initialized === false) {
      ProvideChat.agent_id = agent_id;
      ProvideChat.agent_name = agent_name;
      ProvideChat.organization_id = organization_id;

      updateVisitors();

      ProvideChat.visitorTimer = setInterval(function(){updateVisitors();}, 3000);
      ProvideChat.chatQueueTimer = setInterval(function(){sendChatMessageQueue();}, 3000);
      ProvideChat.initialized = true;

      bind_filter_results_button();
    }
  };

  function updateInChat(visitor) {

    if ($("#waiting-to-chat-visitor-" + visitor.id).length > 0) {
      $("#waiting-to-chat-visitor-" + visitor.id).remove();
    }

    if ($("#in-chat-visitor-" + visitor.id).length > 0) {
      $("#visitor-detail-" + visitor.id).html(visitor.status_extended);
      $("#visitor-last-message-" + visitor.id).html(visitor.last_message);

      $("#visitor-page-views-" + visitor.id).html(visitor.page_views);
      $("#visitor-time-on-site-" + visitor.id).html(visitor.time_since_created);
      $("#visitor-current-page-" + visitor.id).html('<a href="' + visitor.current_page + '" target="_blank" style="color: #0066CC;">' + visitor.current_page + '</a>');
    } else {
      var visitor_content = '<div class="content"><img src="/images/monitor/current-chat.png" class="visitor-image">';
      visitor_content += '<span class="visitor-name">' + visitor.name + '</span>&nbsp;&nbsp;';
      visitor_content += '<span class="visitor-detail" id="visitor-detail-' + visitor.id + '">' + visitor.status_extended + '</span>';
      visitor_content += '<div class="visitor-detail" id="visitor-last-message-' + visitor.id + '">' + visitor.last_message + '</div></div>';
      visitor_content += '<div class="button"><a href="javascript:void(0);" id="view_visitor_' + visitor.id + '" data-visitor-id="' + visitor.id + '" data-chat-id="' + visitor.chat_id + '" data-visitor-name="' + visitor.name + '" data-chat-status="' + visitor.chat.status + '" class="btn btn-default btn-xs" style="float: right;"><i class="fa fa-user"></i> View</a></div>';

      $('#current-chat-container').append("<div id='in-chat-visitor-" + visitor.id + "' class='visitor-snapshot'>" + visitor_content + "</div>");

      $('#view_visitor_' + visitor.id).click(function() {
        add_new_tab ($(this).data("chat-id"), $(this).data("visitor-id"), $(this).data("visitor-name"), $(this).data("chat-status"));
      });
      add_new_tab (visitor.chat_id, visitor.id, visitor.name, visitor.chat.status);
    }
  }

  function waitingToChatAlert() {

    if ($("#waiting-to-chat-container").length) {
      $.bigBox({
        title : "A visitor is waiting to chat",
        content: "Click the <strong>Accept</strong> button beside the visitor",
        color : "#296191",
        timeout: 4000
      });
    } else {
      $.bigBox({
        title : "A visitor is waiting to chat",
        content : "<a href='/monitor' class='btn btn-primary btn-sm'>View the chat monitor</a>",
        color : "#296191",
        timeout: 4000
      });
    }
  }

  function updateWaitingToChat(visitor) {

    // If on the chat monitor
    if ($("#waiting-to-chat-container").length) {

      if ($("#no-chat-visitor-" + visitor.id).length > 0) {
        $("#no-chat-visitor-" + visitor.id).remove();
      }

      if ($("#waiting-to-chat-visitor-" + visitor.id).length > 0) {
        $("#visitor-detail-" + visitor.id).html(visitor.status_extended);
      } else {
        waitingToChatAlert();
        clearInterval(ProvideChat.visitorWaitingTimer);
        ProvideChat.visitorWaitingTimer = setInterval(function(){waitingToChatAlert();}, 12000);

        var visitor_content = '<div class="content"><img src="/images/monitor/waiting-to-chat.png" class="visitor-image">';
        visitor_content += '<div class="visitor-name">' + visitor.name + '</div>';
        visitor_content += '<div class="visitor-detail" id="visitor-detail-' + visitor.id + '">' + visitor.status_extended + '</div></div>';
        visitor_content += '<div class="button"><a href="javascript:void(0);" id="accept_chat_' + visitor.id + '" data-visitor-id="' + visitor.id + '" class="btn btn-default btn-xs" style="float: right;"><i class="fa fa-comments-o"></i> Accept</a></div>';

        $('#waiting-to-chat-container').append("<div class='visitor-snapshot' id='waiting-to-chat-visitor-" + visitor.id + "'>" + visitor_content + "</div>");

        $('#accept_chat_' + visitor.id).click(function() {
          $(this).hide();
          accept_chat($(this).data("visitor-id"));
        });
      }
    } else { // if not on the chat monitor
      if (!(ProvideChat.visitorWaitingTimer > 0)) {
        waitingToChatAlert();
        ProvideChat.visitorWaitingTimer = setInterval(function(){waitingToChatAlert();}, 12000);
      }
    }
  }

  function updateNoChat(visitor) {

    if ($("#no-chat-visitor-" + visitor.id).length > 0) {
      $("#visitor-detail-" + visitor.id).html(visitor.current_page);
    } else {

      var visitor_content = '<div class="content">';
      visitor_content += '<img src="/images/monitor/visitor-browsing.png" class="visitor-image">';
      visitor_content += '<div class="visitor-location">' + visitor.city + ', ' + visitor.country_name + '&nbsp;&nbsp;<img width="16px" height="16px" src="/images/flags/' + visitor.country_code + '.png" style="vertical-align: top;"></div>';
      visitor_content += '<div class="visitor-detail" id="visitor-detail-' + visitor.id + '">' + visitor.current_page + '</div></div>';
      visitor_content += '<div class="button"><a href="javascript:void(0);" id="invite_chat_' + visitor.id + '" data-visitor-id="' + visitor.id + '" class="btn btn-default btn-xs" style="float: right;"><i class="fa fa-external-link"></i> Invite</a></div>';

      $('#visitor-container').append("<div class='visitor-snapshot' id='no-chat-visitor-" + visitor.id + "'>" + visitor_content + "</div>");

      $('#invite_chat_' + visitor.id).click(function() {
        $(this).hide();
        invite_chat($(this).data("visitor-id"));
      });
    }
  }

  function updateVisitors () {

    $.getJSON("/visitors.json", { "current": "true" }, function (results) {

      var in_chat = 0;
      var waiting_to_chat = 0;
      var visitors = 0;

      $('#current-chat-loading').hide();
      $('#waiting-to-chat-loading').hide();
      $('#no-chat-loading').hide();

      if (results.length == 0) {
        $('#no-current-chats-msg').show();
        $('#no-waiting-chats-msg').show();
        $('#no-visitor-msg').show();

        $('#current-chat-container').find(".visitor-snapshot").remove();
        $('#waiting-to-chat-container').find(".visitor-snapshot").remove();
        $('#visitor-container').find(".visitor-snapshot").remove();
      }

      $.each(results, function(i, visitor) {
        //console.log(visitor);

        $('#no-current-chats-msg').hide();
        $('#no-waiting-chats-msg').hide();
        $('#no-visitor-msg').hide();

        if ((visitor.status === "in_chat") || (visitor.status === "chat_ended")) {

          updateInChat(visitor);
          in_chat++;

        }
        else if (visitor.status === "waiting_to_chat") {

          updateWaitingToChat(visitor);
          waiting_to_chat++;
        }
        else if (visitor.status === "no_chat") {

          updateNoChat(visitor);
          visitors++;
        }
      });

      if (in_chat === 0) {
        $('#no-current-chats-msg').show();
        $('#current-chat-container').find(".visitor-snapshot").remove();
      }
      if (waiting_to_chat === 0) {
        clearInterval(ProvideChat.visitorWaitingTimer);
        $('#no-waiting-chats-msg').show();
        $('#waiting-to-chat-container').find(".visitor-snapshot").remove();
      }
      if (visitors === 0) {
        $('#no-visitor-msg').show();
        $('#visitor-container').find(".visitor-snapshot").remove();
      }
    });
  }

  function processVisitorName(visitor) {
    var visitor_name = '';

    if (visitor.name) {
      visitor_name = visitor.name;
    } else {
      if (visitor.remote_host == 'Unknown Host') {
        visitor_name = visitor.remote_addr;
      } else {
        visitor_name = visitor.remote_host + " (" + visitor.remote_addr + ")";
      }
    }

    return visitor_name;
  }

  function processAgent(visitor) {
    if (visitor.chat_status == 'in_chat') {
      return visitor.agent.display_name;
    } else {
      return "None";
    }
  }

  function processDepartmentName(visitor) {
    var department = '';
    if (visitor.department) {
      department = visitor.department;
    } else {
      department = "Not specified";
    }

    return department;
  }

  function viewVisitor( visitor_id ) {

    $.getJSON("/visitors/" + visitor_id + ".json", {}, function (response) {
      var visitor = response.visitor;

      //console.log (visitor);

      var visitorInfo = '';

      visitorInfo += "<h5>" + visitor.name + "'s Information</h5>";
      visitorInfo += '<div class="visitor-info-box">';
      if (visitor.email == '') {
        visitorInfo += '<p><b>Email:</b> <em>Not specified</em></p>';
      } else {
        visitorInfo += '<p><b>Email:</b> ' + visitor.email + '</p>';
      }
      if (visitor.department == '') {
        visitorInfo += '<p><b>Department:</b> <em>Not specified</em></p>';
      } else {
        visitorInfo += '<p><b>Department:</b> ' + visitor.department + '</p>';
      }
      visitorInfo += '<p><b>Location: </b>' + visitor.city + ', ' + visitor.region_name + ', ';
      visitorInfo +=  visitor.country_name + '&nbsp;&nbsp;<img width="20px" height="20px" src="/images/flags/' + visitor.country_code + '.png" style="vertical-align: top;">' + '</p>';
      visitorInfo += '</div>';
      visitorInfo += '<h5 style="padding-top: 10px;">Viewing Habits</h5>';
      visitorInfo += '<div class="visitor-info-box">';
      visitorInfo += '<p><b>Pages Viewed: </b><span id="visitor-page-views-' + visitor.id + '">' + visitor.page_views + '</span></p>';
      visitorInfo += '<p><b>Time on Site: </b><span id="visitor-time-on-site-' + visitor.id + '">' + visitor.time_since_created + '</span></p>';
      visitorInfo += '<p><b>Current Page: </b><span id="visitor-current-page-' + visitor.id + '"><a href="' + visitor.current_page + '" target="_blank" style="color: #0066CC;">' + visitor.current_page + '</a></span></p>';
      visitorInfo += '</div>';
      visitorInfo += '<h5 style="padding-top: 10px;">System Information</h5>';
      visitorInfo += '<div class="visitor-info-box">';
      visitorInfo += '<p><b>Screen Resolution: </b>' + visitor.screen_resolution + '</p>';
      visitorInfo += '<p><b>Browser: </b>' + visitor.browser_name + ' (Version ' + visitor.browser_version + ')';
      visitorInfo += '&nbsp;&nbsp;<img src="' + visitor.browser_image + '" height="16px" width="16px" style="vertical-align: top;">';
      visitorInfo += '<p><b>Operating System: </b>' + visitor.operating_system + '&nbsp;&nbsp;<img src="' + visitor.os_image + '" height="16px" width="16px" style="vertical-align: top;"></p>';
      visitorInfo += '</div>';

      $('#visitor-info-' + visitor.id).html(visitorInfo);
    });
  }

  function invite_chat( visitor_id ) {

    var json_data = { "method": 'send_chat_invite', "agent_id": ProvideChat.agent_id, "visitor_id": visitor_id };

    $.getJSON("/api/chat_monitor.json", json_data, function (response) {
      if (response.success == "invited") {
        $.bigBox({
          title : "Chat invitation sent to visitor",
          color : "#296191",
          timeout: 4000
        });
      } else if (response.success == "max_chats") {
        swal({
          title: "Max chat limit",
          text: "We're sorry but as a free account you are limited to a single simultaneous chat.",
          type: "error",
          confirmButtonText: "Close"
        });
      }
    });
  }

  function accept_chat( visitor_id ) {

    var json_data = { "method": 'accept_chat', "agent_id": ProvideChat.agent_id, "visitor_id": visitor_id, "agent_name": ProvideChat.agent_name };

    $.getJSON("/api/chat_monitor.json", json_data, function (response) {
      if ((response.status == 'accepted') && (response.chat_id > 0)) {
        ProvideChat.activeChatId = response.chat_id;
      } else if (response.status == 'max_chats') {
        swal({
          title: "Max chat limit",
          text: "We're sorry but as a free account you are limited to a single simultaneous chat.",
          type: "error",
          confirmButtonText: "Close"
        });
      }
    });
  }

  function add_new_tab(chat_id, visitor_id, visitor_name, chat_status) {

    if ($("#chat_tab_" + chat_id).length === 0) {

      var json_data = { "method": 'get_chat_tab', "chat_id": chat_id, "visitor_id": visitor_id, "visitor_name": visitor_name, "chat_status": chat_status };

      $.getJSON("/api/chat_monitor.json", json_data, function (response) {

        var id = $(".nav-tabs").children().length; //think about it ;)
        var tabId = 'chat-container-' + response.chat_id;
        //console.log(tabId);
        //console.log(response.visitor_name);
        $('.tab-content').append('<div class="tab-pane" id="' + tabId + '">' + response.html + '</div>');
        $('.nav-tabs').append('<li id="chat-tab-container-' + response.chat_id  + '"><a data-toggle="tab" id="chat_tab_' + response.chat_id + '" href="#chat-container-' + response.chat_id + '" data-chat-id="' + response.chat_id + '">' + response.visitor_name + '</a></li>');

        // Method to execute when tab is clicked
        $('#chat_tab_' + response.chat_id).click(function (e) {
          e.preventDefault()
          $(this).tab('show');

          var chat_id = $(this).data('chat-id');
          $('#chat-messages-'+chat_id).animate({scrollTop: $('#chat-messages-'+chat_id)[0].scrollHeight}, 0);
        });

        $('#tabs a:last').tab('show');

        ProvideChat.chatStatus[response.chat_id] = response.chat_status;
        ProvideChat.last_message_id[response.chat_id] = 0;
        ProvideChat.activeChatId = response.chat_id;
        ProvideChat.numChats++;

        viewVisitor(response.visitor_id);

        if (response.chat_status == 'in_progress') {

          $('#send-message-' + response.chat_id).click(function() {
            sendChatText($(this).data("chat-id"));
          });

          $('#end-chat-' + response.chat_id).click(function() {
            endChat($(this).data("chat-id"));
          });

          getChatText( response.chat_id, true );
          setup_chat_keypress(chat_id)

          ProvideChat.chatTimer[response.chat_id] = setInterval(function(){ getChatText(response.chat_id, false); }, 3000);
          ProvideChat.keypressStatusTimer[response.chat_id] = setInterval(function () { getKeypressStatus(response.chat_id); }, 2000);
        } else if ((response.chat_status == 'agent_ended') || (response.chat_status == 'visitor_ended') || (response.chat_status == 'agent_timeout')) {
          load_finished_chat(response.chat_id);
        }

        if (ProvideChat.numChats == 1) {
          $("#no-active-chat").hide();
          $('#active-chat-tabs').show();
          $('#tabs').tab('show');
        }

      });

    } else {

      $("#chat_tab_" + chat_id).tab('show');
      ProvideChat.activeChatId = chat_id;

      if (ProvideChat.numChats == 1) {
        $("#no-active-chat").hide();
        $('#active-chat-tabs').show();
        $('#tabs').tab('show');
      }

    }
  }

  function setup_chat_keypress(chat_id) {
    if (ProvideChat.activeChatId == chat_id) {
      $('#chat-message-content-'+chat_id).focus();
    }

    $("#chat-message-content-"+chat_id).keyup(function (e) {

      if ((e.keyCode === 13) && (e.ctrlKey === true)) {
        $("#chat-message-content-"+chat_id).value += "\r\n";
      }
      else if (e.keyCode === 13) {
        sendChatText( chat_id );
        clearAgentKeypress(chat_id);
      } else {
        updateAgentKeypress(chat_id);
      }
    });
  }

  function load_finished_chat( chat_id) {

    var json_data = { "method": 'get_chat_messages', "chat_id": chat_id, "agent_id": ProvideChat.agent_id, "context" : "all" };
    var chatText = '';

    enable_close_chat_tab(chat_id);

    $.getJSON("/api/chat_monitor.json", json_data, function (response) {

      console.log(response);

      var chat_id = response.chat_id;

      $("#chat-messages-"+chat_id).html('<div class="announcement">You are now chatting with ' + response.visitor_name + '</div>');

      $.each(response.messages, function(count, message) {

        //console.log("MESSAGE: " + message.message);

        chatText += get_chat_message(chat_id, message);
      });

      var end_message = '';
      if (response.status === 'agent_ended') {
        end_message = 'The chat has now ended';
      } else if (response.status === 'visitor_ended') {
        end_message = 'The visitor has now ended the chat.';
      } else if (response.status === 'visitor_timeout') {
        end_message = 'The visitor has left your website, ending the chat.';
      }

      chatText += '<div class="message"><div class="message-text">';
      chatText += '<h5>' + end_message +  '</h5><br><b>Chat Statistics:</b><br>';
      chatText += 'Chat started at ' + '<em>' +  formatAMPM(new Date(response.started)) + '</em><br>';
      chatText += 'Chat lasted for ' + response.duration + '</div></div>';


      append_chat_message(chat_id, chatText);
    });
  }

  //Gets the current messages from the server
  function getChatText( chat_id, get_all_messages ) {

    var json_data = { "method": 'get_chat_messages', "chat_id": chat_id, "agent_id": ProvideChat.agent_id, "last_message_id" : ProvideChat.last_message_id[chat_id]};

    if (get_all_messages === true) {
      //json_data.last_message_id = 0;
      json_data.context = 'all';
    }

    $.getJSON("/api/chat_monitor.json", json_data, function (response) {

      console.log(response);

      var chatText = '';
      var newMessageAlert = false;
      var chat_id = response.chat_id;

      if ((get_all_messages === true) || ($("#chat-messages-"+chat_id).length === 0)) {
        $("#chat-messages-"+chat_id).html('<div class="announcement">You are now chatting with ' + response.visitor_name + '</div>');
      }

			// if we get some JSON messages returned then process and display them, otherwise
			// show the operator connection message

      ProvideChat.chatStatus[chat_id] = response.status;

      if (response.status === 'in_progress') {

        $.each(response.messages, function(count, message) {

          console.log("Message Obj: " + message);
          chatText += get_chat_message(chat_id, message);

          if (message.sender === "visitor") {
            $('#typing-notification-' + chat_id).html ('');
            newMessageAlert = true;
          }

        });
      } else if ((response.status === 'agent_ended') || (response.status === 'visitor_ended') ||
                   (response.status === 'visitor_timeout'))
      {
        var end_message = '';
        if (response.status === 'agent_ended') {
          end_message = 'The chat has now ended.';
        } else if (response.status === 'visitor_ended') {
          end_message = 'The visitor has now ended the chat.';
        } else if (response.status === 'visitor_timeout') {
          end_message = 'The visitor has left your website, ending the chat.';
        }

        chatText = '<hr><div class="announcement">' + end_message + '</div>';

        console.log("ChatID: " + chat_id + ", Clearing Interval ID: " + ProvideChat.chatTimer[chat_id]);
        clearInterval(ProvideChat.chatTimer[chat_id]);
        clearInterval(ProvideChat.keypressStatusTimer[chat_id]);
        $('#typing-notification-' + chat_id).html ('');

        enable_close_chat_tab(chat_id);
      }

      append_chat_message(chat_id, chatText);

      if ((get_all_messages === false) && (newMessageAlert === true)) {
        if (!$('#chat-tab-container-' + chat_id).hasClass('active')) {

          $.bigBox({
            title : "New message received from " + response.visitor_name,
            color : "#C79121",
            timeout: 4000,
            sound_file: 'smallbox'
          });
				}
      }

    });
  }

  function get_chat_message (chat_id, message) {

    var chat_message = '';
    var message_timestamp = new Date(message.sent);

    if (ProvideChat.last_sender[chat_id] === message.sender)
    {
      chat_message = '<div class="appended-message"><div class="message-text">' + message.message + '</div></div>';
    }
    else
    {
      chat_message = '<div class="message"><div class="message-text">';
      chat_message += '<time>' + formatAMPM(message_timestamp) + '</time>';
      chat_message += '<div class="' + message.sender + '-name">' + message.user_name  + '</div> ' + message.message + '</div></div>';
    }

    console.log("Chat Message: " + chat_message);
    ProvideChat.last_message_id[chat_id] = message.id;
    ProvideChat.last_sender[chat_id] = message.sender;

    return chat_message;
  }

  function append_chat_message(chat_id, chat_message) {
    if (chat_message.length > 0) {
      $("#chat-messages-"+chat_id).append(chat_message);
      if (typeof $('#chat-messages-'+chat_id)[0] !== 'undefined') {
        $('#chat-messages-'+chat_id).animate({scrollTop: $('#chat-messages-'+chat_id)[0].scrollHeight}, 0);
      }
    }
  }

  function getKeypressStatus(chat_id) {

    var json_data = { "method": 'get_visitor_typing', "chat_id": chat_id };

    $.getJSON("/api/chat_monitor.json", json_data, function (response) {
      var chat_id = response.chat_id;

      if (response.visitor_typing == 'yes' ) {
        $('#typing-notification-' + chat_id).html ('<i>' + response.visitor_name + ' is typing...</i>');
      } else {
        $('#typing-notification-' + chat_id).html ('');
      }
    });
  }

  function sendChatMessageQueue() {

    if (ProvideChat.chat_message_queue.length > 0) {
      var message_queue = ProvideChat.chat_message_queue;
      ProvideChat.chat_message_queue = [];

      var json_data = { "method" : "save_chat_messages", "org_id" : ProvideChat.org_id, 
                        "messages" : message_queue };

      $.getJSON("/api/chat_monitor.json", json_data, function (response) {});
    }
  }

  function sendChatText(chat_id) {

    if (ProvideChat.chatStatus[chat_id] === 'in_progress') {
      var message = $("#chat-message-content-" + chat_id).val().slice(0,-1);

      if (message.length === 0) {
        $('#chat-message-content-' + chat_id).val('');
        $('#chat-message-content-' + chat_id).focus();
      } else {

        var msg_text = $('#chat-message-content-' + chat_id).val();

        msg_text = msg_text.replace(/<\/?[^>]+(>|$)/g, "");
        msg_text = msg_text.replace(/\r?\n|\r/g, "<br>");

        $('#chat-message-content-' + chat_id).val('');
        $('#chat-message-content-' + chat_id).focus();

        var chat_message = {
          "chat_id": chat_id,
          "sender": "agent",
          "user_name": ProvideChat.agent_name,
          "sent": (new Date()).toJSON(),
          "message": msg_text
        };

        ProvideChat.chat_message_queue.push(chat_message);

        var chat_text = get_chat_message(chat_id, chat_message);
        append_chat_message(chat_id, chat_text);

      }
    } else if (ProvideChat.chatStatus[chat_id] === 'not_started') {
      alert ("You must accept a chat before sending a message");
    } else if ((ProvideChat.chatStatus[chat_id] === 'agent_ended') || (ProvideChat.chatStatus[chat_id] === 'visitor_ended') ||
              (ProvideChat.chatStatus[chat_id] === 'agent_timeout') || (ProvideChat.chatStatus[chat_id] === 'visitor_timeout'))
    {
      alert ("This chat has now ended");
    }
  }

  function inviteVisitor(visitor_id)
  {
    var edition = $("#edition").val();

    if (edition === 'free') {
      $("#chat-invite-unavailable").dialog('open');
    } else {

      if (visitor_id > 0) {

        $.ajax({
          type: "POST",
          dataType: "json",
          url: "process-chat.php",
          data: "visitorId=" + visitor_id + "&operatorId=" + operatorId + "&action=send_invite",
          success: function (json) {

            if (json) {

              if (json.result === 'invitation_sent') {
                displayMessage('Invitation Sent!', 'You just sent a chat invitation to the selected visitor');
              } else if (json.result === 'invitation_already_sent') {
                displayMessage('Invitation Not Sent', 'This visitor has already been sent an invitation');
              } else if (json.result === 'operator_offline') {
                displayMessage('Invitation Not Sent', 'You need to be online in order to send an invitation');
              }

              inviteChatOff();
            }
          }
        });
      }
    }

    return true;
  }

  function endChat(chat_id) {

    var json_data = { "method": 'end_chat', "chat_id": chat_id };

    $.getJSON("/api/chat_monitor.json", json_data, function (response) {
      //console.log(response);
      if (response.success == 'true') {
        enable_close_chat_tab(response.chat_id);

        if (ProvideChat.numChats > 0) {
          ProvideChat.numChats--;
        }
      }
    });
  }

  function enable_close_chat_tab(chat_id) {
    $('#close-tab-' + chat_id).removeClass('disabled');
    $('#close-tab-' + chat_id).prop('disabled', false);

    $('#end-chat-' + chat_id).addClass('disabled');
    $('#end-chat-' + chat_id).attr("disabled", "disabled");

    $('#close-tab-' + chat_id).click(function() {
      close_chat_tab( $(this).data("chat-id") );
    });
  }

  function close_chat_tab(chat_id) {

    //console.log("Close Chat Tab, ID: " + chat_id);

    $('#chat-container-' + chat_id).remove();
    $('#chat-tab-container-' + chat_id).remove();

    if ($(".tab-pane" + chat_id).length === 0) {
      $('#active-chat-tabs').hide();
      $("#no-active-chat").show();
    } else {
      $('#tabs a:last').tab('show');
    }
  }

  function clearAgentKeypress(chat_id) {
    var json_data = { "method": 'update_agent_keypress', "chat_id": chat_id, "typing" : "no" };

    $.getJSON("/api/chat_monitor.json", json_data, function (response) {

    });
  }

  function updateAgentKeypress(chat_id) {

    var json_data = { "method": 'update_agent_keypress', "chat_id": chat_id, "typing" : "yes" };

    $.getJSON("/api/chat_monitor.json", json_data, function (response) {

      if (typeof ProvideChat.clearKeypressTimer[response.chat_id] != 'undefined') {
        clearTimeout(ProvideChat.clearKeypressTimer[response.chat_id]);
      }
      ProvideChat.clearKeypressTimer[response.chat_id] = setTimeout(function () { clearAgentKeypress(response.chat_id); }, 2000);
    });
  }

  function formatAMPM(date) {
    var hours = date.getHours();
    var minutes = date.getMinutes();
    var ampm = hours >= 12 ? 'pm' : 'am';
    hours = hours % 12;
    hours = hours ? hours : 12; // the hour '0' should be '12'
    minutes = minutes < 10 ? '0'+minutes : minutes;
    var strTime = hours + ':' + minutes + ' ' + ampm;
    return strTime;
  }

  function bind_filter_results_button() {
    $(".filter-result-update a").click(function() {
      var selText = $(this).text();
      var filter = $(this).data('filter');
      var $this = $(this);
      $this.parents('.btn-group').find('.dropdown-toggle').html(selText + ' <span class="caret"></span>');
      $this.parents('.dropdown-menu').find('li').removeClass('active');
      if (filter === 'mine') {
        $('#filter-results').html('My Chats <i class="fa fa-caret-down"></i>');
        //update_agent_availability('online');
      } else if (filter === 'all') {
        $('#filter-results').html('All Chats <i class="fa fa-caret-down"></i>');
        //update_agent_availability('offline');
      }
      $this.parent().addClass('active');
    });
  }

})(window.ProvideChat = window.ProvideChat || {}, jQuery);

