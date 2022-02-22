//node.js project
var express = require('express');
var app = express();

//跨域访问
app.all('*', function(req, res, next) {
    //allow cross origin requests to any origin
    res.header("Access-Control-Allow-Origin", "*")
    res.header("Access-Control-Allow-Headers", "X-Requested-With")
    //print ip
    console.log("访问建立："+req.ip+" "+req.method+" "+req.url);
});

