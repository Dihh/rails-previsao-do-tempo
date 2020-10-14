google.charts.load('current', {
    'packages': ['corechart']
});
google.charts.setOnLoadCallback(drawChart);


function drawChart() {
    var chartData = new google.visualization.DataTable();

    chartData.addColumn('string', 'X'); // Implicit series 1 data col.
    chartData.addColumn('number', 'DOGS'); // Implicit domain label col.
    chartData.addColumn({
        type: 'string',
        role: 'annotation'
    });



    chartData.addRows(data1);

    var a = document.getElementById('chart_div')
    var chart = new google.visualization.LineChart(a);

    var options = {
        legend: {
            position: 'none'
        },
        curveType: 'function',
        hAxis: {
            textPosition: 'none',
            gridlines: {
                color: 'transparent'
            },

        },
        vAxis: {
            textPosition: 'none',
            gridlines: {
                color: 'transparent'
            },
            maxValue: 40,
            minxValue: 0,
        },
        width: window.innerWidth,
        backgroundColor: { fill: 'transparent' },
        lineWidth: 5,
        colors: ['#ccc']
    };
    chart.draw(chartData, options);

}

window.addEventListener('resize', drawChart);

document.querySelector('.change-city').addEventListener('click', () => {
    console.log(1)
    document.querySelector('.menu-item').classList.add('opened')
    document.querySelector('.menu-item').classList.remove('closed')
    document.querySelector('.menu-background').style.display = 'block'
})

document.querySelector('.menu-background').addEventListener('click', () => {
    console.log(1)
    document.querySelector('.menu-item').classList.remove('opened')
    document.querySelector('.menu-item').classList.add('closed')
    document.querySelector('.menu-background').style.display = 'none'
})