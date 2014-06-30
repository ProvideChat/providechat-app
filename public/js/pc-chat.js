
var chatTimer;
var pingTimer;
var keypressStatusTimer;
var keypressMsgTimer;
var keypressStatus = 'no';
var chatAcceptTimeout = 0;
var operatorResponseTimeout = 0;
var chatStatus;

var lastMessageId = 0;

function urlencode( str ) {

	var ret = str;

	if (ret.length > 0) {
		ret = ret.toString();
		ret = encodeURIComponent(ret);
		ret = ret.replace(/%20/g, '+');
	}

	return ret;
}

function urldecode( str ) {

	var ret = decodeURIComponent(str.replace(/\+/g,  " "));

	return ret;
}

function updateChatStatus(chatId, status) {

	chatStatus = status;

	$.ajax({
		type: "POST",
    dataType: "json",
		url: "updateChat.php",
		data: "action=update_chat_status&chat_id=" + chatId + "&chat_status=" + status
	});
}

function updateVisitorStatus(chatId, status) {

	$.ajax({
		type: "POST",
    dataType: "json",
		url: "updateChat.php",
		data: "action=update_visitor_status&chat_id=" + chatId + "&visitor_status=" + status
	});
}

/*
 * The function updateOperator takes a chat id and requests an update to the operator Info
 * which is displayed to the visitor in the chat window.
 */
function updateOperator(chatId) {

	$.ajax({
		type: "POST",
    dataType: "json",
		url: "updateChat.php",
		data: "action=update_operator&chat_id=" + chatId,
		success: function(operator_info){

			// If the chat status is either 1 or 2 that means visitor is connected to an operator
			// and so information should be displayed accordingly
			if (operator_info.chat_status == "inProgress") {

				$("#operatorInfo").html("You are now chatting with " + operator_info.display_name + "<br /><b>How can I help you?</b>");

				if (operator_info.image_type == "1") {
					$("#operatorImage").attr("src", "images/male.gif");
				} else if (operator_info.image_type == "2") {
					$("#operatorImage").attr("src", "images/female.gif");
					operatorImage.src = 'images/female.gif';
				} else if ((operator_info.image_type == "0") && (operator_info.picture_size > 0)) {
					var randomnumber=Math.floor(Math.random()*1001);
					$("#operatorImage").attr("src", "displayOperatorImage.php?id=" + operator_info.operator_id + "&random=" + randomnumber );
				} else {
					$("#operatorImage").attr("src", "images/silouette.gif");
				}
			// A chat status of 3 means the chat is now over
			} else if (operator_info.chat_status == "operatorEnded") {
				$("#operatorInfo").html("Thank you for chatting with " + operator_info.display_name + "<br /><b>The chat session is now over</b>");

				$("#operatorImage").attr("src", "images/silouette.gif");

			} else {
				// for everything else, set the default image and operator text
				$("#operatorInfo").html("You are being connected with an operator<br /><b>How can I help you?</b>");
				$("#operatorImage").attr("src", "images/silouette.gif");
			}
		}
	});
}

//Send a ping to the server to let it know the visitor is still there
function sendPing(chatId) {

	$.ajax({
		type: "POST",
    dataType: "json",
		url: "process-visitor-chat.php",
		data: "action=ping&chatId=" + chatId
	});

	//pingTimer = setTimeout(function() { sendPing(chatId); }, 2000);	//Send a ping each 2 seconds
}

function getKeypressStatus(chatId) {

	$.ajax({
		type: "POST",
    dataType: "json",
		url: "process-visitor-chat.php",
		data: "action=get_keypress_status&chatId=" + chatId,
		success: function(chat_status){

			if (chat_status.operator_typing == 'yes' ) {
				$('#typingNotification').html ('<i>Operator is typing...</i>');
			} else {
				$('#typingNotification').html ('');
			}

			//clearTimeout(keypressStatusTimer);
			keypressStatusTimer = setTimeout(function() { getKeypressStatus(chatId); }, 1500); // reset the keypress status in 1.5 seconds
		}
	});
}

