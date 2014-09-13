var activeVisitorId = 0;	// the visitor_id for the currently active visitor
var activeVisitorBgColor = '';
var activeChatId = 0;	// the chat id of the currently active tab
var activeChats = [];	// associate array linking tab# to chatId - activeChats[tab#] = chatId

var tabChatIds = [];	// associate array linking chatId to tab# - tabChatIds[chatId] = tab#
var tabVisitorIds = [];	// associate array linking visitorId to tab# - tabVisitorIds[tab#] = visitorId
var chatStatus = [];	// associate array holding the status of all active chats - chatStatus[chatId] = status
//var lastMessageId = [];	// associate array tracking the lastMessageId for each active chat - lastMessageId[chatId] = lastMessageId

var operatorId = 0;

var chatTimer = [];	// array of timers for each active chat - chatTimer[chatId]
var keypressStatusTimer = [];	// array of timers for getting the keypress status of each active chat: keypressStatusTimer[chatId]
var keypressMsgTimer = [];		// array of timers for monitoring the keypress state for the operator: keypressMsgTimer[chatId]
var keypressStatus = [];		// array of keypress statuses for each active chat: keypressStatus[chatId]
//var keypressTimer = []; // array of keypress timers for each active chat - keypressTimer[chatId]
var visitorTimer;	// timer that controls the visitor info updates
var soundTimer;		// timer that controls looping sound effects

// the number of Visitors in total
var numVisitors = 0;
// the number of Visitors waiting to chat
var numWaiting = 0;
// the number of active chats
var numChats = 0;

function setOperatorId(newOperatorId) {
	operatorId = newOperatorId;
}

function purge(d) {

  if (typeof (d.attributes) !== 'undefined')  {

    var a = d.attributes, i, l, n;

    if (a) {
      for (i=0, l=a.length; i<l; i++) {
        n = a[i].name;

        if (typeof d[n] === 'function') {
          d[n] = null;
        }
      }
    }

    a = d.childNodes;

    if (a) {
      for (i=0, l=a.length; i<l; i++) {
        purge(d.childNodes[i]);
      }
    }
  }
}

function displayMessage(header, message)
{
  if (message.length > 0) {
    $.jGrowl(
      message,
      {
        header: header,
        position: 'bottom-right',
        theme: 'smoke',
        life: 20000
      }
    );
  }
}

function urlencode(str) {
	var ret = str;

  if (ret.length > 0) {
		ret = ret.toString();
		ret = encodeURIComponent(ret);
		ret = ret.replace(/%20/g, '+');
	}

	return ret;
}

/*
 *	Disable the End Chat button
 */
function endChatOff()
{
	$("#end_chat_img")
		.attr("src", "images/end_chat_off.gif")
		.unbind();

	$("#end_chat").unbind();
}

/*
 * Disable the Accept chat button
 */
function acceptChatOff()
{
	$("#accept_chat_img")
		.attr("src", "images/accept_chat_off.gif")
		.unbind();

	$("#accept_chat").unbind();
}


/*
 * Disable the Invite chat button
 */
function inviteChatOff()
{
	$("#invite_chat_img")
		.attr("src", "images/invite_chat_off.gif")
		.unbind();

	$("#invite_chat").unbind();
}

/*
 * Invite a specific visitor to chat
 */
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
        data: "visitorId=" + urlencode(visitor_id) + "&operatorId=" + urlencode(operatorId) + "&action=send_invite",
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


/*
 * Enable the Invite chat button
 */
function inviteChatOn(visitor_id)
{
	$("#invite_chat_img")
		.attr("src", "images/invite_chat_on.gif")
		.mouseover(function () {
			$(this).attr("src", "images/invite_chat_on_hover.gif");
		})
		.mouseout(function () {
			$(this).attr("src", "images/invite_chat_on.gif");
	});

	$("#invite_chat").unbind();
	$("#invite_chat").click(function () {
		inviteVisitor(visitor_id);
	});
}

/*
 * This function ends a currently active chat session
 */
function endActiveChat(chatId) {

  $.ajax({
		type: "POST",
		dataType: "json",
		url: "process-chat.php",
		data: "action=end&chatId=" + urlencode(chatId)
  });

	endChatOff();
}

/*
 * Enable the End Chat button
 */
function endChatOn(chat_id)
{
	$("#end_chat_img")
		.attr("src", "images/end_chat_on.gif")
		.mouseover(function () {
			$(this).attr("src", "images/end_chat_on_hover.gif");
		})
		.mouseout(function () {
			$(this).attr("src", "images/end_chat_on.gif");
	});

	$("#end_chat").unbind();
	$("#end_chat").click(function () {
		endActiveChat(chat_id);
	});
}


