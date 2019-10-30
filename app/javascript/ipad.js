var iPad = {

  currentTimeSelector: ".current-timestamp",
  punchAtSelector: "input[name=\"punch[punch_at]\"]",
  updateClockInterval: null,
  keypadButtonSelector: '.keypad-button',
  textBox: null,

  deregisterKeypress: function() {
    $(document).off('keydown');
  },

  isTouchable: function() {
    var el = document.createElement('button');
    eventName = 'ontouchend';
    var isSupported = (eventName in el);
    if (!isSupported) {
      el.setAttribute(eventName, 'return;');
      isSupported = (typeof el[eventName] == 'function');
    }
    el = null;
    return isSupported;
  },

  handleNumericButton: function(number) {
    if (iPad.textBox.val().length < 4) { iPad.textBox.val(iPad.textBox.val() + number); }
  },

  handleEnterButton: function() {
    if (iPad.textBox.val().length >= 3) { iPad.textBox.closest("form").submit(); }
  },

  handleDeleteButton: function() {
    if (iPad.textBox.val().length > 0) { iPad.textBox.val(iPad.textBox.val().slice(0, -1)); }
  },

  setupKeypadButtons: function() {

    // Determine proper event for buttons.
    var event = "click";
    if (iPad.isTouchable()) {
      event = "touchend";
    }

    // Set parameters based on page.
    var action = $("body").data('action');
    switch (action) {
      case "number":
        iPad.textBox = $("#employee_number");
        break;
      case "pin":
        iPad.textBox = $("#pin");
        break;
      default:
          return;
    }

    // Auto submit on select change.
    if (action == "number") {
      $("select").on("change", function(event) {
        event.preventDefault();
        iPad.textBox.val($(this).val());
        $(this).closest("form").submit();
      });
    }

    // Setup keyboard handlers.
    $(document).on("keydown", function(event) {
      var ch = (event.keyChar == null) ? event.keyCode : event.keyChar;
      if (ch >= 96 && ch <= 105) { ch -= 48; }
      if (ch >= 48 && ch <= 57) {
        event.preventDefault();
        iPad.handleNumericButton(String.fromCharCode(ch));
      } else if (ch == 8 || ch == 46) {
        event.preventDefault();
        iPad.handleDeleteButton();
      } else if (ch == 13) {
        event.preventDefault();
        iPad.handleEnterButton();
      }
    });

    // Setup button clicks.
    $(iPad.keypadButtonSelector).on("click", function(event) {
      console.log("Handling button event.");
      event.preventDefault();
      var button = $(this);
      var key = button.data("key");
      switch (key) {
        case "del":
          iPad.handleDeleteButton();
          break;
        case "enter":
          iPad.handleEnterButton();
          break;
        default:
          iPad.handleNumericButton(key);
      }
    });

  },

  addLeadingZeroIfNecessary: function(value) {
    if (value < 10) { return "0" + value; }
    else { return value; }
  },

  getCurrentTimestamp: function(humanReadable = true) {

    var currentTime = new Date();
    var offset = currentTime.getTimezoneOffset();
    var offsetHours = offset / 60;
    var currentDay = currentTime.getDate();
    var currentMonth = currentTime.getMonth() + 1;
    var currentYear = currentTime.getFullYear() % 100;
    var currentFullYear = currentTime.getFullYear();
    var currentHour = currentTime.getHours();
    var currentRealHour = currentTime.getHours();
    var currentMinute = currentTime.getMinutes();
    var currentSecond = currentTime.getSeconds();
    var amPM = "am";
    if (currentHour >= 12) {
      amPM = "pm";
      if (currentHour > 12) { currentHour -= 12; }
    }
    var timestamp = null;
    if (humanReadable) {
      timestamp = iPad.addLeadingZeroIfNecessary(currentMonth)
                + "/"
                + iPad.addLeadingZeroIfNecessary(currentDay)
                + "/"
                + iPad.addLeadingZeroIfNecessary(currentYear)
                + " "
                + currentHour
                + ":"
                + iPad.addLeadingZeroIfNecessary(currentMinute)
                + ":"
                + iPad.addLeadingZeroIfNecessary(currentSecond)
                + amPM;
    } else {
      timestamp = currentFullYear
                + "-"
                + iPad.addLeadingZeroIfNecessary(currentMonth)
                + "-"
                + iPad.addLeadingZeroIfNecessary(currentDay)
                + " "
                + iPad.addLeadingZeroIfNecessary(currentRealHour)
                + ":"
                + iPad.addLeadingZeroIfNecessary(currentMinute)
                + ":"
                + iPad.addLeadingZeroIfNecessary(currentSecond)
                + " -"
                + iPad.addLeadingZeroIfNecessary(offsetHours)
                + "00";
    }
    return timestamp;

  },

  updateClock: function() {
    $(iPad.punchAtSelector).val(iPad.getCurrentTimestamp(false));
    $(iPad.currentTimeSelector).text(iPad.getCurrentTimestamp(true));
  },

  hideAlerts: function() {
    $(".alert-primary").fadeOut();
  },

}

$(document).on('turbolinks:load', function() {
  setTimeout(iPad.hideAlerts, 5000);
  iPad.deregisterKeypress();
  iPad.updateClock();
  iPad.updateClockInterval = setInterval(iPad.updateClock, 500);
  iPad.setupKeypadButtons();
});