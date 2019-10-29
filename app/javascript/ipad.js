var iPad = {

  currentTimeSelector: ".current-timestamp",
  punchAtSelector: "input[name=\"punch[punch_at]\"]",
  updateClockInterval: null,

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

}

$(document).on('turbolinks:load', function() {
  iPad.updateClock();
  iPad.updateClockInterval = setInterval(iPad.updateClock, 500);
});