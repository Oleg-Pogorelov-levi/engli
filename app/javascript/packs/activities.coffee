$(document).on 'ready turbolinks:click turbolinks:load', ->
  if (window.location.pathname == '/activities')
    console.log("Update was success!!")
    $.ajax '/activities/read_all',
      type: 'PUT'
      beforeSend: (jqXHR, settings) ->
        jqXHR.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
      dataType: 'json'
      error: (jqXHR, textStatus, errorThrown) ->
      success: (data, textStatus, jqXHR) ->
        alert('OPS!!!')