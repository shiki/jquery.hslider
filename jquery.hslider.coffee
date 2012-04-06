
#
# jquery.hslider.coffee
#
# A jQuery plugin, this is a base utility for creating user interfaces with horizontal sliding. 
# This prepares a list of elements, with ".pages" as classes, for horizontal scrolling. Scrolling
# can then be controlled by calling `selectIndex`. This allows developers to implement
# their own UI. 
#
# Usage:
#
# This expects a HTML setup like this:
#
# <div id="container">
#   <ul class=".pages">
#     <li class=".page"> <!-- your content here --> </li>
#     <li class=".page"> <div class="your-content"></div> </li>
#   </ul>
# </div>
#
# To set it up:
#
# $('#container').hslider({
#   easing: 'easeInOutCubic' // define the easing function to use
#   duration: 400 // animation durations
# });
#
# Once you have the container set up for horizontal sliding, you can control 
# what page to slide to using this:
#
# $('#container').hslider('instance').selectIndex(1);
# 
# Passing a boolean for the second parameter in selectIndex will instruct the slider to
# animate or not.
#
# @author Shiki
#

((factory) ->
  if typeof define is 'function' && define.amd
    define ['jquery'], factory
  else
    factory(jQuery)
)(($) ->

  $.Shinso = {} unless $.Shinso

  EVT_SELECTED_PAGE_CHANGED = 'hslider:selected_page_changed'
  EVT_HEIGHT_CHANGED = 'hslider:height_changed'
  
  class $.Shinso.HSlider
    constructor: (@$el, options) ->
      @options = $.extend 
        easing: 'swing'
        duration: 500,
        pageHeight: 'auto'
      , options

      @$pagesContainer = @$el.find '.pages:first'
      
      # set required styles
      @$el.css overflow: 'hidden', position: 'relative'

      @_pagesContentChanged()

      @$el.bind EVT_SELECTED_PAGE_CHANGED, $.proxy(@selectedPageChanged, @)

    selectedPageChanged: (e) ->
      index = @selectedPageIndex
      page = @$pagesContainer.children(':eq(' + index + ')')
      left = 0 - index * @$el.width()

      duration = if @_animateNextChange then @options.duration else 0
      @$pagesContainer.stop(true).animate
        'margin-left': left
      , duration, @options.easing

      self = @
      if @options.pageHeight is 'auto'
        @$el.stop(true).animate
          'height': page.height()
        , @options.duration, () ->
          self.$el.trigger EVT_HEIGHT_CHANGED

      @_animateNextChange = true

    selectIndex: (index, animate) ->
      animate = true if typeof animate is 'undefined'
      @_animateNextChange = animate

      if !@selectedPageIndex || @selectedPageIndex != parseInt(index)
        @selectedPageIndex = parseInt(index)
        @$el.trigger EVT_SELECTED_PAGE_CHANGED

    _pagesContentChanged: ->
      @$pages = @$pagesContainer.children '.page'
      @$pagesContainer.css 
        width: @$el.width() * @$pages.length, 
        position: 'relative',
        'margin-left': 0
      @$pages.css width: @$el.width(), 'float': 'left'

      unless @options.pageHeight is 'auto'
        @$pages.css height: parseInt(options.pageHeight)

    setPagesHTML: (html) ->
      @$pagesContainer.html html

      @_pagesContentChanged()

  $.fn.hslider = (options) ->
    if options is 'instance'
      return $(@).data 'shinso.hslider'
    else
      return @each () ->
        el = $(@)
        instance = el.data 'shinso.hslider'
        unless instance
          instance = new $.Shinso.HSlider el, options
          el.data 'shinso.hslider', instance

)