//Gets the current messages from the server
function getChatText(chatId) {

	$.ajax({
		type: "POST",
    dataType: "json",
		url: "process-visitor-chat.php",
		data: "action=get_unseen_messages&chatId=" + chatId + "&sender=visitor",
		success: function(response) {

			var chatText = '';
			var cancelChat = false;

			chatStatus = response.status;

			// if we get some JSON messages returned then process and display them, otherwise
			// show the operator connection message

			// A Status of 'notStarted means the chat has not yet begun.
			if (response.status === 'notStarted') {

				// do nothing

				chatAcceptTimeout+=2;	// increment it by 2 seconds

				if (chatAcceptTimeout >= operatorResponseTimeout) {
					updateChatStatus (chatId, 'operatorTimeout');
					updateVisitorStatus (chatId, 'doneChat');
					window.location = "unavailable.php?orgId=" + $("#orgId").val() + "&website_id=" + $("#website_id").val() + "&option=maxchats";
				}
			}
			// A Status of 'inProgress' means the chat is active
			else if ((response.status === 'inProgress') || (response.status === 'operatorEnded')) {

				for (var msgCount=0; msgCount < response.message.length; msgCount++) {

					var msg_id = response.message[msgCount].id;
					var msg_type = response.message[msgCount].type;
					var msg_sender = response.message[msgCount].sender;
					var msg_text = response.message[msgCount].text;
					var msg_user = response.message[msgCount].user;

					if (msg_type === 'startChat') {

						chatText = '<table border="0" cellpadding="10" cellspacing="0" width="96%"><tr><td class="maintext">';
						chatText += '<b>' + response.visitorName + ':</b><br /><div class="question">' + response.visitorQuestion + '</div><br>';
            chatText += '<table border="0" cellpadding="0" cellspacing="0" width="96%" class="message"><tr>';
            chatText += '<td valign="top" style="padding-right: 5px;"><img src="images/comments.gif" alt="" width="16" height="16"></td>';
            chatText += '<td class="maintext">' + msg_text + '</td>';
            chatText += '</tr></table><br /></td></tr></table>';

						updateOperator(chatId);

						getKeypressStatus(chatId);
					}
					else if (msg_type == 'inChat') {

						if (msg_sender === 'visitor') {
							chatText = '<table border="0" cellpadding="10" cellspacing="0" width="96%">';
							chatText += '<tr><td class="maintext" align="left"><b>' + msg_user + ':</b><br />';
							chatText += '<div class="question">' + msg_text + '</div></td></tr></table>';
						}
						else if (msg_sender === 'operator') {
							chatText = '<table border="0" cellpadding="10" cellspacing="0" width="96%">';
							chatText += '<tr><td class="maintext" align="left"><b>' + urldecode(msg_user) + ':</b><br />';
							chatText += '<div class="response">' + msg_text + '</div></td></tr></table>';

							$('#typingNotification').html ('');
						}
					}
					else if (msg_type === 'endChat') {
						chatText = '<br /><table border="0" cellpadding="0" cellspacing="0" width="96%" class="message">';
						chatText += '<tr><td valign="top" style="padding-right: 5px;" align="left">';
						chatText += '<img src="images/comments_delete.gif" alt="" width="16" height="16"></td>';
						chatText += '<td class="maintext" align="left">' + msg_text + '<br /><br />';

						chatText += '<b>Chat ID: ' + chatId + '</b><br />';
						chatText += 'Please reference this Chat ID when contacting us again in the future regarding this issue.';
						chatText += '</td></tr></table><br /><br />';

						cancelChat = true;

						updateOperator(chatId);
					}

					if (msg_type === 'startChat') {
						$("#div_chat").html(chatText);
					} else if ((msg_type === 'inChat') || (msg_type === 'endChat')) {
						$('#div_chat').append(chatText);
						$('#div_chat').animate({scrollTop: $('#div_chat')[0].scrollHeight}, 0);
					}
				}
			}

			if (cancelChat === true) {
				//chatTimer = setTimeout(function() { getChatText(chatId); }, 2000); //Refresh chat in 2 seconds
				clearInterval(chatTimer);
				clearInterval(pingTimer);
			}
		}
	});
}

//Function for initializating the page.
function startChat(chatId, chat_status, operator_response_timeout) {
	//Set the focus to the Message Box.
	$("#txt_message").focus();
	//Start Recieving Messages.

	chatAcceptTimeout = 0;
	operatorResponseTimeout = operator_response_timeout;
	chatStatus = chat_status;

	getChatText(chatId);

	chatTimer = setInterval(function() { getChatText(chatId); }, 2000); //Refresh chat in 2 seconds

	pingTimer = setInterval(function() { sendPing(chatId); }, 2000); //Send a ping each 2 seconds
}


