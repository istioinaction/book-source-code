const jsonServer = require('json-server')
const server = jsonServer.create()

const data = require('./generate.js')
const router = jsonServer.router(data())
const middlewares = jsonServer.defaults({"bodyParser": true})

const rewriter = jsonServer.rewriter({
    "/api/*": "/$1"
})

server.use(rewriter)

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
                    console.log("Sending a 500 blowup")
                    res.status(500).end();
                    blownUp=true;
                }
                else if (value.type == "latency") {
                    console.log("Sending a latency blowup for " + value.latencyMs + "ms")
                    setTimeout(() => { next() }, value.latencyMs);
                    blownUp=true
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

server.post('/blowup', function (req,res) {
    console.log("altering blowup with " + req.body)
    blowups[req.body.type] = req.body
    res.send('blowups='+blowups).status(200);
})

server.delete('/blowup', function(req,res){
    delete blowups[req.body.type]
    res.send("deleted blowup " + req.body.type);
})


server.use(router)


server.listen(3000, () => {
    console.log('JSON Server is running')
})

