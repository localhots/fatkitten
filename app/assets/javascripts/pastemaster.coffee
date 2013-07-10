$ ->
  $form = $('form')
  $contents = $form.find('textarea')
  $_button = $form.find('input[type="submit"]')
  $button = $form.find('a[role="submit"]')

  # Hide generic button, show styled button
  $_button.hide()
  $button.show()
  $contents.focus()

  # Binding submit event to new button
  $button.on 'mouseup', ->
    $form.submit()
    false
