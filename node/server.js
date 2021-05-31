var http = require("http");

const app = http.createServer((request,response) => {
    console.log('客户端访问',request.url);
    console.log(response);
    response.writeHead(200);
    response.end('Hello NodeJS');
})
app.listen(3000);
console.log('服务正在监听3000...');