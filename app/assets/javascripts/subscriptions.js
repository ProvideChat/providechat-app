
function calculate_total_price() {
  var total_price = 0;
  var agent_plan = $('#agent-plan').val();
  if (agent_plan == "monthly-agent-19") {
    total_price = parseInt($('#agent-quantity').val(), 10) * 19;
  } else if (agent_plan == "yearly-agent-180") {
    total_cost = parseInt($('#agent-quantity').val(), 10) * 180;
  }

  return total_cost;
}

function calculate_total_savings() {
  var agent_plan = $('#agent-plan').val();
  var total_savings = 0;
  if (agent_plan == "yearly-agent-180") {
    total_savings = parseInt($('#agent-quantity').val(), 10) *  48;
  }
}

function display_total_price() {
  var agent_plan = $('#agent-plan').val();
  if (agent_plan == "monthly-agent-19") {
    $('#total-price').html( "$" + calculate_total_price() + " / month");
  } else if (agent_plan == "yearly-agent-180") {
    var total_savings = parseInt($('#agent-quantity').val(), 10) *  48;
    $('#total-price').html( "$" + calculate_total_price() + " / year <small><i>(Save $" + total_savings + "/year)</i></small>");
  }
}

function calculate_coupon_price(coupon) {

  var agent_plan = $('#agent-plan').val();
  var coupon_price = calculate_total_price();

  if (coupon.valid === false) {
    $('#coupon-code-msg').html("<span class='label label-warning'>Sorry, this coupon code is no longer valid</span>");
  } else if (coupon.valid === true) {

    $('#total-price').css('text-decoration', 'line-through');
    if (coupon.amount_off > 0) {
      if (coupon.duration === "repeating") {
        $('#coupon-code-msg').html("<span class='label label-info'>Coupon code applied: $" + coupon.amount_off + " for " + coupon.duration_in_months + " months</span>");
      } else {
        $('#coupon-code-msg').html("<span class='label label-info'>Coupon code applied: $" + coupon.amount_off + " off</span>");

        if (agent_plan == "monthly-agent-19") {
          $('#coupon-price').html( "$" + (calculate_total_price() - coupon.amount_off) + " / month <small><i>(for your first month)</i></small>");
        } else if (agent_plan == "yearly-agent-180") {
          $('#coupon-price').html( "$" + (calculate_total_price() - coupon.amount_off) + " / year <small><i>(for your first year)</i></small>");
        }
      }

    } else if (coupon.percent_off > 0) {

      if (coupon.duration === "repeating") {
        $('#coupon-code-msg').html("<span class='label label-info'>Coupon code applied: " + coupon.percent_off + "% for " + coupon.duration_in_months + " months</span>");

        if (agent_plan == "monthly-agent-19") {
          $('#coupon-price').html( "$" + (calculate_total_price() * (coupon.percent_off/100)) + " / month <small><i>(for first " + coupon_duration_in_months + " months)</i></small>");
        } else if (agent_plan == "yearly-agent-180") {
          $('#coupon-price').html( "$" + (calculate_total_price() * (coupon.percent_off/100)) + " / year <small><i>(for your first year)</i></small>");
        }
      } else {
        $('#coupon-code-msg').html("<span class='label label-info'>Coupon code applied: " + coupon.percent_off + "% off</span>");

        if (agent_plan == "monthly-agent-19") {
          $('#coupon-price').html( "$" + (calculate_total_price() * (coupon.percent_off/100)) + " / month <small><i>(for your first month)</i></small>");
        } else if (agent_plan == "yearly-agent-180") {
          $('#coupon-price').html( "$" + (calculate_total_price() * (coupon.percent_off/100)) + " / year <small><i>(for your first year)</i></small>");
        }
      }
    }
  }
}

function apply_coupon() {

  $("#apply-coupon").attr('disabled', true);

  $('#coupon-code-msg').html("<i class='fa fa-circle-o-notch fa-spin fa-fw'></i> Looking up coupon");
  $('#coupon-price').html("");

  var coupon_code = $('#coupon-code').val();
  if (coupon_code === '') {
    $('#coupon-code-msg').html("<span class='label label-danger'>Coupon code cannot be blank</span>");
    $("#apply-coupon").attr('disabled', false);
  } else {
    $.getJSON("/coupons/" + coupon_code, function (data) {
      if (data.coupon === null) {
        $("#apply-coupon").attr('disabled', false);
        $('#coupon-code-msg').html("<span class='label label-warning'>Coupon code invalid</span>");
      } else {
        $("#apply-coupon").attr('disabled', false);
        calculate_coupon_price(data.coupon);
      }
    });
  }
}

$(document).ready(function() {
  $('#payment-form').submit(function(event) {
    var $form = $(this);

    $form.find('input:submit').prop('disabled', true);

    Stripe.card.createToken($form, stripeResponseHandler);

    return false;
  });

  $('#agent-quantity').change(function() {
    display_total_price();
    if ($('#coupon-price').html().length > 0) {
      apply_coupon();
    }
  });

  $('#agent-plan').change(function() {
    display_total_price();
    if ($('#coupon-price').html().length > 0) {
      apply_coupon();
    }
  });

  $("#apply-coupon").click(function() {
    apply_coupon();
  });

  display_total_price();
});

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
}

