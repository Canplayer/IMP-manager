const express = require("express")
const zmq = require("zeromq")
const parseStringPromise = require('xml2js').parseStringPromise;
const redis = require("redis");
const { promisify } = require("util")
//const serverUrl = "10.10.142.81"
const serverUrl = "10.10.170.191"
const port = "5566"
const client = redis.createClient({
  host: serverUrl
});
const app = express()
app.use(express.json())

async function login(userid, passwd) {
  let sock = new zmq.Request()
  let msg = `<?xml version="1.0" encoding="UTF-8"?>
  <SOAP><MSGTYPE>000001</MSGTYPE><ACCOUNT>${userid}</ACCOUNT
  ><PASSWORD>${passwd}</PASSWORD><AUTHORITY>1</AUTHORITY></SOAP>`
  sock.connect(`tcp://${serverUrl}:${port}`)
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
  console.log('用户'+username+'尝试登录');
  let result = await login(username, passwd)
  if (result["SOAP"]["MSGTYPE"][0] === "000002" && result["SOAP"]["LOGINREPLY"][0] === "1") {
    res.json({
      "result": "OK",
      "authority": result["SOAP"]["AUTHORITY"][0].split(","),
      "department": result["SOAP"]["DEPARTMENT"][0],
      "username": result["SOAP"]["USERNAME"][0],
      "phone": result["SOAP"]["PHONE"][0],
      "email": result["SOAP"]["EMAIL"][0],
    })
  } else {
    res.json({
      "result": "FAILED"
    })
  }

})

app.get("/datain", async (req, res) => {
  const { userId } = req.query
  if (userId == null) {
    res.json({
      "result": "failed"
    })
    return
  }
  let result = await queryDataIn(userId)
  res.json(result)
})
/**
 * 查询录入信息
 * @param {string} id 
 */
async function queryDataIn(id) {
  let msg = `<?xml version="1.0" encoding="UTF-8"?><SOAP><MSGTYPE>000016</MSGTYPE><ACCOUNT>${id}</ACCOUNT><BEGINDATE>2021-06-13</BEGINDATE><ENDDATE>2021-06-27</ENDDATE></SOAP>`
  let sock = new zmq.Request()

  sock.connect(`tcp://${serverUrl}:${port}`)
  await sock.send(msg)
  const result = await sock.receive()
  // TODO: parse xml for result
  return read_matchorder(id)

}


async function read_matchorder(id) {
  const xRead = promisify(client.xread).bind(client)
  const xDel = promisify(client.xdel).bind(client)
  let stream = await xRead("COUNT", 100, "STREAMS", `${id}_MATCHORDER`, "0-0")
  let result = []
  if (stream) {
    // let stream_name = stream[0][0]
    let stream_data = stream[0][1]
    for (stream_item of stream_data) {
      let item_id = stream_item[0]
      let count = await xDel(`${id}_MATCHORDER`, item_id)
      let item_data = stream_item[1]
      let item_json = {}
      for (let i = 0; i < item_data.length; i += 2) {
        item_json[item_data[i]] = item_data[i + 1]
      }
      result.push(item_json)
    }
  }
  return result
}

app.post("/datain", async (res, req) => {
  console.log('有人尝试获取用户列表');
  const data = res.body
  try {
    let key = await dataIn(data)
    req.json({
      "result": "OK",
      "key": key
    })
  } catch (error) {
    req.json({
      "result": "FAILED",
    })
  }

})
  // let data = {
  //   "original-streams-id": "",
  //   "distribute-streams-id": "",
  //   "userid": "666",
  //   "opuserid": "666",
  //   "sduserid": "",
  //   "department": "囧",
  //   "person2contact": "囧士",
  //   "phone2contact": "1006811",
  //   "faultdate": "2021-6-30",
  //   "faulttype": "囧",
  //   "problemdescribe": "囧",
  //   "reportdate": "2021-6-30",
  //   "reporttime": "09:44:55",
  //   "engineer": "囧",
  //   "engineerphone": "",
  //   "faultprogress": "",
  //   "solution": "囧"
  // }
function dataIn(data) {
  let dataInMap = `ORDERDATAIN`
  let args = [dataInMap, "*"]
  Object.keys(data).forEach(key => {
    args.push(key)
    args.push(data[key])
  })
  return new Promise((res, rej) => {
    client.sendCommand(`XADD`, args, (err, key) => {
      if (err) {
        rej(err)
      } else {
        res(key)
      }
    })
  })

}
app.listen(8081)
console.log('服务器开始运作');
