class Selector
  constructor: (selector) ->
    @input = $("#{selector}-input")
    @dropdown = $(selector)
    @placeholder = @dropdown.children 'span'
    @prefix = @placeholder.text()
    @options = @dropdown.find 'ul.dropdown > li'
    this.initEvents()

  initEvents: ->
    self = this

    @dropdown.on 'click', (e) ->
      $(this).toggleClass('active')
      false

    @options.on 'click', (e) ->
      $el = $(this)
      $el.siblings().removeClass 'selected'
      $el.addClass 'selected'
      self.placeholder.text "#{self.prefix}: #{$el.text()}"
      self.setValue $el.data 'value'

    @options.filter('.selected').click()
    @dropdown.removeClass 'active'

  setValue: (value) ->
    @input.val value

$ ->
  new Selector '#type'
  $(document).on 'click', (e) ->
    $('.wrapper-dropdown').removeClass 'active'
