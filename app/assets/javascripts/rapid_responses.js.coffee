# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $("#nestable-menu").on "click", (e) ->
    target = $(e.target)
    action = target.data("action")
    $(".dd").nestable "expandAll"  if action is "expand-all"
    $(".dd").nestable "collapseAll"  if action is "collapse-all"
    return

  $('#nestable').nestable()