//Add a message to the chat server.
function sendChatText() {

	var chatId = $("#chatId").val();

	if (chatStatus ===  'inProgress') {
		var message = urlencode($("#txt_message").val());
		var visitorName = urlencode($("#visitorName").val());

		if ((message.length === 0) || (message == "%0A") || (message == "%0A%0D")) {
			$("#txt_message").val("");
			$("#txt_message").focus();
		} else {

			var msg_text = $("#txt_message").val();
			var visitor_name = $("#visitorName").val();

			var chatText = '<table border="0" cellpadding="10" cellspacing="0" width="96%">';
			chatText += '<tr><td class="maintext" align="left"><b>' + visitor_name + ':</b><br />';
			chatText += '<div class="question">' + msg_text + '</div></td></tr></table>';

			$("#txt_message").val("");
			$("#txt_message").focus();

			$('#div_chat').append(chatText);
			$('#div_chat').animate({scrollTop: $('#div_chat')[0].scrollHeight}, 0);

			$.ajax({
				type: "POST",
        dataType: "json",
				url: "process-visitor-chat.php",
				data: "action=insert&chatId=" + chatId + "&message=" + message + "&name=" + visitorName + "&msg_sender=visitor&msg_type=inChat"
			});
		}
	} else if (chatStatus === 'operatorEnded') {
		alert ("Chat has now ended");
	} else if (chatStatus === 'notStarted') {
		alert ("Chat has not yet been accepted by an operator");
	} else {
		alert ("We're sorry but your message cannot be sent at this time");
	}
}

function sendEmail() {

	var email = $("#emailAddress").val();
	var chatId = $("#chatId").val();

	var emailForm = document.getElementById('emailForm');
	var emailSent = document.getElementById('emailSent');

	emailForm.style.display = 'none';
	emailSent.style.display = 'block';

	$.ajax({
		type: "POST",
    dataType: "json",
		url: "sendEmail.php",
		data: "chat_id=" + chatId + "&email=" + email
	});
}

/*
 * Function is called when the user closes the window to make sure that their status is set to be offline
 */
$(window).unload( function () {

	var chatId = $("#chatId").val();

	if (chatStatus === 'inProgress') {
		$.ajax({
			type: "POST",
      dataType: "json",
			url: "process-visitor-chat.php",
			data: "action=end&chatStatus=visitorEnded&chatId=" + chatId
		});
	}
});

function updateKeypress(chatId, keypressActive) {

	if (keypressStatus === keypressActive) {

		clearInterval(keypressMsgTimer);
		keypressMsgTimer = setInterval(function() { clearKeypressMsg(chatId); }, 1500); // reset the keypress in 2 seconds

	} else {

		keypressStatus = keypressActive;

		$.ajax({
			type: "POST",
      dataType: "json",
			url: "process-visitor-chat.php",
			data: "action=update_keypress&user=visitor&chatId=" + chatId + "&keypressActive=" + keypressActive,
			success: function(result) {
				clearInterval(keypressMsgTimer);
        if (keypressActive == 'yes') {
          keypressMsgTimer = setInterval(function() { clearKeypressMsg(chatId); }, 1500); // reset the keypress in 2 seconds
        }
			}
		});
	}
}

function clearKeypressMsg(chatId) {

	updateKeypress(chatId, 'no');
}

$(document).ready(function() {

	$('#emailDialog').jqm().jqmAddTrigger('#emailTrigger1').jqmAddTrigger('#emailTrigger2');

	// validate signup form on keyup and submit
	$("#emailChat").validate({
    errorLabelContainer: "#errorBox",
    submitHandler: function() { sendEmail(); }
	});

	$("#operatorAvailability").val(0);

	$.shiftdown = false;
	$.ctrldown = false;

	$("#txt_message").keydown(function (e) {

		if (e.which == 16)  {
			$.shiftdown = true;
		}
		if ((e.which == 17)) {
			$.ctrldown = true;
		}
    });

	$("#txt_message").keyup(function (e) {

		if (e.which == 16)  {
			$.shiftdown = false;
		}
		if ((e.which == 17)) {
			$.ctrldown = false;
		}

		var chatId = $("#chatId").val();

		if ((e.which == 13) && (($.shiftdown === true) || ($.ctrldown === true))) {
			$("#txt_message").value += "\n";
		}
		else if (e.which == 13)  {
			var message = $("#txt_message").val();

			if (message.length > 0) {
				sendChatText();
				updateKeypress(chatId, 'no');
			}
		} else {
			updateKeypress(chatId, 'yes');
		}
  });

  $("#sendBtn").click(function() {
    sendChatText();
    updateKeypress(chatId, 'no');
  });
});