function make_keyDown(e) {
	return function (e) {
    if (e.which === 16) {
      $.shiftdown = true;
    }
    if ((e.which === 17)) {
      $.ctrldown = true;
    }
  };
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

      $.ajax({
        type: "POST",
        dataType: "json",
        url: "process-chat.php",
        data: "action=insert&message=" + urlencode(message) + "&chatId=" + urlencode(chatId) + "&name=" + urlencode(operatorDispName) + "&msg_sender=operator&msg_type=inChat"
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

function updateKeypress(chatId, keypressActive) {

	if (keypressStatus[chatId] === keypressActive) {

		if (typeof keypressMsgTimer[chatId] != 'undefined') {
			clearTimeout(keypressMsgTimer[chatId]);
			keypressMsgTimer[chatId] = null;
		}
		keypressMsgTimer[chatId] = setTimeout(function () { updateKeypress(chatId, 'no'); }, 3000); // reset the keypress in 5 seconds

	} else {

		keypressStatus[chatId] = keypressActive;

    $.ajax({
			type: "POST",
			dataType: "json",
			url: "process-chat.php",
			data: "action=update_keypress&user=operator&chatId=" + urlencode(chatId) + "&keypressActive=" + urlencode(keypressActive),
			success: function (json) {
				clearTimeout(keypressMsgTimer[chatId]);
				keypressMsgTimer[chatId] = null;
				keypressMsgTimer[chatId] = setTimeout(function () { updateKeypress(chatId, 'no'); }, 3000); // reset the keypress in 5 seconds

        result = null;
			}
    });
	}
}

function make_keyUp (e, chatId) {
  return function (e) {
    if (e.which == 16) {
      $.shiftdown = false;
    }
    if ((e.which == 17)) {
      $.ctrldown = false;
    }

    if ((e.which === 13) && (($.shiftdown === true) || ($.ctrldown === true))) {
      $("#txt_message"+chatId).value += "\n";
    }
    else if (e.which == 13) {
      sendChatText( chatId );
      updateKeypress(chatId, 'no');
    } else {
      updateKeypress(chatId, 'yes');
    }

    e = null;
  };
}

//Gets the current messages from the server
function getChatText( chatId, getAllMessages ) {

	var String = "action=get_unseen_messages&chatId=" + urlencode(chatId) + "&sender=operator";

	if (getAllMessages === true) {
		dataString = "action=get_chat&chatId=" + urlencode(chatId) + "&lastMessageId=0&sender=operator";
	}

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

function getKeypressStatus(chatId) {

  $.ajax({
    type: "POST",
    dataType: "json",
    url: "process-chat.php",
    data: "action=get_keypress_status&chatId=" + urlencode(chatId),
		success: function (keypress_status) {

      var chat_id = keypress_status.chat_id;

      if (keypress_status.visitor_typing == 'yes' ) {
        $('#typingNotification' + chat_id).html ('<i>' + keypress_status.visitor_name + ' is typing...</i>');
      } else {
        $('#typingNotification' + chat_id).html ('');
      }
    }
  });
}

function addChatTab (chatId, visitor_id, visitor_name, status)
{
	var tabNum = numChats;
	numChats++;	// increment the number of chats

	if (numChats == 1) {
		$("#initialChat").hide();
	}

  var addTabSuccess = $("#tabs").tabs('add', 'chat_tab.php?chat_id=' + chatId, visitor_name, tabNum);
	$("#tabs").tabs('select', tabNum);

	activeChats[tabNum] = chatId;
	tabVisitorIds[tabNum] = visitor_id;

	tabChatIds[chatId] = tabNum;
	chatStatus[chatId] = status;

	getChatText( chatId, true );

	activeChatId = chatId;

  chatTimer[chatId] = setInterval(function(){ getChatText(chatId,false); }, 2000);

  keypressStatusTimer[chatId] = setInterval(function () { getKeypressStatus(chatId); }, 1500);
}

function getVisitorRowColor (chatStatus, visitorStatus)
{
	if (((chatStatus == 'operatorEnded') || (chatStatus == 'visitorEnded') || (chatStatus == 'visitorTimeout') || (chatStatus == 'operatorTimeout')) && (visitorStatus == 'doneChat')) {
		tr_hoverColor = "#FFF298";
		tr_bgcolor = "#EEEEEE";
		tr_style = "background-color: #EEEEEE; border-style: solid; border-color: #BBBBBB; border-width: 2px 1px 2px 1px; font-weight: bold;";
	}
	else if ((chatStatus == 'inProgress') && (visitorStatus == 'inChat')) {
		tr_hoverColor = "#FFF298";
		tr_bgcolor = "#E9EFF8";
		tr_style = "background-color: #E9EFF8; border-style: solid; border-color: #BBBBBB; border-width: 2px 1px 2px 1px; font-weight: bold;";
  }
	else if (visitorStatus == 'waitingToChat') {
		tr_hoverColor = "#FFF298";
		tr_bgcolor = "#E6F3CD";
		tr_style = "background-color: #E6F3CD; border-style: solid; border-color: #BBBBBB; border-width: 2px 1px 2px 1px; font-weight: bold;";
  }
	else if (visitorStatus == 'noChat') {
		tr_hoverColor = "#FFF298";
		tr_bgcolor = "#F9F7ED";
		tr_style = "background-color: #F9F7ED; border-style: solid; border-color: #BBBBBB; border-width: 2px 1px 2px 1px; font-weight: bold;";
  }

	var visitorRow = {
		hoverColor: '#fff', //tr_hoverColor,
		bgcolor: '#E9EFF8', //tr_bgcolor,
		style: "background-color: #F9F7ED; border-style: solid; border-color: #BBBBBB; border-width: 2px 1px 2px 1px; font-weight: bold;" //tr_style
	};

	return visitorRow;
}

/*********************************
 * Update the Visitor Details    *
 * and Tech Info DIVs            *
 *********************************/

//Gets the details for a specific visitor from the server
function getVisitorDetail( visitor_id ) {

  $.ajax({
		type: "POST",
		dataType: "json",
		url: "lookup-visitors.php",
		data: "action=get_visitor_detail&visitor_id=" + visitor_id,
		success: function (response) {

      log (response);

			var salesInfoContent = '';
			var techInfoContent = '';

			if (response.visitorName != 'Not found')
			{
				salesInfoContent += '<p><b class="maintext">Visitor Information</b></p>';
				salesInfoContent += '<table border="0" cellpadding="2" cellspacing="0" style="margin-left: 20px; margin-top: 5px;">';
				salesInfoContent += '<tr><td><b>Name: </b></td><td>' + response.visitorName + '</td></tr>';
				salesInfoContent += '<tr><td><b>Email: </b></td><td>' + response.visitorEmail + '</td></tr>';
				salesInfoContent += '<tr><td><b>Department: </b></td><td>' + response.department + '</td></tr>';
				salesInfoContent += '<tr><td><b>Pages Viewed: </b></td><td>' + response.pageViews + '</td></tr>';
				salesInfoContent += '<tr><td><b>Time on Site: </b></td><td>' + response.timeDiff + '</td></tr>';
				salesInfoContent += '<tr><td><b>Country: </b></td><td>' + response.country + '&nbsp;&nbsp;<img width="32" height="16" src="http://api.hostip.info/flag.php?ip=' + response.remoteAddr + '"></td></tr>';
				salesInfoContent += '<tr><td><b>Current Page: </b></td><td><a href="' + response.currentPage + '" target="_blank" style="color: #0066CC;">' + response.currentPage + '</a></td></tr>';
				salesInfoContent += '<tr><td colspan="2"><br><b>Initial Question: </b></td></tr>';
				salesInfoContent += '<tr><td colspan="2">' + response.visitorQuestion + '</td></tr></table><br />';
				salesInfoContent += '<b class="maintext">Referrer Information</b><br />';
				salesInfoContent += '<table border="0" cellpadding="2" cellspacing="0" style="margin-left: 20px; margin-top: 5px;">';
				salesInfoContent += '<tr><td><b>Name: </b></td><td>' + response.refererSource + '</td></tr>';
				salesInfoContent += '<tr><td><b>Search Query: </b></td><td>' + response.refererQuery + '</td></tr>';
				salesInfoContent += '<tr><td><b>Website: </b></td><td>' + response.refererUrl + '</td></tr>';
				salesInfoContent += '<tr><td colspan="2"><img src="' + response.searchEngineImg + '" width="80" height="32"></td></tr></table>';

				techInfoContent += '<p><b class="maintext">System Information</b></p>';
				techInfoContent += '<table border="0" cellpadding="2" cellspacing="0" style="margin-left: 20px; margin-top: 5px;">';
				techInfoContent += '<tr><td><b>IP Address: </b></td><td >' + response.remoteAddr + '</td></tr>';
				techInfoContent += '<tr><td><b>Screen Resolution: </b></td><td >' + response.screenResolution + '</td></tr>';
				techInfoContent += '<tr><td><b>Browser: </b></td><td><table border="0" cellpadding="0" cellspacing="0"><tr>';
				techInfoContent += '<td>' + response.browserName + '</td><td><img src="' + response.browserImg + '" height="16px" width="16px" hspace="3px"></td></tr></table></td></tr>';
				techInfoContent += '<tr><td><b>Browser Version: </b></td><td><table border="0" cellpadding="0" cellspacing="0"><tr>';
				techInfoContent += '<td>' + response.browserVersion + '</td></tr></table></td></tr>';
				techInfoContent += '<tr><td><b>Operating System: </b></td><td><table border="0" cellpadding="0" cellspacing="0"><tr>';
				techInfoContent += '<td>' + response.osName + '</td><td><img src="' + response.osImg + '" height="16px" width="16px" hspace="3px"></td></tr></table></td></tr></table>';

				$('#salesInfoDiv').html(salesInfoContent);
				$('#techInfoDiv').html(techInfoContent);
			}
    }
  });
}

/*
    SELECT VISITOR
	Called when a visitor row is clicked on in the visitor table.
    Chat details are then shown in the "div_chat" <div> for either site visitors
    or visitors waiting to chat
*/
function selectVisitor( visitor_id )
{
	/*
	$('#item').data(key, value);
	$.data('#item', key, value);
	*/

	var chat_id = $("#visitorRow" + visitor_id).data("visitorInfo").chatId;
	var status = $("#visitorRow" + visitor_id).data("visitorInfo").cStatus;
	var visitor_name = $("#visitorRow" + visitor_id).data("visitorInfo").name;

	if ((activeVisitorId > 0) && (activeVisitorBgColor.length > 0)) {

		$("#visitorRow" + activeVisitorId).css('background-color', activeVisitorBgColor);
		$("#visitorRow" + activeVisitorId).mouseover(function () {
			visitorId = $(this).attr("id").substr(10);
			visitorId = parseInt(visitorId, 10);

			cStatus = $("#visitorRow" + visitorId).data("visitorInfo").cStatus;
			vStatus = $("#visitorRow" + visitorId).data("visitorInfo").vStatus;

			var visitorRowDetail = getVisitorRowColor(cStatus, vStatus);

			$(this).css('background-color', visitorRowDetail.hoverColor);

			cStatus = null;
			vStatus = null;
			visitorRowDetail = null;
		});
		$("#visitorRow" + activeVisitorId).mouseout(function () {
			visitorId = $(this).attr("id").substr(10);
			visitorId = parseInt(visitorId, 10);

			cStatus = $("#visitorRow" + visitorId).data("visitorInfo").cStatus;
			vStatus = $("#visitorRow" + visitorId).data("visitorInfo").vStatus;

			var visitorRowDetail = getVisitorRowColor(cStatus, vStatus);

			$(this).css('background-color', visitorRowDetail.bgcolor);

			cStatus = null;
			vStatus = null;
			visitorRowDetail = null;
		});
	}

	activeVisitorId	= visitor_id;

	//alert ("ChatID: " + chat_id + ", status: " + status);

	// this is an active chat ?
  if ((chat_id > 0) && (status != 'notStarted')) {
    $("#tabs").tabs('enable');

    if (typeof tabChatIds[chat_id] != 'undefined') {
      //alert ('Selecting TabNum: ' + tabChatIds[chat_id] + ' for ChatID: ' + chat_id);
      $("#tabs").tabs('select', (tabChatIds[chat_id]));
    } else {
      //alert ('Adding Tab for ChatID: ' + chat_id);
      addChatTab (chat_id, visitor_id, visitor_name, status);
    }
  } else {
    $("#tabs").tabs('disable');
  }

  if (visitor_name.length > 0) {
    $("#selectedVisitor").html("<b>Active Visitor: " + visitor_name + "</b>");
  } else {
    $("#selectedVisitor").html("<b>Active Visitor: unknown visitor</b>");
    inviteChatOn ( visitor_id );

    var msg = 'Click the invite button to invite the selected visitor to chat';
    var title = 'Invite Visitor to Chat';
    displayMessage(title, msg);
  }

  getVisitorDetail( visitor_id );
}

/**
 *  CHAT FUNCTIONS
 *
 *  The following Javascript functions perform the actual chatting
 *  between an operator and a site visitor
 */

function startChat( visitor_id, chat_id ) {

	activeChatId = chat_id;

	soundManager.stop('ringing');

	clearInterval(soundTimer);
	soundTimer = null;

	acceptChatOff();
	endChatOn(chat_id);

	var msg = 'Chat has begun, click end chat button when done';
	var title = 'Chat Initiated';
	displayMessage(title, msg);

    $.ajax({
		type: "POST",
		dataType: "json",
		url: "process-chat.php",
		data: "action=new&chatId=" + activeChatId + "&visitorId=" + visitor_id + "&operatorId=" + operatorId,
		success: function (response) {
			if (response.chat_id > 0) {
				addChatTab (response.chat_id, response.visitor_id, response.visitor_name, 'inProgress');
			}
		}
	});
}

/*
 * Enable the Accept chat button
 */
function acceptChatOn ( visitor_id )
{
	var chat_id = $("#visitorRow" + visitor_id).data("visitorInfo").chatId;

	endChatOff();
	$("#accept_chat_img")
		.attr("src", "images/accept_chat_on.gif")
		.mouseover(function () {
			$(this).attr("src", "images/accept_chat_on_hover.gif");
		})
		.mouseout(function () {
			$(this).attr("src", "images/accept_chat_on.gif");
		});

	$("#accept_chat").unbind();
	$("#accept_chat").click(function () {
		startChat(visitor_id, chat_id);
	});

	var msg = 'Click the accept button to start chat';
	var title = 'Ready to Chat';
	displayMessage(title, msg);
}

function rapidResponse ( text ) {

	if (activeChatId > 0) {
		$("#txt_message" + activeChatId).val(text);
	} else {
		alert ("No active chat");
	}
}

/*********************************
 * Update the Visitor DIV Table  *
 *********************************/

function clearVisitors () {

	var org_id = $("#organization_id").val();

    $.ajax({
		type: "POST",
		dataType: "json",
		url: "lookup-visitors.php",
		data: "action=clear_visitors&organization_id=" + org_id,
		success: function (result) {
      setTimeout(function(){clearVisitors();}, 60000);
		}
	});
}

function make_visitorRowMouseOver () {
  return function () {
		visitorId = $(this).attr("id").substr(10);
		visitorId = parseInt(visitorId, 10);

		cStatus = $("#visitorRow" + visitorId).data("visitorInfo").cStatus;
		vStatus = $("#visitorRow" + visitorId).data("visitorInfo").vStatus;

		var visitorRowDetail = getVisitorRowColor(cStatus, vStatus);

		if (visitorId != activeVisitorId) {
      $("#visitorRow" + visitorId).css('background-color', visitorRowDetail.hoverColor);
      $("#visitorRow" + visitorId).css('cursor', 'pointer');
    }

    cStatus = null;
    vStatus = null;
    visitorRowDetail = null;
  };
}

function make_visitorRowMouseOut () {
  return function () {
		visitorId = $(this).attr("id").substr(10);
		visitorId = parseInt(visitorId, 10);

		cStatus = $("#visitorRow" + visitorId).data("visitorInfo").cStatus;
		vStatus = $("#visitorRow" + visitorId).data("visitorInfo").vStatus;

		var visitorRowDetail = getVisitorRowColor(cStatus, vStatus);

		if (visitorId != activeVisitorId) {
      $("#visitorRow" + visitorId).css('background-color', visitorRowDetail.bgcolor);
      $("#visitorRow" + visitorId).css('cursor', 'default');
    }

    cStatus = null;
    vStatus = null;
    visitorRowDetail = null;
  };
}

function make_visitorRowClick () {
  return function () {
    visitorId = $(this).attr("id").substr(10);
    visitorId = parseInt(visitorId, 10);

    cStatus = $("#visitorRow" + visitorId).data("visitorInfo").cStatus;
    vStatus = $("#visitorRow" + visitorId).data("visitorInfo").vStatus;

    if (((cStatus == 'operatorEnded') || (cStatus == 'visitorEnded') || (cStatus == 'visitorTimeout') || (cStatus == 'operatorTimeout')) && (vStatus == 'doneChat')) {
      selectVisitor(visitorId);
      endChatOff();
      acceptChatOff();
    }
    else if ((cStatus == 'inProgress') && (vStatus == 'inChat')) {
      selectVisitor(visitorId);
      var chatId = $("#visitorRow" + visitorId).data("visitorInfo").chatId;
      endChatOn(chatId);
    }
    else if (vStatus == 'waitingToChat') {
      selectVisitor(visitorId);
      acceptChatOn(visitorId);
    }
    else if (vStatus == 'noChat') {
      selectVisitor(visitorId);
      inviteChatOn(visitorId);
    }

    var visitorRowDetail = getVisitorRowColor(cStatus, vStatus);

    activeVisitorBgColor = visitorRowDetail.bgcolor;

    $("#visitorRow" + visitorId).unbind('mouseover');
    $("#visitorRow" + visitorId).unbind('mouseout');
    $("#visitorRow" + visitorId).css('background-color', '#FFF298');

    cStatus = null;
    vStatus = null;
    visitorRowDetail = null;
  };
}

function newChatAlert() {
	var msg = 'A Visitor is waiting to chat';
	var title = 'Notice';
	displayMessage(title, msg);

	self.focus();

	soundManager.play('ringing');
}


function updateVisitorTable (visitors)
{
  $("#loading_visitors").hide();

  // array of visitor ids
  var visitorArray = [],
      visitorRow = '';

  // If we have some visitors in the results, then process them
  if (typeof (visitors) !== 'undefined')
  {
    if (visitors.length > 0)
		{
			for (var visitorCount=0; visitorCount < visitors.length; visitorCount++) {
				var visitor_id = visitors[visitorCount].visitor_id,
					chat_id = visitors[visitorCount].chat_id,
					visitorStatus = visitors[visitorCount].visitorStatus,
					chatStatus = visitors[visitorCount].chatStatus,
					visitor_name = visitors[visitorCount].name,
					visitorName = '',
					chatStatus_extended = '',
					operatorStatus = '',
					visitorLocation = '',
					tr_onclick = '',
					tr_hoverColor = '',
					tr_bgColor = '',
					tr_style = '';

				// append the current visitor_id onto the visitorArray
				visitorArray.push(visitor_id);

				// VISITOR NAME
				if (visitor_name) {
          visitorName = visitor_name;
        } else {
          if (visitors[visitorCount].remote_host == 'Unknown Host') {
            visitorName = visitors[visitorCount].remote_addr;
          } else {
            visitorName = visitors[visitorCount].remote_host + " (" + visitors[visitorCount].remote_addr + ")";
          }
        }

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

    		// OPERATOR STATUS
        if ((chatStatus == 'visitorEnded') || (chatStatus == 'operatorEnded')) {
          operatorStatus =  "Finished chat";
        } else if (chatStatus == 'inProgress') {
          operatorStatus =  "Chatting with " + visitors[visitorCount].operator_disp_name;
        } else if ((chatStatus == 'notStarted') || (visitorStatus == 'waitingToChat')) {
          operatorStatus =  "Waiting to Chat";
        } else {
          operatorStatus =  "None";
        }

        // VISITOR LOCATION
        if (visitors[visitorCount].chatStatus == 'visitorTimeout') {
          visitorLocation =  "Visitor timed out, no longer on site";
        } else if (visitors[visitorCount].chatStatus == 'operatorTimeout') {
          visitorLocation =  "Chat not accepted, visitor sent to unavailable window";
        } else {
          if (visitors[visitorCount].current_page.length > 0) {
            visitorLocation =  visitors[visitorCount].current_page;
          }
          else {
            visitorLocation =  "Unknown";
          }
        }

        if ($("#noVisitorRow1").length != 0) {
          $("#noVisitorRow1").html('');
          $("#noVisitorRow1").remove();
          $("#noVisitorRow2").html('');
          $("#noVisitorRow2").remove();
        }

        visitorRow = getVisitorRowColor(chatStatus, visitorStatus);

  			// If the visitor row already exists in the table then update the table cells
        if ($("#visitorRow" + visitor_id).length != 0) {

          $("#visitorRow" + visitor_id).die();

          if ((visitor_id != activeVisitorId) || ($("#visitorOperator" + visitor_id).html() != operatorStatus)) {
            $("#visitorRow" + visitor_id).css('background-color', visitorRow.bgcolor);

            $("#visitorRow" + visitor_id).live ('mouseover', make_visitorRowMouseOver());
            $("#visitorRow" + visitor_id).live ('mouseout', make_visitorRowMouseOut());

          } else if (visitor_id == activeVisitorId) {
    			  //alert (activeVisitorId);
            activeVisitorBgColor = visitorRow.bgcolor;
    				//$("#visitorRow" + visitor_id).css('background-color', '#FFF298');
          }

          $("#visitorName" + visitor_id).html(visitorName);
          $("#visitorDept" + visitor_id).html(visitors[visitorCount].department);
          $("#visitorStatus" + visitor_id).html(chatStatus_extended);
          $("#visitorOperator" + visitor_id).html(operatorStatus);
          $("#visitorLocation" + visitor_id).html(visitorLocation);
        }
        else
        {
  				// the visitor row doesn't exist and so create a new row and then append onto the end of the table
          visitorRow = '<tr id="visitorRow' + visitor_id + '" style="' + visitorRow.style + '">';
          visitorRow += '<td id="visitorId' + visitor_id + '" style="border: 1px solid #BBBBBB; width: 16px;"  class="smalltext" align="center">' + (visitorCount + 1) + '</td>';
          visitorRow += '<td id="visitorName' + visitor_id + '" style="border: 1px solid #BBBBBB; width: 154px;" class="smalltext">' + visitorName + '</td>';
          visitorRow += '<td id="visitorDept' + visitor_id + '" style="border: 1px solid #BBBBBB; width: 90px;" class="smalltext">' + visitors[visitorCount].department + '</td>';
          visitorRow += '<td id="visitorStatus' + visitor_id + '" style="border: 1px solid #BBBBBB; width: 140px;" class="smalltext">' + chatStatus_extended + '</td>';
          visitorRow += '<td id="visitorOperator' + visitor_id + '" style="border: 1px solid #BBBBBB; width: 120px;" class="smalltext">' + operatorStatus + '</td>';
          visitorRow += '<td id="visitorLocation' + visitor_id + '" style="border: 1px solid #BBBBBB; width: 270px;" class="smalltext">' + visitorLocation + '</td>';
          visitorRow += '</tr>';

          $("#visitor-table").append(visitorRow);

          $("#visitorRow" + visitor_id).live ('mouseover', make_visitorRowMouseOver());
          $("#visitorRow" + visitor_id).live ('mouseout', make_visitorRowMouseOut());
        }

        var visitorInfo = {
          visitorId: visitor_id,
          chatId: chat_id,
          cStatus: chatStatus,
          vStatus: visitorStatus,
          name: visitorName
        };

        $("#visitorRow" + visitor_id).removeData("visitorInfo");
        $("#visitorRow" + visitor_id).data("visitorInfo", visitorInfo);
        $("#visitorRow" + visitor_id).live ('click', function() {
          visitorId = $(this).attr("id").substr(10);
          visitorId = parseInt(visitorId, 10);

          cStatus = $("#visitorRow" + visitorId).data("visitorInfo").cStatus;
          vStatus = $("#visitorRow" + visitorId).data("visitorInfo").vStatus;

          if (((cStatus == 'operatorEnded') || (cStatus == 'visitorEnded') || (cStatus == 'visitorTimeout') || (cStatus == 'operatorTimeout')) && (vStatus == 'doneChat')) {
            selectVisitor(visitorId);
            endChatOff();
            acceptChatOff();
          }
          else if ((cStatus == 'inProgress') && (vStatus == 'inChat')) {
            selectVisitor(visitorId);
            var chatId = $("#visitorRow" + visitorId).data("visitorInfo").chatId;
            endChatOn(chatId);
          }
          else if (vStatus == 'waitingToChat') {
            selectVisitor(visitorId);
            acceptChatOn(visitorId);
          }
          else if (vStatus == 'noChat') {
            selectVisitor(visitorId);
            inviteChatOn(visitorId);
          }

          var visitorRowDetail = getVisitorRowColor(cStatus, vStatus);

          activeVisitorBgColor = visitorRowDetail.bgcolor;

          $("#visitorRow" + visitorId).unbind('mouseover');
          $("#visitorRow" + visitorId).unbind('mouseout');
          $("#visitorRow" + visitorId).css('background-color', '#FFF298');

          //purge (document.getElementById('visitorRow' + visitorId));
        });
      }
    } else {

      $("#noVisitorRow1").html('');
      $("#noVisitorRow1").remove();
      $("#noVisitorRow2").html('');
      $("#noVisitorRow2").remove();

      if ($("#noVisitorRow1").length === 0) {
        visitorRow = '<tr id="noVisitorRow1" bgcolor="#FFFFFF"><td colspan="6">&nbsp;</td></tr>';
        visitorRow +=  '<tr id="noVisitorRow2" bgcolor="#FFFFFF"><td colspan="6" align="center" style="font-weight: bold;"  class="smalltext">';
        if ($('#websiteFilter option:selected').text() != 'All') {
          visitorRow +=  response.resultMsg + ' on ' + $('#websiteFilter option:selected').text();
        } else {
          visitorRow +=  response.resultMsg;
        }
        visitorRow += '</td></tr>';

        $("#visitor-table").append(visitorRow);
      }
    }

  	//
  	// REMOVE STALE VISITOR ROWS
  	// Remove any older visitors rows that were not part of the last response from the ajax call
  	//

		// loop through all the rows of the visitor table
		$("#visitor-table tr").each(function () {
			if ($(this).attr("id") != "headerRow") {
				// get the visitor id of the current row
				var visitorId = $(this).attr("id").substr(10);

				if (jQuery.inArray(visitorId, visitorArray) == -1) {
					// if the visitor id doesn't exist in the array of visitors then remove that row
          $("#visitorRow" + visitorId).unbind();
          $("#visitorRow" + visitorId).html('');

          if (document.getElementById('visitorRow' + visitorId)) {
            purge (document.getElementById('visitorRow' + visitorId));
          }
					$("#visitorRow" + visitorId).remove();
				}
			}
		});
	}
}

function updateVisitors () {
	var visitor_filter = $("#visitorFilter").val();
  var website_filter = $("#websiteFilter").val();
	var org_id = $("#organization_id").val();
	var op_id = $("#operator_id").val();

  var organization_id = $("#visitor-table").attr("data-id");
	/* Update Visitor Table
   *
   * This function calls the lookup-visitors.php script to get the current visitor table and then updates
   * the container div with the result
   */

    $.ajax({
    type: "GET",
    dataType: "json",
    url: "/visitors.json?organization_id=" + organization_id,
    data: "action=get_visitor_list&organization_id=" + org_id + "&operator_id=" + op_id + "&visitor_filter=" + visitor_filter + "&website_filter=" + website_filter + "&selected_visitor=" + activeVisitorId,
    success: function (json) {
      console.log(json)
      if (json) {
        updateVisitorTable(json);
      }
    }
  });


	/* Update Visitor Stats
   *
   * This function calls the lookup-visitors.php script to get the current visitor stats and then
   * updates the two appropriate divs with the results
   */

  $.ajax({
    type: "GET",
    dataType: "json",
    url: "/visitors.json?organization_id=" + organization_id,
    //url: "lookup-visitors.php",
    //data: "action=get_visitor_numbers&organization_id=" + org_id + "&operator_id=" + $("#operator_id").val(),
    success: function (response) {
      var visitorsOnline = $("#visitorsOnline");
      var waitingToChat = $("#waitingToChat");

      // Set the current contents of visitors & waiting divs to some variables
      var prevNumVisitors = parseInt(visitorsOnline.html(), 10);
      var prevNumWaiting = parseInt(waitingToChat.html(), 10);

      visitorsOnline.html(response.totalVisitors);
      waitingToChat.html(response.totalWaitingVisitors);

      // Check to see if the number of visitors has increased
      if (response.totalVisitors > prevNumVisitors) {
        var msg = 'New Visitor on the site ' + response.websiteName;
        var title = 'Notice';
        displayMessage(title, msg);

        if ($("#visitor_arrived_sound").attr("checked") === true) {
          soundManager.play('visitor_arrived');
        }
      } else if (response.totalVisitors === 0) {

        inviteChatOff();
        $("#selectedVisitor").html("");
      }

      // Check to see if the number of visitors waiting to chat has increased
      if ((response.totalWaitingVisitors > 0) && (response.totalWaitingVisitors > prevNumWaiting)) {
        soundTimer = setInterval(function(){ newChatAlert(); }, 10000);
        newChatAlert();
      } else if (response.totalWaitingVisitors == 0) {
        clearInterval(soundTimer);
        soundTimer = null;
        soundManager.stop('ringing');
        acceptChatOff();
      }
    }
  });

  // Refresh visitors in 1.5 seconds
	//visitorTimer = setTimeout(function(){updateVisitors();}, 2000);
}


function init (operatorId, max_chats) {
	//initjsDOMenu();
	clearVisitors();
	updateVisitors();
	setOperatorId(operatorId);
	maxChats = max_chats;

  visitorTimer = setInterval(function(){updateVisitors();}, 2500);
}

function closeChatTab (tabNum) {

	var deletedChatId = activeChats[tabNum];

	// turning this off for now until we can get the confirm dialog working
	// endActiveChat(deletedChatId);

	//alert ("removing tab for ChatID: " + deletedChatId);
	tabChatIds[deletedChatId] = undefined;
	chatStatus[deletedChatId] = undefined;
	//lastMessageId[deletedChatId] = undefined;
	/*
	tabChatIds.splice(deletedChatId, 1);
	chatStatus.splice(deletedChatId, 1);
	lastMessageId.splice(deletedChatId, 1);
	*/

	clearTimeout(chatTimer[deletedChatId]);
	chatTimer[deletedChatId] = null;

	clearTimeout(keypressStatusTimer[deletedChatId]);
	keypressStatusTimer[deletedChatId] = null;

	numChats--;

	if (numChats === 0) {
		$("#initialChat").show();
	}

	//alert ('numChats: ' + numChats + ', tabNum: ' + tabNum);

	if (numChats > tabNum) {
		for (var counter = tabNum; counter < numChats; counter++) {
			activeChats[counter] = activeChats[counter+1];
			tabVisitorIds[counter] = tabVisitorIds[counter+1];

			tabChatId = activeChats[counter+1];
			tabChatIds[tabChatId] = counter;

			//alert ('tabChatId: ' + tabChatId + ', tabChatIds[tabChatId] : ' + tabChatIds[tabChatId] + ', counter: ' + counter);
		}

		activeChats.splice(counter+1, 1);
		tabVisitorIds.splice(counter+1, 1);
	} else {
		activeChats.splice(tabNum, 1);
		tabVisitorIds.splice(tabNum, 1);
	}
}

$(document).ready(function () {

  $('#visitorFilter').change(function() {
    updateVisitors();
  });

  $('#websiteFilter').change(function() {
    updateVisitors();
  });


	/* Update Operator Status
   *
   * This function is triggered whenever the user updates their "Operator Status" select box
   */
	$("#operatorAvailability").change(function () {
    $.ajax({
			type: "POST",
			dataType: "json",
			url: "operator-actions.php",
			data: "action=update-availability&operator_id=" + $("#operator_id").val() + "&availability=" + $(this).val(),
			success: function (json) {

				var title = '';

				if (json.result) {
          title = 'Success';
				} else {
					title = 'Error';
				}

				displayMessage(title, json.message);
			}
    });
	});

	$("#close-button").click(function() {

		if ($("#operatorAvailability").val() == "online") {

      $.ajax({
				type: "POST",
				dataType: "json",
				url: "operator-actions.php",
				data: "action=update-availability&operator_id=" + $("#operator_id").val() + "&availability=offline",
        async: false
      });
    }

    self.close();
	});

	$("#audio-settings-dialog").dialog({
		autoOpen: false,
		height: 290,
		width: 400,
		modal: true,
		position: "center",
		resizable: false,
		buttons: {
			"Update Settings": function() {

				var activeChatSound = 'disabled';
				var backgroundChatSound = 'disabled';
				var visitorArrivedSound = 'disabled';

				if ($("#active_chat_sound").attr("checked") === true) {
					activeChatSound = 'enabled';
				}

				if ($("#background_chat_sound").attr("checked") === true) {
					backgroundChatSound = 'enabled';
				}

				if ($("#visitor_arrived_sound").attr("checked") === true) {
					visitorArrivedSound = 'enabled';
				}

        $.ajax({
					type: "POST",
					dataType: "json",
					url: "operator-actions.php",
					data: "action=update-settings&operator_id=" + $("#operator_id").val() +
							"&active_chat_sound=" + activeChatSound +
							"&background_chat_sound=" + backgroundChatSound +
							"&visitor_arrived_sound=" + visitorArrivedSound,
					success: function (json) {

						var title = '';

						if (json.result) {
							title = 'Success';
						} else {
							title = 'Error';
						}

						displayMessage(title, json.message);
					}
        });

				//$( this ).dialog( "close" );
			},
			Close: function() {
				$( this ).dialog( "close" );
			}
		},
		close: function() {
			//allFields.val( "" ).removeClass( "ui-state-error" );
		}
	});

	$("#config-audio").hover(function() {
			$(this).addClass('image-button-hover');
		}, function() {
			$(this).removeClass('image-button-hover');
		})
		.click(function() {
      $( "#audio-settings-dialog" ).dialog( "open" );
	});

	$("#logout-button").hover(function() {
    $(this).addClass('image-button-hover');
	}, function() {
			$(this).removeClass('image-button-hover');
	});

	$("#visitorTabs").tabs({
		cache: true,
		ajaxOptions: { cache: false}
	});

	/*
	$("#confirmCloseTab").dialog({
		autoOpen: false,
		bgiframe: true,
		resizable: false,
		height:160,
		modal: true,
		overlay: {
			backgroundColor: '#000',
			opacity: 0.5
		},
		buttons: {
			'Close this chat tab?': function() {
				//var $currTab = ui.index; //$('li', $chatTabs).index($(this).parents('li:first')[0]);

				$chatTabs.tabs('remove', $('#activeTab').val());
				closeChatTab($('#activeTab').val());

				$("#tabs").tabs('select', $('#activeTab').val());

				$(this).dialog('close');

			},
			Cancel: function() {
				$(this).dialog('close');
			}
		}
	});
	*/

	$chatTabs = $("#tabs").tabs({
		cache: true,
		ajaxOptions: { cache: false, async: true },
		show: function(event, ui) {
			//alert ("show callback, ui.index: " + ui.index);

			if (typeof activeChats[ui.index] != 'undefined') {
				activeChatId = activeChats[ui.index];
				$("#chatWindow"+activeChatId).attr({ scrollTop: $("#chatWindow"+activeChatId).attr("scrollHeight") });
				endChatOff();
				if (chatStatus[activeChatId] === 'inProgress') {
					endChatOn(activeChatId);
				}
				getVisitorDetail( tabVisitorIds[ui.index] );

				$("#selectedVisitor").html("<b>You have selected " + $(ui.tab).text() + "</b>");
			}

			$('#activeTab').val(ui.index);
		},
    add: function(e, ui) {
      // append close thingy
      $(ui.tab).parents('li:first')
        .append('<em class="ui-tabs-close" title="Close Tab">x</em>')
        .find('em')
        .click(function () {
          var $currTab = $('li', $chatTabs).index($(this).parents('li:first')[0]);

          var currChatId = activeChats[$currTab];
          $("#txt_message"+currChatId).unbind();
          purge (document.getElementById('txt_message' + currChatId));

          $chatTabs.tabs('remove', $currTab);
          closeChatTab($currTab);

          //$("#confirmCloseTab").dialog('open');
        });
      // select just added tab
      $chatTabs.tabs('select', '#' + ui.panel.id);
    }
	});

	$("#chat-invite-unavailable").dialog({
		height: 140,
		modal: true,
		autoOpen: false
	});



  /*
  $(window).unload( function () {

  });
  */
});

/*
soundManager.url = 'swf';
soundManager.onload = function () {
  // SM2 has loaded - now you can create and play sounds!
  soundManager.createSound('ringing','sounds/ringing.mp3');
  soundManager.createSound('phone','sounds/phone.mp3');
  soundManager.createSound('new_message1','sounds/new_message1.mp3');
  soundManager.createSound('new_message2','sounds/new_message2.mp3');
  soundManager.createSound('visitor_arrived','sounds/visitor_arrived.mp3');
  soundManager.createSound('visitor_left','sounds/visitor_left.mp3');
  soundManager.createSound('logout','sounds/chimebar_logout.mp3');
};
*/

/*
 * Function is called when the user closes the window to make sure that their status is set to be offline
 */
$(window).bind('beforeunload', function(){

  if ($("#operatorAvailability").val() == "online") {
    $.ajax({
      type: "POST",
      dataType: "json",
      url: "operator-actions.php",
      data: "action=update-availability&operator_id=" + $("#operator_id").val() + "&availability=offline",
      async: false
    });
  }
});
