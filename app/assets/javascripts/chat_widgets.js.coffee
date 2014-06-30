# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ($) ->
  $("#formname").bind("ajax:loading", ->
    alert "loading!"
    return
  ).bind("ajax:success", (data, status, xhr) ->
    alert "success!"
    return
  ).bind("ajax:failure", (xhr, status, error) ->
    alert "failure!"
    return
  ).bind "ajax:complete", ->
    alert "complete!"
    return

  return