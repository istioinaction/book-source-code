const jsonServer = require('json-server')
const server = jsonServer.create()

const data = require('./generate.js')
const middlewares = jsonServer.defaults({"bodyParser": true})

var morgan = require('morgan')
morgan.token('host', function (req, res) { return req.headers['host'] })
server.use(morgan(':method :host :url :status :res[content-length] - :response-time ms'))

const rewriter = jsonServer.rewriter({
    "/api/*": "/$1"
})

let catalogItems = [{
    "id": 0,
    "color": "mint green",
    "department": "Shoes",
    "name": "Small Frozen Bike",
    "price": "347.00"
}]

var blowups = {}

const blowupMiddleware = function(req, res, next){
    var numBlowUps = Object.keys(blowups).length
    console.log("request path: " + req.path)
    console.log("blowups: %j", blowups)
    console.log("number of blowups: " + numBlowUps)

    var blownUp = false;

    if(req.path.includes('items') && numBlowUps > 0){

        Object.keys(blowups).forEach(key => {
            let value = blowups[key];

            if(value.active == true){
                if(value.type == "500"){
                    var rando = Math.floor(Math.random() * 100);
                    var percentage = value.percentage || 100
                    console.log("rando is " + rando + " and percentage is " + percentage)
                    if (rando <= percentage) {
                        console.log("Sending a 500 blowup");
                        res.status(500).end();
                        blownUp=true;
                    }
                }
                else if (value.type == "latency") {
                    var sleep = value.latencyMs || 1000
                    // if volatile is set then sleep fluctuates from 0 to the latency value
                    if (value.volatile) {
                        sleep = Math.floor(Math.random() * sleep); 
                    }

                    console.log("Sending a latency blowup for " + sleep + "ms")
                    setTimeout(() => { next() }, sleep);
                    blownUp=true
                }
                else if (value.type == "drop") {
                    var rando = Math.floor(Math.random() * 100);
                    var percentage = value.percentage || 100
                    console.log("rando is " + rando + " and percentage is " + percentage)
                    if (rando <= percentage) {
                        console.log("Dropping connection");
                        req.socket.end();
                        blownUp=true
                    }
                }
            }

        })

    }

    if (!blownUp) {
        next();
    }
}

server.use(middlewares)
server.use(blowupMiddleware)

server.get('/blowup', function(req, res){
    res.send(blowups);
})

server.get('/items', function(req, res){
    res.send(catalogItems);
})

server.post('/items', function(req, res){
    catalogItems.push(req.body)
    res.status(201)
    res.send();
})

server.post('/blowup', function (req,res) {
    console.log("altering blowup with " + req.body)
    blowups[req.body.type] = req.body
    res.send('blowups='+blowups).status(200);
})

server.delete('/blowup', function(req,res){
    delete blowups[req.body.type]
    res.send("deleted blowup " + req.body.type);
})

server.listen(3000, () => {
    console.log('JSON Server is running')
})
