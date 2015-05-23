
function ready() {
  $('#payment-form').submit(function(event) {
    var $form = $(this);

    $form.find('button').prop('disabled', true);

    Stripe.card.createToken($form, stripeResponseHandler);

    return false;
  });
    
  $('.spinner .btn:first-of-type').on('click', function() {
    $('.spinner input').val( parseInt($('.spinner input').val(), 10) + 1);
    $('#total-price').html( "$" + parseInt($('#agent-quantity').val(), 10) * 15 + " / month");
  });
  $('.spinner .btn:last-of-type').on('click', function() {
    $('.spinner input').val( parseInt($('.spinner input').val(), 10) - 1);
    $('#total-price').html( "$" + parseInt($('#agent-quantity').val(), 10) * 15 + " / month");    
  });
  
  $('#total-price').html( "$" + parseInt($('#agent-quantity').val(), 10) * 15 + " / month");
};

$(document).ready(ready);
$(document).on('page:load', ready);

function stripeResponseHandler(status, response) {
  var $form = $('#payment-form');

  if (response.error) {
    // Show the errors on the form
    $form.find('.payment-errors').text(response.error.message);
    $form.find('button').prop('disabled', false);
  } else {
    // response contains id and card, which contains additional card details
    var token = response.id;
    // Insert the token into the form so it gets submitted to the server
    $form.append($('<input type="hidden" name="stripeToken" />').val(token));
    // and submit
    $form.get(0).submit();
  }
};

