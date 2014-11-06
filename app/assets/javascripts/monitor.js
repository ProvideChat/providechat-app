(function(ProvideChat, $,undefined) {
  "use strict";

  ProvideChat.agent_id = 0;

  ProvideChat.activeChatId = 0;	// the chat id of the currently active tab
  ProvideChat.activeChats = [];	// associate array linking tab# to chatId - activeChats[tab#] = chatId

  ProvideChat.tabChatIds = [];	// associate array linking chatId to tab# - tabChatIds[chatId] = tab#
  ProvideChat.tabVisitorIds = [];	// associate array linking visitorId to tab# - tabVisitorIds[tab#] = visitorId
  ProvideChat.chatStatus = [];	// associate array holding the status of all active chats - chatStatus[chatId] = status

  ProvideChat.chatTimer = [];	// array of timers for each active chat - chatTimer[chatId]
  ProvideChat.keypressStatusTimer = [];	// array of timers for getting the keypress status of each active chat: keypressStatusTimer[chatId]
  ProvideChat.keypressMsgTimer = [];		// array of timers for monitoring the keypress state for the operator: keypressMsgTimer[chatId]
  ProvideChat.keypressStatus = [];		// array of keypress statuses for each active chat: keypressStatus[chatId]
  ProvideChat.visitorTimer;	// timer that controls the visitor info updates

  ProvideChat.numChats = 0;

  ProvideChat.init = function (agent_id) {
    ProvideChat.agent_id = agent_id
  	//initjsDOMenu();

    updateVisitors();

    ProvideChat.visitorTimer = setInterval(function(){updateVisitors();}, 10000);
  }

  function updateVisitors () {
    var organization_id = $("#visitor-table").attr("data-id");
    if ($(".comment").length > 0) {
      var after = $(".comment:last-child").attr("data-time");
    } else {
      var after = "0";
    }
    $.getJSON("/visitors.json", function (results) {

      $('#loading_visitors').hide();

      $('#visitors-online').html(results.length);

      var waiting_to_chat = 0;

      if (results.length > 0) {
        if ($("#no-visitors").length == 0) {
          $("#no-visitors").remove();
        }

        $.each(results, function(i, visitor) {
          console.log(visitor);
          if (visitor.status == 'waiting_to_chat') {
            waiting_to_chat = waiting_to_chat + 1;
          }
          var row_bg_color = '#ffffff';
          if (visitor.status == 'waiting_to_chat') {
            row_bg_color = 'yellow';
          }

          if ($("#visitor_row_" + visitor.id).length == 0) {
            var visitor_row = '<tr id="visitor_row_' + visitor.id + '" data-active="true" style="background-color: "' + row_bg_color + ';"><td>' + visitor.id + '</td>';
            visitor_row = visitor_row + '<td>' + processVisitorName(visitor) + '</td>';
            visitor_row = visitor_row + '<td>' + processDepartmentName(visitor) + '</td>';
            visitor_row = visitor_row + '<td>' + processVisitorStatus(visitor) + '</td>';
            visitor_row = visitor_row + '<td>' + processOperator(visitor) + '</td>';
            visitor_row = visitor_row + '<td>' + visitor.current_page + '</td>';
            visitor_row = visitor_row + '<td><button class="btn btn-default btn-xs" onclick="viewVisitor(' + visitor.id + ')">View</button>';
            visitor_row = visitor_row + '&nbsp;<a id="accept_chat_' + visitor.id + '" style="cursor: pointer;"><img id="accept_chat_img" src="images/buttons/accept_chat_off.gif" width="60" height="23" border="0" alt="Accept" /></a>';
            visitor_row = visitor_row + '&nbsp;<a id="invite_chat" style="cursor: pointer;"><img id="invite_chat_img" src="images/buttons/invite_chat_off.gif" width="60" height="23" border="0" alt="Invite" /></a>';
            visitor_row = visitor_row + '</td></tr>'
            $('#visitor-table > tbody:last').append(visitor_row);
            $('#accept_chat_' + visitor.id).click(function() {
              startChat(visitor);
            });
          } else {
            $("#visitor_row_" + visitor.id).css("background-color", row_bg_color);
            $("#visitor_row_" + visitor.id).find("td").eq(1).html(processVisitorName(visitor));
            $("#visitor_row_" + visitor.id).find("td").eq(3).html(processVisitorStatus(visitor));
            $("#visitor_row_" + visitor.id).find("td").eq(4).html(processOperator(visitor));
            $("#visitor_row_" + visitor.id).find("td").eq(5).html(visitor.current_page);

            $("#visitor_row_" + visitor.id).data("active", true);
          }
        });

        $('#waiting-to-chat').html(waiting_to_chat);

        $('#visitor-table > tbody  > tr').each(function() {
          if ($(this).data("active") == true) {
            $(this).data("active", false);
          } else {
            $(this).remove();
          }
        });
      } else {
        if ($("#no-visitors").length == 0) {
          $('#visitor-table > tbody  > tr').each(function() {
            $(this).remove();
          });
          $('#visitor-table').append('<tr id="no-visitors"><td colspan="7"><h4>No visitors at this time</h4></td></tr>');
        }
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

  function processVisitorLocation(visitor) {
    var visitor_location = '';

    if (visitor.chat.status == 'visitorTimeout') {
      visitor_location =  "Visitor timed out, no longer on site";
    } else if (visitor.chat.status == 'operatorTimeout') {
      visitor_location =  "Chat not accepted, visitor sent to unavailable window";
    } else {
      if (visitor.current_page.length > 0) {
        visitor_location =  visitor.current_page;
      }
      else {
        visitor_location =  "Unknown";
      }
    }
    return visitor_location;
  }

  function processVisitorStatus(visitor) {

    var chat_status = '';

    if (visitor.status == 'offsite') {
      chat_status = "Left the site";
    } else if (visitor.status == 'no_chat') {
      chat_status = "Browsing for " + visitor.time_since_created;
    } else if (visitor.status == 'waiting_to_chat') {
      chat_status = "Waiting for " + visitor.time_waiting_to_chat;
    } else if (chatStatus == 'in_chat') {
      chat_status = "Chatting for " + visitor.time_in_chat;
    } else if (chatStatus == 'chat_ended') {
      chat_status = "Chat ended " + visitor.time_since_chat + " ago";
    }

    return chat_status;
  }

  function processOperator(visitor) {
    if (visitor.chatStatus == 'in_chat') {
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


  function visitorChat(visitor) {
		// CHAT STATUS
    if (chatStatus == 'visitorEnded') {
      chatStatus_extended = "Visitor closed chat window";
    } else if (chatStatus == 'visitorTimeout') {
      chatStatus_extended = "Visitor timed out";
    } else if (chatStatus == 'operatorTimeout') {
      chatStatus_extended = "Chat not accepted";
    } else if (chatStatus == 'operatorEnded') {
      chatStatus_extended = "Chat ended";
    } else if (chatStatus == 'inProgress') {
      chatStatus_extended = "Chatting for " + visitors[visitorCount].time_in_chat;
    } else if ((chatStatus == 'notStarted') || (visitorStatus == 'waitingToChat')) {
      chatStatus_extended = "Waiting for " + response.visitors[visitorCount].time_waiting_chat;
    } else if (visitorStatus == 'offSite') {
      chatStatus_extended = "Left site";
    } else {
      chatStatus_extended = "Browsing for " + visitors[visitorCount].time_on_site;
    }
  }

  function viewVisitor( visitor_id ) {

    $.ajax({
      type: "GET",
      dataType: "json",
      url: "/visitors/" + visitor_id + ".json",
      success: function (response) {
        visitor = response.visitor

        console.log (visitor);

        var visitorInfo = '';

        visitorInfo += '<p><b class="maintext">Visitor Information</b></p>';
        visitorInfo += '<table border="0" cellpadding="2" cellspacing="0" style="margin-left: 20px; margin-top: 5px;">';
        visitorInfo += '<tr><td><b>Name: </b></td><td>' + visitor.name + '</td></tr>';
        visitorInfo += '<tr><td><b>Email: </b></td><td>' + visitor.email + '</td></tr>';
        visitorInfo += '<tr><td><b>Department: </b></td><td>' + visitor.department + '</td></tr>';
        visitorInfo += '<tr><td><b>Pages Viewed: </b></td><td>' + visitor.page_views + '</td></tr>';
        visitorInfo += '<tr><td><b>Time on Site: </b></td><td>' + visitor.timeDiff + '</td></tr>';
        visitorInfo += '<tr><td><b>Country: </b></td><td>' + visitor.country + '&nbsp;&nbsp;<img width="32" height="16" src="http://api.hostip.info/flag.php?ip=' + visitor.remoteAddr + '"></td></tr>';
        visitorInfo += '<tr><td><b>Current Page: </b></td><td><a href="' + visitor.current_page + '" target="_blank" style="color: #0066CC;">' + visitor.current_page + '</a></td></tr>';
        visitorInfo += '<tr><td colspan="2"><br><b>Initial Question: </b></td></tr>';
        visitorInfo += '<tr><td colspan="2">' + visitor.question + '</td></tr></table><br />';
        visitorInfo += '<b class="maintext">Referrer Information</b><br />';
        visitorInfo += '<table border="0" cellpadding="2" cellspacing="0" style="margin-left: 20px; margin-top: 5px;">';
        visitorInfo += '<tr><td><b>Name: </b></td><td>' + visitor.referer_host + '</td></tr>';
        visitorInfo += '<tr><td><b>Search Query: </b></td><td>' + visitor.search_query + '</td></tr>';
        visitorInfo += '<tr><td><b>Website: </b></td><td>' + visitor.referer_url + '</td></tr>';
        visitorInfo += '<tr><b>Search Engine: </b></td><td>' + visitor.search_engine + '</td></tr></table>';
        //salesInfoContent += '<tr><td colspan="2"><img src="' + response.searchEngineImg + '" width="80" height="32"></td></tr></table>';

        visitorInfo += '<p><b class="maintext">System Information</b></p>';
        visitorInfo += '<table border="0" cellpadding="2" cellspacing="0" style="margin-left: 20px; margin-top: 5px;">';
        visitorInfo += '<tr><td><b>IP Address: </b></td><td >' + visitor.remote_addr + '</td></tr>';
        visitorInfo += '<tr><td><b>Screen Resolution: </b></td><td >' + visitor.screen_resolution + '</td></tr>';
        visitorInfo += '<tr><td><b>Browser: </b></td><td><table border="0" cellpadding="0" cellspacing="0"><tr>';
        visitorInfo += '<td>' + visitor.browser_name + '</td><td><img src="' + visitor.browserImg + '" height="16px" width="16px" hspace="3px"></td></tr></table></td></tr>';
        visitorInfo += '<tr><td><b>Browser Version: </b></td><td><table border="0" cellpadding="0" cellspacing="0"><tr>';
        visitorInfo += '<td>' + visitor.browser_version + '</td></tr></table></td></tr>';
        visitorInfo += '<tr><td><b>Operating System: </b></td><td><table border="0" cellpadding="0" cellspacing="0"><tr>';
        visitorInfo += '<td>' + visitor.operating_system + '</td><td><img src="' + visitor.osImg + '" height="16px" width="16px" hspace="3px"></td></tr></table></td></tr></table>';

        $('#visitorInfo').html(visitorInfo);
      }
    });
  }

  function startChat( visitor ) {

    ProvideChat.activeChatId = visitor.chat_id;

    console.log("START CHAT: " + visitor);
    //soundManager.stop('ringing');

    //clearInterval(soundTimer);
    //soundTimer = null;

    acceptChatOff();
    endChatOn(visitor.chat_id);

    var msg = 'Chat has begun, click end chat button when done';
    var title = 'Chat Initiated';
    //displayMessage(title, msg);

    var json_data = { "method": 'accept_chat', "chat_id": visitor.chat_id, "agent_id": ProvideChat.agent_id, "visitor_id": visitor.id };

    $.getJSON("/api/chat_monitor.json", json_data, function (response) {
      if (response.chat_id > 0) {
        add_new_tab (response.chat_id, response.visitor_id, response.visitor_name, 'inProgress');
      }
    });
  }


  function add_new_tab(chat_id, visitor_id, visitor_name, status) {
    //e.preventDefault();

    var tabNum = ProvideChat.numChats;
    ProvideChat.numChats++;	// increment the number of chats

    var id = $(".nav-tabs").children().length; //think about it ;)
    var tabId = 'chat_' + id;
    console.log(tabId);
    console.log(visitor_name);
    $('.tab-content').append('<div class="tab-pane" id="' + tabId + '"><%= escape_javascript render "chat" %></div>');
    $('.nav-tabs').append('<li><a data-toggle="tab" href="#chat_' + id + '">' + visitor_name + '</a></li>');

    // add this
    $('.nav-tabs li:nth-child(' + id + ') a').click();

    if (ProvideChat.numChats == 1) {
      $("#no-active-chat").slideUp();
      $('#active-chat-tabs').show();
      $('#tabs').tab('show');
    }
    $('#tabs a:last').tab('show');

    ProvideChat.activeChats[tabNum] = chat_id;
    ProvideChat.tabVisitorIds[tabNum] = visitor_id;

    ProvideChat.tabChatIds[chat_id] = tabNum;
    ProvideChat.chatStatus[chat_id] = status;

    //getChatText( chatId, true );

    ProvideChat.activeChatId = chat_id;

    //ProvideChat.chatTimer[chat_id] = setInterval(function(){ getChatText(chat_id,false); }, 2000);

    //ProvideChat.keypressStatusTimer[chat_id] = setInterval(function () { getKeypressStatus(chat_id); }, 1500);
  }

  function add_chat_tab (chatId, visitor_id, visitor_name, status)
  {
    var tabNum = ProvideChat.numChats;
    ProvideChat.numChats++;	// increment the number of chats

    if (ProvideChat.numChats == 1) {
      $("#initialChat").hide();
    }

    //var addTabSuccess = $("#tabs").tabs('add', 'chat_tab.php?chat_id=' + chatId, visitor_name, tabNum);
    var addTabSuccess = $("#tabs").tabs('add', '<%= escape_javascript render "chat" %>', visitor_name, tabNum);
    $("#tabs").tabs('select', tabNum);

    ProvideChat.activeChats[tabNum] = chatId;
    ProvideChat.tabVisitorIds[tabNum] = visitor_id;

    ProvideChat.tabChatIds[chatId] = tabNum;
    ProvideChat.chatStatus[chatId] = status;

    getChatText( chatId, true );

    ProvideChat.activeChatId = chatId;

    ProvideChat.chatTimer[chatId] = setInterval(function(){ getChatText(chatId,false); }, 2000);

    ProvideChat.keypressStatusTimer[chatId] = setInterval(function () { getKeypressStatus(chatId); }, 1500);
  }

  //Add a message to the chat server.
  function sendChatText(chatId) {

    if (chatStatus[chatId] === 'inProgress') {
      var message = urlencode($("#txt_message" + chatId).val()),
          operatorDispName = urlencode($("#operator_disp_name").val());

      if ((message.length === 0) || (message === "%0A") || (message === "%0A%0D")) {
        $('#txt_message' + chatId).val('');
        $('#txt_message' + chatId).focus();
      } else {

        var msg_text = $('#txt_message' + chatId).val();
        var operator_name = $("#operator_disp_name").val();

        msg_text = msg_text.replace(/\r?\n|\r/g, "<br>");

        var chatText = '<table border="0" cellpadding="10" cellspacing="0" width="100%">';
        chatText += '<tr><td class="maintext"><b>' + operator_name + ':</b><br />';
        chatText += '<div class="response">' + msg_text + '</div></td></tr></table>';

        $("#chatWindow"+chatId).append(chatText);
        $("#chatWindow"+chatId).animate({scrollTop: $("#chatWindow"+chatId)[0].scrollHeight}, 0);

        $('#txt_message' + chatId).val('');
        $('#txt_message' + chatId).focus();

        var json_data = { "method": 'insert_message', "chat_id": visitor.chat_id, "msg_sender": "operator",
                          "msg_type": "in_chat", "message": urlencode(message), "name": urlencode(operatorDispName) };


        $.ajax({
          type: "PUT",
          contentType: "application/json; charset=utf-8",
          url: "/api/chat_monitor.json/#{current_agent.id}",
          dataType: "json",
          data: JSON.stringify(json_data)
        });

      }
    } else if (chatStatus[chatId] === 'notStarted') {
      alert ("You must accept a chat before sending a message");
    } else if ((chatStatus[chatId] === 'operatorEnded') || (chatStatus[chatId] === 'visitorEnded') ||
              (chatStatus[chatId] === 'operatorTimeout') || (chatStatus[chatId] === 'operatorTimeout'))
    {
      alert ("This chat has now ended");
    }
  }

  //Gets the current messages from the server
  function getChatText( chatId, getAllMessages ) {

    var String = "action=get_unseen_messages&chatId=" + urlencode(chatId) + "&sender=operator";

    if (getAllMessages === true) {
      dataString = "action=get_chat&chatId=" + urlencode(chatId) + "&lastMessageId=0&sender=operator";
    }

    /*
    $.getJSON("/api/chat_monitor.json", json_data, function (response) {
      if (response.chat_id > 0) {
        add_chat_tab (response.chat_id, response.visitor_id, response.visitor_name, 'inProgress');
      }
    });
    */
    $.ajax({
      type: "POST",
      dataType: "json",
      url: "process-chat.php",
      data: dataString,
      success: function (response) {
        if (response.status.length > 0) {

          var chatText = '';
          var endChat = false;
          var newMessageAlert = false;

    			// if we get some JSON messages returned then process and display them, otherwise
    			// show the operator connection message

          chatStatus[chatId] = response.status;

    			// A status of 1 means the chat is now accepted
          if (response.status === 'notStarted') {

            chatText = '<table border="0" cellpadding="10" cellspacing="0"><tr><td class="maintext">';
            chatText += '<b>' + response.visitorName + ':</b><br /><div class="question">' + response.visitorQuestion + '</div><br>';
            chatText += '<table border="0" cellpadding="0" cellspacing="0" width="100%" class="message"><tr>';
            chatText += '<td valign="top" style="padding-right: 5px;"><img src="images/comments.gif" alt="" width="16" height="16"></td>';
            chatText += '<td class="maintext">This chat has not started yet</td>';
            chatText += '</tr></table><br /></td></tr></table>';

    				//lastMessageId[chatId] = response.message[0].id;

            $("#chatWindow"+chatId).html(chatText);

    			// A status of 2 means the chat is active
        } else if ((response.status === 'inProgress') || (response.status === 'operatorEnded') ||
                  (response.status === 'visitorEnded') || (response.status === 'visitorTimeout'))
        {
          for (var msgCount=0; msgCount < response.message.length; msgCount++) {

            var msg_id = response.message[msgCount].id;
            var msg_type = response.message[msgCount].type;
            var msg_sender = response.message[msgCount].sender;
            var msg_text = response.message[msgCount].text;
            var msg_user = response.message[msgCount].user;

            // A message type of  is an operator message
            if (msg_type === 'startChat') {

                chatText = '<table border="0" cellpadding="10" cellspacing="0" width="100%"><tr><td class="maintext">';
                chatText += '<b>' + response.visitorName + ':</b><br /><div class="question">' + response.visitorQuestion + '</div><br>';
                chatText += '<table border="0" cellpadding="0" cellspacing="0" width="100%" class="message"><tr>';
                chatText += '<td valign="top" style="padding-right: 5px;"><img src="images/comments.gif" alt="" width="16" height="16"></td>';
                chatText += '<td class="maintext">' + msg_text + '</td>';
                chatText += '</tr></table><br /></td></tr></table>';

                if (activeChatId == chatId) {
                  // Set the focus to the Message Box.
                  $('#txt_message'+activeChatId).focus();
                }

                $.shiftdown = false;
                $.ctrldown = false;

                $("#txt_message"+chatId).keydown(function (e) {
                  if (e.which === 16) {
                    $.shiftdown = true;
                  }
                  if ((e.which === 17)) {
                    $.ctrldown = true;
                  }
                });

                $("#txt_message"+chatId).keyup(function (e) {
                  if (e.which === 16) {
                    $.shiftdown = false;
                  }
                  if ((e.which === 17)) {
                    $.ctrldown = false;
                  }

                  if ((e.which === 13) && (($.shiftdown === true) || ($.ctrldown === true))) {
                    $("#txt_message"+chatId).value += "\n";
                  }
                  else if (e.which === 13) {
                    sendChatText( chatId );
                    updateKeypress(chatId, 'no');
                  } else {
                    updateKeypress(chatId, 'yes');
                  }
                });
              }
              else if (msg_type === 'inChat') {

                if (msg_sender === 'operator')
                {
                  chatText = '<table border="0" cellpadding="10" cellspacing="0" width="100%">';
                  chatText += '<tr><td class="maintext"><b>' + msg_user + ':</b><br />';
                  chatText += '<div class="response">' + msg_text + '</div></td></tr></table>';
                }
                else if (msg_sender === "visitor")
                {
                  chatText = '<table border="0" cellpadding="10" cellspacing="0" width="100%">';
                  chatText += '<tr><td class="maintext"><b>' + msg_user + ':</b><br />';
                  chatText += '<div class="question">' + msg_text + '</div></td></tr></table>';

                  $('#typingNotification' + chatId).html ('');

                  newMessageAlert = true;
                }
              }
              else if (msg_type === 'endChat')
              {
                chatText = '<br /><table border="0" cellpadding="10	" cellspacing="0" width="100%" class="message">';
                chatText += '<tr><td valign="top" style="padding-right: 5px;">';
                chatText += '<img src="images/comments_delete.gif" alt="" width="16" height="16"></td>';
                chatText += '<td class="maintext">' + msg_text + '<br /><br />';
                chatText += '<b>Chat Statistics:</b><br />';
                chatText += 'Chat session started: ' + response.started + '<br />';
                chatText += 'Chat Session ended: ' + response.ended + '<br />';
                chatText += 'Total chat session duration: ' + response.duration + '</td></tr></table><br />';

                endChat = true;

                endChatOff();
              }

              if (msg_type === 'startChat') {
                $("#chatWindow"+chatId).html(chatText);
              } else if ((msg_type === 'inChat') || (msg_type === 'endChat')) {
                $("#chatWindow"+chatId).append(chatText);
                $('#chatWindow'+chatId).scrollTop($('#chatWindow'+chatId).height())
                //$("#chatWindow"+chatId).animate({scrollTop: $("#chatWindow"+chatId)[0].scrollHeight}, 0);
              }
            }
          }

          if (endChat === true) {
    			  // Refresh chat in 2 seconds
            //chatTimer[chatId] = setTimeout(function(){ getChatText(chatId, false); }, 2000);
            clearInterval(chatTimer[chatId]);
            chatTimer[chatId] = null;
            clearTimeout(keypressStatusTimer[chatId]);
            keypressStatusTimer[chatId] = null;
            $('#typingNotification' + chatId).html ('');
          }
        }

        if ((newMessageAlert === true) && (chatStatus[chatId] === 'inProgress')) {
          if (activeChatId != chatId)  {
            var msg = 'New Message from ' + msg_user;
            var title = 'New Message';
            displayMessage(title, msg);

  					// Play new message sound for background chat
            if ($("#background_chat_sound").attr("checked") === true) {
              soundManager.play('new_message2');
            }
          } else {

  					// Play new message sound for background chat
            if ($("#active_chat_sound").attr("checked") === true) {
              soundManager.play('new_message1');
            }
          }
        }
      }
    });
  }


})(window.ProvideChat = window.ProvideChat || {}, jQuery);