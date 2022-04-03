const faker = require("faker")
const jsonServer = require('json-server')
const server = jsonServer.create()

const middlewares = jsonServer.defaults({ "bodyParser": true })

var morgan = require('morgan')
morgan.token('host', function (req, res) { return req.headers['host'] })
server.use(morgan(':method :host :url :status :res[content-length] - :response-time ms'))

let auto_increment = 4

let catalogItems = [{
    "id": 1,
    "color": "amber",
    "department": "Eyewear",
    "name": "Elinor Glasses",
    "price": "282.00"
}, {
    "id": 2,
    "color": "cyan",
    "department": "Clothing",
    "name": "Atlas Shirt",
    "price": "127.00"
}, {
    "id": 3,
    "color": "teal",
    "department": "Clothing",
    "name": "Small Metal Shoes",
    "price": "232.00"
}, {
    "id": 4,
    "color": "red",
    "department": "Watches",
    "name": "Red Dragon Watch",
    "price": "232.00"
}
]

var blowups = {}

const blowupMiddleware = function (req, res, next) {
    var numBlowUps = Object.keys(blowups).length
    console.log("request path: " + req.path)
    console.log("blowups: %j", blowups)
    console.log("number of blowups: " + numBlowUps)

    var blownUp = false;

    if (req.path.includes('items') && numBlowUps > 0) {

        Object.keys(blowups).forEach(key => {
            let value = blowups[key];

            if (value.active == true) {
                if (value.type == "500") {
                    var rando = Math.floor(Math.random() * 100);
                    var percentage = value.percentage || 100
                    console.log("rando is " + rando + " and percentage is " + percentage)
                    if (rando <= percentage) {
                        console.log("Sending a 500 blowup");
                        blownUp = true;
                        res.status(500).end();
                    }
                }
                else if (value.type == "latency") {
                    var sleep = value.latencyMs || 1000;
                    // if volatile is set then sleep fluctuates from 0 to the latency value
                    if (value.volatile) {
                        sleep = Math.floor(Math.random() * sleep);
                    }

                    console.log("Sending a latency blowup for " + sleep + "ms");
                    blownUp = true;
                    setTimeout(() => { next() }, sleep);
                }
                else if (value.type == "drop") {
                    var rando = Math.floor(Math.random() * 100);
                    var percentage = value.percentage || 100
                    console.log("rando is " + rando + " and percentage is " + percentage)
                    if (rando <= percentage) {
                        console.log("Dropping connection");
                        blownUp = true;
                        req.socket.end();
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

server.get('/blowup', function (req, res) {
    res.send(blowups);
})

server.get('/items', function (req, res) {
    if (process.env.SHOW_IMAGE) {
        catalogItems.forEach(element => {
            element.imageUrl = faker.image.imageUrl();
        });
    }
    res.send(catalogItems);
})

server.get('/items/:id', function (req, res) {
    catalogItems.forEach(element => {
        if (element.id == req.params.id) {
            if (process.env.SHOW_IMAGE) {
                element.imageUrl = faker.image.imageUrl();
            }
            res.send(element);
        }
    });
    res.sendStatus(404);
})

server.post('/items', function (req, res) {
    req.body.id = ++auto_increment
    catalogItems.push(req.body)
    res.status(201)
    res.send();
})

server.post('/blowup', function (req, res) {
    console.log("altering blowup with " + req.body)
    blowups[req.body.type] = req.body
    res.send('blowups=' + blowups).status(200);
})

server.delete('/blowup', function (req, res) {
    delete blowups[req.body.type]
    res.send("deleted blowup " + req.body.type);
})

server.listen(3000, () => {
    console.log('JSON Server is running')
})
