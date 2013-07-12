class Selector
  constructor: (selector) ->
    @input = $("#{selector}-input")
    @dropdown = $("#{selector}-selector")
    @placeholder = @dropdown.children 'span'
    @prefix = @placeholder.text()
    @options = @dropdown.find 'ul.dropdown > li'
    this.initEvents()

  initEvents: ->
    self = this

    @dropdown.on 'click', (e) ->
      $(this).toggleClass('active') unless $(this).hasClass('disabled')
      false

    @options.on 'click', (e) ->
      $el = $(this)
      $el.siblings().removeClass 'selected'
      $el.addClass 'selected'
      self.placeholder.text "#{self.prefix}: #{$el.text()}"
      self.setValue $el.data 'value'
      $('textarea').focus()

    @options.filter('.selected').click()
    @dropdown.removeClass 'active'

  setValue: (value) ->
    @input.val value

$ ->
  new Selector '#syntax'
  $(document).on 'click', (e) ->
    $('.wrapper-dropdown').removeClass 'active'
