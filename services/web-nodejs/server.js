var express = require('express'),
    http = require('http'),
    request = require('request'),
    fs = require('fs'),
    app = express(),
    path = require("path"),
    keycloakConfig = require('./app/keycloak.config.js'),
    coolstoreConfig = require('./app/coolstore.config.js'),
    Keycloak = require('keycloak-connect'),
    cors = require('cors');


var port = process.env.PORT || process.env.OPENSHIFT_NODEJS_PORT || 8080,
    ip = process.env.IP || process.env.OPENSHIFT_NODEJS_IP || '0.0.0.0',
    secport = process.env.PORT || process.env.OPENSHIFT_NODEJS_PORT || 8443;

// Enable CORS support
app.use(cors());

// error handling
app.use(function(err, req, res, next) {
    console.error(err.stack);
    res.status(500).send('Something bad happened!');
});

// keycloak config server
app.get('/keycloak.json', function(req, res, next) {
    res.json(keycloakConfig);
});
// coolstore config server
app.get('/coolstore.json', function(req, res, next) {
    res.json(coolstoreConfig);
});

app.get('/api/products', function (req, res, next) {
    var endpoint = coolstoreConfig.API_ENDPOINT + "/api/products";
    console.log("Calling catalog service at endpoint: " + endpoint )
    console.log("Headers: %j", req.headers)
    var headers = {
        "x-request-id": req.headers["x-request-id"],
        "x-b3-trace-id": req.headers["x-b3-trace-id"],
        "x-b3-spanid": req.headers["x-b3-spanid"],
        "x-b3-parentspanid": req.headers["x-b3-parentspanid"],
        "x-b3-sampled": req.headers["x-b3-sampled"],
        "x-b3-flags": req.headers["x-b3-flags"],
        "x-ot-span-context": req.headers["x-ot-span-context"]
    }
    console.log("using these headers: %j", headers)
    request({
        url: endpoint,
        json: true,
        headers: headers,
        method: 'GET'

    }, function (err, response) {
        console.log('get product data: ', response.body);
        res.json(response.body);
    });
});

app.get('/api/cart/*', function (req, res, next){
    var endpoint = coolstoreConfig.API_ENDPOINT + req.path;
    console.log("GET cart service at endpoint: " + endpoint )
    request(endpoint, {json: true, headers: req.headers}, function (err, response, bd) {
        console.log('get cart data: ', bd);
        res.json(bd);
    });
});

app.post('/api/cart/*', function (req, res, next) {
    var endpoint = coolstoreConfig.API_ENDPOINT + req.path;
    console.log("POST to cart service at endpoint: " + endpoint )
    var clientOptions = {
        uri: endpoint,
        body: JSON.stringify(req.body),
        headers: req.headers,
        method: 'POST'
    }
    request(clientOptions, function(error, response){
        console.log("response from POST /api/cart: " + response.body);
        res.json(response.body)
    });

});

app.delete('/api/cart/*', function (req, res, next) {
    var endpoint = coolstoreConfig.API_ENDPOINT + req.path;
    console.log("DELETE cart item at endpoint: " + endpoint )
    var clientOptions = {
        uri: endpoint,
        headers: req.headers,
        method: 'DELETE'
    }
    request(clientOptions, function(error, response){
        console.log("response from DELETE /api/cart: " + response.body);
        res.json(response.body)
    });
});

app.use(express.static(path.join(__dirname, '/views')));
app.use('/app', express.static(path.join(__dirname, '/app')));
app.use('/bower_components', express.static(path.join(__dirname, '/bower_components')));

console.log("coolstore config: " + JSON.stringify(coolstoreConfig));
console.log("keycloak config: " + JSON.stringify(keycloakConfig));


http.createServer(app).listen(port);

console.log('HTTP Server running on http://%s:%s', ip, port);

module.exports = app;