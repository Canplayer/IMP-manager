const http = require("http")
const app = http.createServer(function (request, response) {
    console.log(request)
    let body = []
    request.on('data', (chunk) => {
        body.push(chunk)
    }).on("end", () => {
        let data = Buffer.concat(body).toString()
        console.log(data)
        response.write("Hello World!")
        response.end()
    })
})

app.listen(3000)