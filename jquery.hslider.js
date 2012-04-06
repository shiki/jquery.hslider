(function() {

  (function(factory) {
    if (typeof define === 'function' && define.amd) {
      return define(['jquery'], factory);
    } else {
      return factory(jQuery);
    }
  })(function($) {
    var EVT_HEIGHT_CHANGED, EVT_SELECTED_PAGE_CHANGED;
    if (!$.Shinso) $.Shinso = {};
    EVT_SELECTED_PAGE_CHANGED = 'hslider:selected_page_changed';
    EVT_HEIGHT_CHANGED = 'hslider:height_changed';
    $.Shinso.HSlider = (function() {

      function HSlider($el, options) {
        this.$el = $el;
        this.options = $.extend({
          easing: 'swing',
          duration: 500,
          pageHeight: 'auto'
        }, options);
        this.$pagesContainer = this.$el.find('.pages:first');
        this.$el.css({
          overflow: 'hidden',
          position: 'relative'
        });
        this._pagesContentChanged();
        this.$el.bind(EVT_SELECTED_PAGE_CHANGED, $.proxy(this.selectedPageChanged, this));
      }

      HSlider.prototype.selectedPageChanged = function(e) {
        var duration, index, left, page, self;
        index = this.selectedPageIndex;
        page = this.$pagesContainer.children(':eq(' + index + ')');
        left = 0 - index * this.$el.width();
        duration = this._animateNextChange ? this.options.duration : 0;
        this.$pagesContainer.stop(true).animate({
          'margin-left': left
        }, duration, this.options.easing);
        self = this;
        if (this.options.pageHeight === 'auto') {
          this.$el.stop(true).animate({
            'height': page.height()
          }, this.options.duration, function() {
            return self.$el.trigger(EVT_HEIGHT_CHANGED);
          });
        }
        return this._animateNextChange = true;
      };

      HSlider.prototype.selectIndex = function(index, animate) {
        if (typeof animate === 'undefined') animate = true;
        this._animateNextChange = animate;
        if (!this.selectedPageIndex || this.selectedPageIndex !== parseInt(index)) {
          this.selectedPageIndex = parseInt(index);
          return this.$el.trigger(EVT_SELECTED_PAGE_CHANGED);
        }
      };

      HSlider.prototype._pagesContentChanged = function() {
        this.$pages = this.$pagesContainer.children('.page');
        this.$pagesContainer.css({
          width: this.$el.width() * this.$pages.length,
          position: 'relative',
          'margin-left': 0
        });
        this.$pages.css({
          width: this.$el.width(),
          'float': 'left'
        });
        if (this.options.pageHeight !== 'auto') {
          return this.$pages.css({
            height: parseInt(options.pageHeight)
          });
        }
      };

      HSlider.prototype.setPagesHTML = function(html) {
        this.$pagesContainer.html(html);
        return this._pagesContentChanged();
      };

      return HSlider;

    })();
    return $.fn.hslider = function(options) {
      if (options === 'instance') {
        return $(this).data('shinso.hslider');
      } else {
        return this.each(function() {
          var el, instance;
          el = $(this);
          instance = el.data('shinso.hslider');
          if (!instance) {
            instance = new $.Shinso.HSlider(el, options);
            return el.data('shinso.hslider', instance);
          }
        });
      }
    };
  });

}).call(this);
