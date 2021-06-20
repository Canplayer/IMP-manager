const express = require("express")
const zmq = require("zeromq")
const parseStringPromise = require('xml2js').parseStringPromise;

const app = express()
app.use(express.json())

async function login(userid, passwd) {
  let sock = new zmq.Request()
  let msg = `<?xml version="1.0" encoding="UTF-8"?>
  <SOAP><MSGTYPE>000001</MSGTYPE><ACCOUNT>${userid}</ACCOUNT
  ><PASSWORD>${passwd}</PASSWORD><AUTHORITY>1</AUTHORITY></SOAP>`
  sock.connect("tcp://10.10.170.191:5566")
  await sock.send(msg)
  let result_str = (await sock.receive()).toString()
  let result = await parseStringPromise(result_str)
  return result
}

app.post("/login", async (req, res) => {
  const { username, passwd } = req.body
  if (!username || !passwd) {
    res.json({
      "result": "Failed"
    })
    return
  }
  let result = await login(username, passwd)
  if (result["SOAP"]["MSGTYPE"][0] === "000002" && result["SOAP"]["LOGINREPLY"][0] === "1") {
    res.json({
      "result": "OK",
      "authority": result["SOAP"]["AUTHORITY"][0].split(","),
      "department": result["SOAP"]["DEPARTMENT"][0],
      "username":result["SOAP"]["USERNAME"][0],
      "phone":result["SOAP"]["PHONE"][0],
      "email":result["SOAP"]["EMAIL"][0],
    })
  } else {
    res.json({
      "result": "FAILED"
    })
  }

})

app.listen(8081)
