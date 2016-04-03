var http = require('http');

var client = 'ios';
var user = process.argv[2] || 'admin';
var domain =  process.argv[3] || 'testDomainT4';

var url = 'http://btdemo.plurilock.com:8090/api/users/' + client + '_' + user + '_' + domain;
console.log("Querying url:", url);
var packetCount = 0;

var RESET   = "\033[0m";
var RED     = "\033[31m";
var GREEN   = "\033[32m";
var YELLOW  = "\033[33m";
var BLUE    = "\033[34m";
var MAGENTA = "\033[35m";
var CYAN    = "\033[36m";

function getData() {
	console.log("Polling for new data...");
	
	http.get(url, function(response) {
		var json = '';

		//another chunk of data has been recieved, so append it to `str`
		response.on('data', function (chunk) {
			json += chunk;
		});

		//the whole response has been recieved, so we just print it out here
		response.on('end', function () {
			json = json.substring(1, json.length - 1);
			jsons = json.split('][');

			for (var i = jsons.length - 1; i >= packetCount; i--) {
				jsons[i] = JSON.parse('[' + jsons[i] + ']');
			};

			for (var i = jsons.length - 1; i >= packetCount; i--) {
				var packet = jsons[i];

				for (var n = packet.length - 1; n >= 0; n--) {
					var evt = packet[n];
					var colour = MAGENTA;

					switch (evt.evtType) {
						case "MonoTouch":
						case "DiTouch":
							colour = GREEN;
							break;
						case "MonoKey":
						case "DiKey":
						case "mono":
						case "di":
							colour = YELLOW;
							break;
						case "DeviceData":
							colour = CYAN;
							break;
					}

					console.log(RESET, "-" + colour, JSON.stringify(evt), RESET);
				};
			};

			packetCount = jsons.length;
		});
	}).on('error', function(err) {
		console.log("Got error:", err.message);
	});
}

setInterval(getData, 5000);
