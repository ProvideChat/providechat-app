
function calculate_total_price() {
  var agent_plan = $('#agent-plan').val();
  if (agent_plan == "monthly-agent-19") {
    $('#total-price').html( "$" + parseInt($('#agent-quantity').val(), 10) * 19 + " / month");
  } else if (agent_plan == "yearly-agent-180") {
    var total_cost = parseInt($('#agent-quantity').val(), 10) * 180;
    var total_savings = parseInt($('#agent-quantity').val(), 10) *  48;
    $('#total-price').html( "$" + total_cost + " / year <small><i>(Save $" + total_savings + "/year)</i></small>");
  }
}

function ready_payment() {
  $('#payment-form').submit(function(event) {
    var $form = $(this);

    $form.find('input:submit').prop('disabled', true);

    Stripe.card.createToken($form, stripeResponseHandler);

    return false;
  });

  $('.spinner .btn:first-of-type').on('click', function() {
    $('.spinner input').val( parseInt($('.spinner input').val(), 10) + 1);
    calculate_total_price()
  });
  $('.spinner .btn:last-of-type').on('click', function() {
    $('.spinner input').val( parseInt($('.spinner input').val(), 10) - 1);
    calculate_total_price();
  });
  $('#agent-plan').change(function() {
    calculate_total_price();
  });

  calculate_total_price();
};

$(document).ready(ready_payment);
$(document).on('page:load', ready_payment);

function stripeResponseHandler(status, response) {
  var $form = $('#payment-form');

  if (response.error) {
    // Show the errors on the form
    $form.find('.payment-error-msg').text(response.error.message);
    $form.find('#payment-error-box').show();
    $form.find('input:submit').prop('disabled', false);
  } else {
    // response contains id and card, which contains additional card details
    var token = response.id;
    // Insert the token into the form so it gets submitted to the server
    $form.append($('<input type="hidden" name="stripeToken" />').val(token));
    // and submit
    $form.get(0).submit();
  }
};

