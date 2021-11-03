const express = require("express")
const zmq = require("zeromq")
const parseStringPromise = require('xml2js').parseStringPromise
const redis = require("redis")
const fs = require("fs")
const { promisify } = require("util")
const time = require("silly-datetime")
const axios = require("axios")


//const serverUrl = "10.10.142.81"  //测试服务器
const serverUrl = "10.10.170.191"  //正式服务器
const port = "5566"

const app = express()
app.use(express.json())

var cors = require('cors')
app.use(cors())
const multer = require('multer')
var uploads = multer({ storage: multer.memoryStorage() })

const client = redis.createClient({
  host: serverUrl
});
client.on('error', function (err) {
  if (err) {
    console.log('与redis服务器连接出现了异常报告');
    rej(err)
  } else {
    res(key)
  }
});


//外域访问
app.all('*', function (req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header('Access-Control-Allow-Methods', 'PUT,GET,POST,DELETE,OPTIONS');
  res.header("Access-Control-Allow-Headers", "X-Requested-With");
  res.header('Access-Control-Allow-Headers', 'Content-Type');
  console.log("ip = " + req.ip);
  next();
});

//-------------------------------------用户资料操作逻辑-----------------------------------------
//登陆
app.post("/login", async (req, res) => {
  const { username, passwd } = req.body
  console.log('用户' + username + '尝试登录' + passwd);
  if (!username || !passwd) {
    res.json({
      "result": "Failed"
    })
    return
  }
  let result = await login(username, passwd)
  console.log(result);
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

//注册
app.post("/register", async (req, res) => {
  const { id, username, department, phone, email, passwd } = req.body
  console.log("用户发起注册：" + id + username);
  if (!id || !username || !department || !phone || !email || !passwd) {
    res.json({
      "result": "Failed"
    })
    return
  }
  console.log('用户' + username + '尝试登录');
  let result = await register(id, username, department, phone, email, passwd)
  if (result["SOAP"]["MSGTYPE"][0] === "000004" && result["SOAP"]["LOGONREPLY"][0] === "1") {
    res.json({
      "result": result["SOAP"]["LOGONREPLY"][0]
    })
  } else {
    res.json({
      "result": "FAILED"
    })
  }

})
async function register(id, username, department, phone, email, passwd) {
  let sock = new zmq.Request()
  let msg = `<?xml version="1.0" encoding="UTF-8"?>
  <SOAP>
  <MSGTYPE>000003</MSGTYPE>
  <ACCOUNT>${id}</ACCOUNT>
	<USERNAME>${username}</USERNAME>
	<PASSWORD>${passwd}</PASSWORD>
  <AUTHORITY>1</AUTHORITY>
  <DEPARTMENT>${department}</DEPARTMENT>
	<PHONE>${phone}</PHONE>
	<EMAIL>${email}</EMAIL>
  </SOAP>
  `
  sock.connect(`tcp://${serverUrl}:${port}`)
  await sock.send(msg)
  let result_str = (await sock.receive()).toString()
  let result = await parseStringPromise(result_str)
  return result
}



//------------------------------------工程师自定义任务------------------------------------------

//获取自由录入数据
app.get("/iTUserSelfMission", async (req, res) => {
  const { userId } = req.query
  console.log("用户获取自由录入数据：" + userId);
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
  var t = new Date()
  var t_s = t.getTime()
  var t_old = new Date().setTime(t_s - 1000 * 60 * 60 * 24 * 30)


  //发送数据，读取redis
  let msg = `<?xml version="1.0" encoding="UTF-8"?><SOAP><MSGTYPE>000016</MSGTYPE><ACCOUNT>${id}</ACCOUNT><BEGINDATE>${time.format(t_old, 'YYYY-MM-DD')}</BEGINDATE><ENDDATE>${time.format(t, 'YYYY-MM-DD')}</ENDDATE></SOAP>`
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
  let stream = await xRead("COUNT", 1000, "STREAMS", `${id}_MATCHORDER`, "0-0")
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
app.post("/iTUserSelfMission", async (req, res) => {
  const data = req.body
  console.log('有人上传新表单' + data)
  try {
    let key = await iTUserSelfMissionDataIn(data)
    res.json({
      "result": "OK",
      "key": key
    })
  } catch (error) {
    res.json({
      "result": "FAILED",
    })
  }
})
function iTUserSelfMissionDataIn(data) {
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
  console.log(msgID + "删除数据");
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
  console.log("获取上报录入数据：" + userId);
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
  let stream = await xRead("COUNT", 1000, "STREAMS", `OPFAULTORDER`, "0-0")
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
      if (item_json["opuserid"] != id) continue
      result.push(item_json)
    }
  }
  return result
}




//---------------------------------------全局变量---------------------------------------

//获取可选业务类型
app.get("/getTypeList", async (req, res) => {
  console.log("获取可选业务类型");
  res.json({
    "Data": [
      "His系统",
      "手术麻醉系统",
      "电子病历",
      "windows系统",
      "其他软件",

      "打印机",
      "电脑设备",
      "网络",
      "弱电系统相关",
      "其他硬件",


      "行政沟通",
      "其他"]
  })
})

//获取工程师列表
app.get("/getEngineerInfo", async (req, res) => {
  console.log("获取工程师列表");
  let result = await getEngineerInfo_matchorder()
  if (result != null) {
    res.json(result)
  }
  else res.end()
})

async function getEngineerInfo_matchorder() {
  let xml2js = require('xml2js');
  const get = promisify(client.get).bind(client)
  let stream = await get("ENGINEERINFO")

  return new Promise((res, rej) => {
    xml2js.parseString(stream, { explicitArray: false }, function (err, json) {
      if (err) {
        rej(err)
      } else {
        let result = []
        json.EngineerInfo.Item.forEach(element => {
          //console.log(element.$);
          result.push(element.$)
        })
        res(result)
      }
    })
  })
}







//---------------------------------------故障上报---------------------------------------

//客户端上报内容数据获取
//获取上报数据
app.get("/Client", async (req, res) => {
  const { userId } = req.query
  console.log("客户端上报数据获取" + userId);
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
  let stream1 = await xRead("COUNT", 1000, "STREAMS", `SDFAULTORDER`, "0-0")
  let stream2 = await xRead("COUNT", 1000, "STREAMS", `SDFAULTORDERDONE`, "0-0")
  let stream3 = await xRead("COUNT", 1000, "STREAMS", `SDFAULTORDERHANDLED`, "0-0")
  let stream4 = await xRead("COUNT", 1000, "STREAMS", `OPFAULTORDER`, "0-0")
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
      if (item_json["userid"] != id) continue
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
      if (item_json["userid"] != id) continue
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
      if (item_json["userid"] != id) continue
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
      if (item_json["userid"] != id) continue
      result.push(item_json)
    }
  }
  return result
}

//故障报修上传
app.post("/Client", uploads.single("file"), async (req, res) => {
  console.log('有新的美团外卖订单');
  let { info } = req.body
  var file
  if (req.file != null) {
    file = req.file.buffer
    console.log("骑手上传了一个图片")
  }
  const data = info
  //console.log(req.file.buffer)
  try {
    let key = await add_fault_order(data, file)
    res.json({
      "result": "OK",
      "key": key
    })
  } catch (error) {
    res.json({
      "result": "FAILED",
    })
  }
})
async function add_fault_order(data, file) {

  let faultorder_name = `FAULTORDER`
  let args = [faultorder_name, "*"]

  Object.keys(data).forEach(key => {
    args.push(key)
    args.push(data[key])
  })

  return new Promise((res, rej) => {
    client.sendCommand(`XADD`, args, (err, key) => {
      if (err) {
        rej(err)
        console.error("出了点问题1" + err)
      } else {
        res(key)


        if (file != null) {
          let img = file.toString("base64")
          console.log("带了一张图片" + img.length);
          let image_key = `${key}_Img_Req`
          client.set(image_key, img, function (err) {

            if (err) {
              rej(err)
              console.error("出了点问题2" + err)
              client.end(true);
            } else {
              res(key)
            }
          })
        }

      }
    })
  })

}

//获取上报图片
app.get("/ClientPic", async (req, res) => {
  const { id } = req.query
  if (id == null) {
    res.json({
      "result": "failed"
    })
    return
  }
  let result = await clientPicQueryDataIn(id)
  if (result != null) res.end(result.toString('binary'), 'binary')
  else res.end()
})
/**
 * 查询录入信息
 * @param {string} id 
 */
async function clientPicQueryDataIn(id) {
  //发送数据，读取redis
  let msg = `<?xml version="1.0" encoding="UTF-8"?><SOAP><MSGTYPE>000005</MSGTYPE><ORDERID>${id}</ORDERID></SOAP>`
  let sock = new zmq.Request()

  sock.connect(`tcp://${serverUrl}:${port}`)
  await sock.send(msg)
  const result = await sock.receive()
  // TODO: parse xml for result
  return clientPicRead_matchorder(id)
}
async function clientPicRead_matchorder(id) {

  let image_key = `${id}_Img_Rep`

  const get = promisify(client.get).bind(client)
  let stream = await get(image_key)

  var result
  if (stream) {
    result = new Buffer.from(stream, 'base64')
  }
  return result


}







//---------------------------------------IT服务台---------------------------------------
//获取所有数据
app.get("/ITClient", async (req, res) => {
  console.log("IT服务台查询");
  const { type } = req.query
  if (type == null) {
    res.json({
      "result": "failed"
    })
    return
  }
  let result = await read_redisITClient(type)
  res.json(result)
})
async function read_redisITClient(type) {
  const xRead = promisify(client.xread).bind(client)
  let result = []
  let stream1 = await xRead("COUNT", 1000, "STREAMS", type, "0-0")
  if (stream1) {
    // let stream_name = stream[0][0]
    let stream_data = stream1[0][1]
    for (stream_item of stream_data) {
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

//将条目从未受理转至工程师受理
app.post("/ITClient_O2OP", async (req, res) => {
  let { id, opid } = req.body
  console.log(id + "任务被分配工程师" + opid)
  try {
    let key = await ITClient_O2OP(id, opid)
    if (key != 0) {
      res.json({
        "result": "OK",
        "key": key
      })
    } else {
      res.json({
        "result": "FAILED",
      })
    }
  } catch (error) {
    res.json({
      "result": "FAILED",
    })
  }
})
async function ITClient_O2OP(id, opid) {

  let opresult = await getEngineerInfo_matchorder()
 
  let opName,opPhone
  for(var i = 0;i<opresult.length;i++){
    if (opresult[i].id==opid){
      opName = opresult[i].name
      opPhone = opresult[i].phone
      break
    }
  }
  if(opName==null||opPhone==null) return 0;
console.log(opName,opPhone);
  




  const xRead = promisify(client.xread).bind(client)
  const xDel = promisify(client.xdel).bind(client)
  let stream1 = await xRead("COUNT", 1000, "STREAMS", `SDFAULTORDER`, "0-0")
  let result
  if (stream1) {
    let stream_data = stream1[0][1]
    for (stream_item of stream_data) {
      let item_data = stream_item[1]
      let item_json = {}
      for (let i = 0; i < item_data.length; i += 2) {
        item_json[item_data[i]] = item_data[i + 1]
      }
      if (item_json["original-streams-id"] != id) continue
      let item_id = stream_item[0]
      let count = await xDel(`SDFAULTORDER`, item_id)
      result = item_json
    }
  }
  if (result == null) return 0;

  result.faultprogress = "已分发"
  result.engineer = opName
  result.engineerphone = opPhone


  console.log(result);

  let faultorder_name = `OPFAULTORDER`
  let args = [faultorder_name, "*"]

  Object.keys(result).forEach(key => {
    args.push(key)
    args.push(result[key])
  })

  return new Promise((res, rej) => {
    client.sendCommand(`XADD`, args, (err, key) => {
      if (err) {
        rej(err)
        console.error("出了点问题1" + err)
      } else {
        res(key)

      }
    })
  })


}








//---------------------------------------没啥用增强体验的额外业务---------------------------------------
//获取图片
app.get("/GetPic", async (req, res) => {
  //res.sendFile('background.jpg' ,{ root: __dirname })

  picUrl = ""
  await axios.get('https://cn.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1', {
    responseType: 'json', //这里只能是arraybuffer，不能是json等其他项，blob也不行
  }).then(response => {
    console.log("https://cn.bing.com" + (response.data.images)[0].url);
    picUrl = "https://cn.bing.com" + (response.data.images)[0].url
  })


  axios.get(picUrl, {
    responseType: 'arraybuffer', //这里只能是arraybuffer，不能是json等其他项，blob也不行
  }).then(response => {
    res.set(response.headers) //把整个的响应头塞入更优雅一些
    res.end(response.data.toString('binary'), 'binary') //这句是关键，有两次的二进制转换
  })
})







app.listen(8081)
console.log('服务器开始运作');

const web = express()
const path = require('path')
web.use(express.static(path.join(__dirname, '../build/web')))
web.listen(80, () => {
  console.log('网页端开始运行')
})
