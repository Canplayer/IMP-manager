const express = require("express")
const zmq = require("zeromq")
const parseStringPromise = require('xml2js').parseStringPromise;
const redis = require("redis");
const { promisify } = require("util")
const time = require("silly-datetime")


//const serverUrl = "10.10.142.81"  //测试服务器
const serverUrl = "10.10.170.191"  //正式服务器
const port = "5566"
const client = redis.createClient({
  host: serverUrl
});
client.on('error', function(err) {
  console.log('与redis服务器连接出现了异常报告');
});
const app = express()
app.use(express.json())

app.all('*', function (req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header('Access-Control-Allow-Methods', 'PUT,GET,POST,DELETE,OPTIONS');
  res.header("Access-Control-Allow-Headers", "X-Requested-With");
  res.header('Access-Control-Allow-Headers', 'Content-Type');
  next();
});

//登陆
app.post("/login", async (req, res) => {
  const { username, passwd } = req.body
  if (!username || !passwd) {
    res.json({
      "result": "Failed"
    })
    return
  }
  console.log('用户' + username + '尝试登录');
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

//获取自由录入数据
app.get("/iTUserSelfMission", async (req, res) => {
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
  //发送数据，读取redis
  let msg = `<?xml version="1.0" encoding="UTF-8"?><SOAP><MSGTYPE>000016</MSGTYPE><ACCOUNT>${id}</ACCOUNT><BEGINDATE>2021-06-13</BEGINDATE><ENDDATE>${time.format(new Date(), 'YYYY-MM-DD')}</ENDDATE></SOAP>`
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
//上传自由录入数据
app.post("/iTUserSelfMission", async (res, req) => {
  console.log('有人上传新表单');
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
//删除自由录入数据
app.delete("/iTUserSelfMission", async (req, res) => {
  const { msgID } = req.body
  if (!msgID) {
    res.json({
      "result": "Failed"
    })
    return
  }
  console.log(msgID+"删除数据");
  let result = await deliTUserSelfMission(msgID)
  if (result["SOAP"]["MSGTYPE"][0] === "000015" && result["SOAP"]["DATAQUERYREPLY"][0] === "1") {
    res.json({
      "result": "OK"
    })
  } else {
    res.json({
      "result": "FAILED"
    })
  }

})
async function deliTUserSelfMission(msgID) {
  let sock = new zmq.Request()
  let msg = `<?xml version="1.0" encoding="UTF-8"?>
  <SOAP><MSGTYPE>000024</MSGTYPE><ORDERID>${msgID}</ORDERID
  ></SOAP>`
  sock.connect(`tcp://${serverUrl}:${port}`)
  await sock.send(msg)
  let result_str = (await sock.receive()).toString()
  let result = await parseStringPromise(result_str)
  return result
}



//获取上报录入数据
app.get("/iTUserMission", async (req, res) => {
  const { userId } = req.query
  if (userId == null) {
    res.json({
      "result": "failed"
    })
    return
  }
  let result = await read_redisITUserMission(userId)
  res.json(result)
})
async function read_redisITUserMission(id) {
  const xRead = promisify(client.xread).bind(client)
  let stream = await xRead("COUNT", 100, "STREAMS", `OPFAULTORDER`, "0-0")
  let result = []
  if (stream) {
    // let stream_name = stream[0][0]
    let stream_data = stream[0][1]
    for (stream_item of stream_data) {
      let item_data = stream_item[1]
      let item_json = {}
      for (let i = 0; i < item_data.length; i += 2) {
        item_json[item_data[i]] = item_data[i + 1]
      }
      if(item_json["opuserid"] != id) continue
      result.push(item_json)
    }
  }
  return result
}

//获取可选业务类型
app.get("/getTypeList", async (req, res) => {
  res.json({
    "Data": [
      "His系统",
      "手术麻醉系统",
      "电子病历",
      "打印机",
      "windows系统",
      "电脑设备",
      "网络",
      "弱电",
      "行政沟通",
      "其他"]
  })
})





//客户端上报内容数据获取
//获取上报录入数据
app.get("/Client", async (req, res) => {
  const { userId } = req.query
  if (userId == null) {
    res.json({
      "result": "failed"
    })
    return
  }
  let result = await read_redisClient(userId)
  res.json(result)
})
async function read_redisClient(id) {
  const xRead = promisify(client.xread).bind(client)
  let stream1 = await xRead("COUNT", 100, "STREAMS", `SDFAULTORDER`, "0-0")
  let stream2 = await xRead("COUNT", 100, "STREAMS", `SDFAULTORDERDONE`, "0-0")
  let stream3 = await xRead("COUNT", 100, "STREAMS", `SDFAULTORDERHANDLED`, "0-0")
  let stream4 = await xRead("COUNT", 100, "STREAMS", `OPFAULTORDER`, "0-0")
  let result = []
  if (stream1) {
    // let stream_name = stream[0][0]
    let stream_data = stream1[0][1]
    for (stream_item of stream_data) {
      let item_data = stream_item[1]
      let item_json = {}
      for (let i = 0; i < item_data.length; i += 2) {
        item_json[item_data[i]] = item_data[i + 1]
      }
      if(item_json["userid"] != id) continue
      result.push(item_json)
    }
  }
  if (stream2) {
    // let stream_name = stream[0][0]
    let stream_data = stream2[0][1]
    for (stream_item of stream_data) {
      let item_data = stream_item[1]
      let item_json = {}
      for (let i = 0; i < item_data.length; i += 2) {
        item_json[item_data[i]] = item_data[i + 1]
      }
      if(item_json["userid"] != id) continue
      result.push(item_json)
    }
  }
  if (stream3) {
    // let stream_name = stream[0][0]
    let stream_data = stream3[0][1]
    for (stream_item of stream_data) {
      let item_data = stream_item[1]
      let item_json = {}
      for (let i = 0; i < item_data.length; i += 2) {
        item_json[item_data[i]] = item_data[i + 1]
      }
      if(item_json["userid"] != id) continue
      result.push(item_json)
    }
  }
  if (stream4) {
    // let stream_name = stream[0][0]
    let stream_data = stream4[0][1]
    for (stream_item of stream_data) {
      let item_data = stream_item[1]
      let item_json = {}
      for (let i = 0; i < item_data.length; i += 2) {
        item_json[item_data[i]] = item_data[i + 1]
      }
      if(item_json["userid"] != id) continue
      result.push(item_json)
    }
  }
  return result
}



app.listen(8081)
console.log('服务器开始运作');
