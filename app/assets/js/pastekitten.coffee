$ ->
  $form = $('form')
  $contents = $form.find('textarea')
  $_button = $form.find('input[type="submit"]')
  $button = $form.find('a[role="submit"]')
  $syntax_selector = $('#syntax-selector')

  # Hide generic button, show styled button
  $_button.hide()
  $button.show()
  $contents.focus()

  # Binding submit event to new button
  $button.on 'click', (e) ->
    $form.submit() unless $(this).hasClass('disabled')
    $(this).addClass('disabled')
    $syntax_selector.addClass('disabled')
    false
