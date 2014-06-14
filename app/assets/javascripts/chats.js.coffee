# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $("#from").datepicker
    defaultDate: "+1w"
    changeMonth: true
    numberOfMonths: 1
    prevText: "<i class=\"fa fa-chevron-left\"></i>"
    nextText: "<i class=\"fa fa-chevron-right\"></i>"
    onClose: (selectedDate) ->
      $("#to").datepicker "option", "maxDate", selectedDate
      return

  $("#to").datepicker
    defaultDate: "+1w"
    changeMonth: true
    numberOfMonths: 1
    prevText: "<i class=\"fa fa-chevron-left\"></i>"
    nextText: "<i class=\"fa fa-chevron-right\"></i>"
    onClose: (selectedDate) ->
      $("#from").datepicker "option", "minDate", selectedDate
      return
