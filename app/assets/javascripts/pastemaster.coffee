$ ->
  $form = $('#pasteform')
  $contents = $('#contents')
  $_button = $('#submitbtn')
  $button = $('#submitlnk')

  # Hide generic button, show styled button
  $_button.hide()
  $button.show()
  $contents.focus()

  # Binding submit event to new button
  $button.on 'click', ->
    $form.submit()
    false
