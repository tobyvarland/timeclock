var Timeclock = {

  initialize: function() {

    // Open popup links in new window.
    $('a[data-popup]').on('click', function(event) {
      var $this = $(this);
      window.open($this.attr('href'), $this.data('popup-title'), 'width=600,height=600,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes');
      event.preventDefault();
    });

  },

}

$(document).on('turbolinks:load', function() {
  Timeclock.initialize();
});