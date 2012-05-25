# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(() ->
  expaand = () ->
    list = $('#friends')[0]
    rowCount = $('#friends tr').length
    list.style.height = rowCount*60 + "px"
    list.style.overflow = "visible"
    list.style.opacity = "1"
    list.style.visibility = "visible"

  expaand()

  successes = $('tr.green')
  Array::shuffle = -> @sort -> 0.5 - Math.random()
  gif_ids = Array(successes.length)
  gif_ids = (Math.floor(10*Math.random()) for i in gif_ids)

  for success in successes
    $(success).popover(title: '#YOLO', content:"<img style='width: 100%;' src='/gifs/#{gif_ids.pop()}.gif' />")

  id_hash = {}
  # for instant search
  $('.search-query').keydown((change) ->
    if change.target.value == ''
      $('input').typeahead().data('typeahead').source = []
    else
      $.ajax('/people_search', data: {q: change.target.value}).success((res) ->
        people_list = (r.name for r in res)
        id_hash = {}
        for r in res
          id_hash[r.name] = id: r.id, email: r.email
        $('input').typeahead().data('typeahead').source = people_list
      )
  )

  $('.form-search').submit((event) ->
    event.preventDefault()
    inputs =  $('.form-search :input')
    friend_id = id_hash[inputs.val()].id
    $.post('request', their_id: friend_id).success((res) ->
      if res == 'added'
        $('#friends').append("<tr><td>#{inputs.val()}</td></tr>}")
      else if res == 'matched'
        temp = $('#friends tr').remove()
        $('#friends').append("<tr class='green'><td>#{inputs.val()}</td></tr>}")
        $('#friends').append(temp)
      inputs.val("")
      expaand()
      )
    )
)
