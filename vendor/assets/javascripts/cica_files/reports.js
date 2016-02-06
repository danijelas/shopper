var Report = (function() {
  
  function drawChart(domId, type, data, options) {
    options = (typeof options !== 'undefined') ?  options : {};

    // Get the context of the canvas element we want to select
    var ctx = $("#"+domId).get(0).getContext("2d");
    var myChart = new Chart(ctx);
    switch (type) {
      case "Pie":
        myChart.Pie(data, options);
        break;
      case "Doughnut":
        myChart.Doughnut(data, options);
      default:
        myChart.Bar(data, options);
    }
  }
  return {
    drawChart: drawChart
  }

})();
$(document).on('click', '#switchReport', function () {
  // alert('click - toggle: ' + changeToBarView);
  // var ctx = $("#myChart").get(0).getContext("2d");
  // ctx.clearRect(0, 0, 400, 400);
  $('#myChart').replaceWith( '<canvas id="myChart" width="400" height="400"></canvas>' );

  changeToBarView = ! changeToBarView
  if (changeToBarView)
    Report.drawChart('myChart', 'Bar', barData);
  else
    Report.drawChart('myChart', 'Pie', pieData, {animateScale : false, animationEasing : '', animationSteps : 50});
});

var colours = ["#F7464A", "#46BFBD", "#FDB45C", "#B0171F", "#0000FF", "#00FA9A", "#FFFF00", "#EE7600", "#7A378B"];
var highlights = ["#FF5A5E", "#5AD3D1", "#FFC870", "#DC143C", "#4169E1", "#54FF9F", "#FFF68F", "#ED9121", "#9932CC"];
$(document).on('click', '#filterButton', function (ev) {
  ev.preventDefault();
  var periodVal = $('#period').find(":selected").val();
  $.get( "/reports/chart_data", {days: periodVal}, function( data ) {
    var index = 0;
    pieData = [];
    $.each(data, function(key, value) { 
      var record = {
        value: value,
        color: colours[index],
        highlight: highlights[index],
        label: key
      }
      pieData.push(record);
      index = index+1
    });
    var labelsArray = [];
    var sumsArray = [];
    $.each(data, function(key, value) { 
      labelsArray.push(key.toString());
      sumsArray.push(value);
    });
    barData = {
      labels: labelsArray,
      datasets: [
        {
          label: "My First dataset",
          fillColor: "rgba(151,187,205,0.5)",
          strokeColor: "rgba(151,187,205,0.8)",
          highlightFill: "rgba(151,187,205,0.75)",
          highlightStroke: "rgba(151,187,205,1)",
          data: sumsArray
        }
      ]
    };
    var content = '';
    $.each(data, function(key, value) { 
      content +=
      '<tr>'+
        '<td style="width:25%;">' + key + '</td>'+
        '<td style="width:25%;">' + value + '</td>'+
      '</tr>'
    });
    $('tbody').empty().append(content);
    $('#myChart').replaceWith( '<canvas id="myChart" width="400" height="400"></canvas>' );
    if (changeToBarView)
      Report.drawChart('myChart', 'Bar', barData);
    else
      Report.drawChart('myChart', 'Pie', pieData, {animateScale : false, animationEasing : '', animationSteps : 50});
  }, "json" );
});












