/*
 * CHAT
 */

$.filter_input = $('#filter-chat-list');
$.chat_users_container = $('#chat-container > .chat-list-body')
$.chat_users = $('#chat-users')
$.chat_list_btn = $('#chat-container > .chat-list-open-close');
$.chat_body = $('#chat-body');

/*
* LIST FILTER (CHAT)
*/

// custom css expression for a case-insensitive contains()
jQuery.expr[':'].Contains = function(a, i, m) {
	return (a.textContent || a.innerText || "").toUpperCase().indexOf(m[3].toUpperCase()) >= 0;
};

function listFilter(list) {// header is any element, list is an unordered list
	// create and add the filter form to the header

	$.filter_input.change(function() {
		var filter = $(this).val();
		if (filter) {
			// this finds all links in a list that contain the input,
			// and hide the ones not containing the input while showing the ones that do
			$.chat_users.find("a:not(:Contains(" + filter + "))").parent().slideUp();
			$.chat_users.find("a:Contains(" + filter + ")").parent().slideDown();
		} else {
			$.chat_users.find("li").slideDown();
		}
		return false;
	}).keyup(function() {
		// fire the above change event after every letter
		$(this).change();

	});

}

$( document ).ready(function() {
  // on dom ready
  listFilter($.chat_users);

  // open chat list
  $.chat_list_btn.click(function() {
  	$(this).parent('#chat-container').toggleClass('open');
  })

  /*
  $.chat_body.animate({
  	scrollTop : $.chat_body[0].scrollHeight
  }, 500);
  */

  setTimeout(updateVisitors, 5000);
});


function updateVisitors () {
  var organization_id = $("#visitor-table").attr("data-id");
  if ($(".comment").length > 0) {
    var after = $(".comment:last-child").attr("data-time");
  } else {
    var after = "0";
  }
  $.getJSON("/visitors.json?organization_id=" + organization_id + "&after=" + after, function (results) {
    
    $('#loading_visitors').hide();

    console.log(results);
  
    $.each(results, function(i, visitor) {
      $('#visitor-table > tbody:last').append('<tr><td>' + visitor.id + '</td><td></td><td></td><td></td><td></td><td>' + visitor.current_page + '</td></tr>');
    });
    
    setTimeout(updateVisitors, 5000);
  });
}
