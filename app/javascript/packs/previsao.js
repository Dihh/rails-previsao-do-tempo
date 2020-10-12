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

document.querySelector('form').addEventListener('submit', () => {
    document.querySelector('.loader').style.display = 'initial'
    document.querySelector('.menu-item').classList.remove('opened')
    document.querySelector('.menu-item').classList.add('closed')
    const div = document.createElement('div')
    div.classList.add('menu-foreground-out')
    document.body.appendChild(div)
})

// function GoogleGetUserLocation(lat, lng) {
//     const response = await axios.get(
//         `https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat},${lng}&key=${GOOGLE_API_KEY}`
//     );
//     const endereco = response.data.results[0].formatted_address;
//     return endereco;

// }

// function getData(address) {
//     const Address = {}
//     const response = await axios.get(
//         `https://maps.googleapis.com/maps/api/geocode/json?address=${address}&key=${GOOGLE_API_KEY}`
//     );
//     if (response.data.results.length > 0) {
//         Address.lat = response.data.results[0].geometry.location.lat;
//         Address.lng = response.data.results[0].geometry.location.lng;
//         Address.formatted_address = response.data.results[0].formatted_address;

//     } else {
//         Address.formatted_address = "endereço não encontrado";
//         Address.lat = "";
//         Address.lng = "";
//     }
//     return Address
// }

function getUserLocation() {
    navigator.geolocation.getCurrentPosition(async data => {
        const address = {
            latitude: data.coords.latitude,
            longitude: data.coords.longitude
        };
        console.log(address)
        // this.getData();
    });
}

getUserLocation()