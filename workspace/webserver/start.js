
// const net = require("net")
const zmq = require("zeromq");
const redis = require("redis");
const moment = require("moment")
const fs = require("fs")
const { promisify } = require("util")


async function login(userid, passwd) {
    let sock = new zmq.Request()
    let msg = `<?xml version="1.0" encoding="UTF-8"?>
    <SOAP><MSGTYPE>000001</MSGTYPE><ACCOUNT>${userid}</ACCOUNT
    ><PASSWORD>${passwd}</PASSWORD><AUTHORITY>1</AUTHORITY></SOAP>`
    sock.connect("tcp://10.10.142.81:5566")
    // sock.connect("tcp://10.10.170.191:5566")
    await sock.send(msg)
    const result = await sock.receive()
    console.log(result.toString())

}
async function query(userid) {
    let sock = new zmq.Request()
    let msg = `<?xml version="1.0" encoding="UTF-8"?><SOAP><MSGTYPE>000008</MSGTYPE><ACCOUNT>${userid}</ACCOUNT></SOAP>`
    sock.connect("tcp://10.10.142.81:5566")
    // sock.connect("tcp://10.10.170.191:5566")
    await sock.send(msg)
    const result = await sock.receive()
    console.log(result.toString())

}
// 
// login("666","666")
// login("01599","199887")
async function update() {
    let sock = new zmq.Request()
    let msg = `<?xml version="1.0" encoding="UTF-8"?><SOAP><MSGTYPE>000010</MSGTYPE><ACCOUNT>666</ACCOUNT><USERNAME>666</USERNAME><DEPARTMENT>信息部</DEPARTMENT><PASSWORD>666</PASSWORD><AUTHORITY>1,2,3</AUTHORITY><PHONE>7777</PHONE><EMAIL>666</EMAIL></SOAP>`
    sock.connect("tcp://10.10.142.81:5566")
    // sock.connect("tcp://10.10.170.191:5566")
    await sock.send(msg)
    const result = await sock.receive()
    console.log(result.toString())

}
async function query() {
    let sock = new zmq.Request()

    let msg = `<?xml version="1.0" encoding="UTF-8"?><SOAP><MSGTYPE>000016</MSGTYPE><ACCOUNT>666</ACCOUNT><BEGINDATE>2021-05-23</BEGINDATE><ENDDATE>2021-06-25</ENDDATE></SOAP>`
    sock.connect("tcp://10.10.142.81:5566")
    // sock.connect("tcp://10.10.170.191:5566")
    await sock.send(msg)
    const result = await sock.receive()
    console.log(result.toString())

}
// query()

async function deal() {
    let sock = new zmq.Request()

    let msg = `<?xml version="1.0" encoding="UTF-8"?>
    <SOAP>
        <MSGTYPE>000012</MSGTYPE>
        <MSGQUEUE>SDFAULTORDER_20210530</MSGQUEUE>
        <MSGDEALQUEUE>SDFAULTORDERHANDLED_20210530</MSGDEALQUEUE>
        <MSGID>1622368821396-0</MSGID>
        <PREMSGID>0-0</PREMSGID>
        <ORIGINALMSGID>1622368821260-0</ORIGINALMSGID>
        <SDUSERID>666</SDUSERID>
        <OPUSERID>666</OPUSERID>
        <USERNAME>666</USERNAME>
        <PHONE>7777</PHONE>
        <SOLUTION>8</SOLUTION>
    </SOAP>`
    sock.connect("tcp://10.10.142.81:5566")

    await sock.send(msg)
    const result = await sock.receive()
    console.log(result.toString())
}
// deal()

async function deal() {
    let sock = new zmq.Request()

    let msg = `<?xml version="1.0" encoding="UTF-8"?>
    <SOAP>
        <MSGTYPE>000012</MSGTYPE>
        <MSGQUEUE>SDFAULTORDER_20210530</MSGQUEUE>
        <MSGDEALQUEUE>SDFAULTORDERHANDLED_20210530</MSGDEALQUEUE>
        <MSGID>1622368821396-0</MSGID>
        <PREMSGID>0-0</PREMSGID>
        <ORIGINALMSGID>1622368821260-0</ORIGINALMSGID>
        <SDUSERID>666</SDUSERID>
        <OPUSERID>666</OPUSERID>
        <USERNAME>666</USERNAME>
        <PHONE>7777</PHONE>
        <SOLUTION>8</SOLUTION>
    </SOAP>`
    sock.connect("tcp://10.10.142.81:5566")

    await sock.send(msg)
    const result = await sock.receive()
    console.log(result.toString())
}

async function add_fault_order() {
    // FAULTREPORTLBM_C
    let data = {
        "original-streams-id": "",
        "distribute-streams-id": "",
        "userid": "666",
        "opuserid": "",
        "sduserid": "",
        "department": "信息部",
        "person2contact": "666",
        "phone2contact": "7777",
        "faultdate": "2021-05-21",
        "faulttype": "His系统",
        "problemdescribe": "qq",
        "reportdate": "2021-05-30",
        "reporttime": "16:59:35",
        "engineer": "",
        "engineerphone": "",
        "faultprogress": "未处理",
        "solution": ""
    }

    let faultorder_name = `FAULTORDER_${moment().format('YYYYMMDD')}`
    let args = [faultorder_name, "*"]
    fs.readFile("./1.PNG", (err, img_data) => {
        let img = img_data.toString("base64")
        Object.keys(data).forEach(key => {
            args.push(key)
            args.push(data[key])
        })
        client.sendCommand(`XADD`, args, (err, key) => {
            let image_key = `${key}_Img_Req`
            client.set(image_key, img, () => {
                client.end(true)
            })
        })
    })

}
// add_fault_order()
/**
 * {
    "original-streams-id": "",
    "distribute-streams-id": "",
    "userid": "666",
    "opuserid": "",
    "sduserid": "",
    "department": "信息部",
    "person2contact": "666",
    "phone2contact": "7777",
    "faultdate": "2021-05-21",
    "faulttype": "His系统",
    "problemdescribe": "eleme",
    "reportdate": "2021-05-30",
    "reporttime": "16:59:35",
    "engineer": "",
    "engineerphone": "",
    "faultprogress": "未处理",
    "solution": ""
}
 */

async function datain() {
    let data = {
        "original-streams-id": "",
        "distribute-streams-id": "",
        "userid": "01599",
        "opuserid": "",
        "sduserid": "",
        "department": "信息部",
        "person2contact": "666",
        "phone2contact": "7777",
        "faultdate": "2021-05-20",
        "faulttype": "His系统",
        "problemdescribe": "wx",
        "reportdate": "2021-06-20",
        "reporttime": "16:59:35",
        "engineer": "",
        "engineerphone": "",
        "faultprogress": "未处理",
        "solution": "2337"
    }
    let table_name = "ORDERDATAIN"
    let args = [table_name, "*"]
    Object.keys(data).forEach(key => {
        args.push(key)
        args.push(data[key])
    })
    client.sendCommand("XADD", args, (err, key) => {
        console.log(key)
    })
}
// datain()

async function query_data_in(id) {
    let msg = `<?xml version="1.0" encoding="UTF-8"?><SOAP><MSGTYPE>000016</MSGTYPE><ACCOUNT>${id}</ACCOUNT><BEGINDATE>2021-06-13</BEGINDATE><ENDDATE>2021-06-27</ENDDATE></SOAP>`
    let sock = new zmq.Request()

    sock.connect("tcp://10.10.142.81:5566")
    // sock.connect("tcp://10.10.170.191:5566")
    await sock.send(msg)
    const result = await sock.receive()
    read_matchorder(id)
}
const client = redis.createClient({
    host: "10.10.142.81"
});
// query_data_in("666")
async function read_matchorder(id) {
    const xRead = promisify(client.xread).bind(client)
    const xDel = promisify(client.xdel).bind(client)
    let stream = await xRead("COUNT", 100, "STREAMS", `${id}_MATCHORDER`, "0-0")
    if (stream) {
        let stream_name = stream[0][0]
        let stream_data = stream[0][1]
        for (stream_item of stream_data) {
            let item_id = stream_item[0]
            let count = await xDel(`${id}_MATCHORDER`, item_id)
            console.log("DELTED amount:", count)
            let item_data = stream_item[1]
            let item_json = {}
            for (let i = 0; i < item_data.length; i += 2) {
                item_json[item_data[i]] = item_data[i + 1]
            }
            console.log(item_id)
            console.log(item_json)
        }
    }
    client.end(true)
}


function dataIn(username){
    let data = {
        "original-streams-id": "",
        "distribute-streams-id": "",
        "userid": "666",
        "opuserid": "666",
        "sduserid": "",
        "department": "门诊",
        "person2contact": "某个人",
        "phone2contact": "",
        "faultdate": "2021-06-26",
        "faulttype": "His系统",
        "problemdescribe": "error",
        "reportdate": "2021-06-26",
        "reporttime": "21:59:35",
        "engineer": "某个人",
        "engineerphone": "",
        "faultprogress": "",
        "solution": "solutaion 111"
    }

    let dataInMap = `ORDERDATAIN`
    let args = [dataInMap, "*"]
    Object.keys(data).forEach(key => {
        args.push(key)
        args.push(data[key])
    })
    client.sendCommand(`XADD`, args, (err, key) => {
        console.log(key)
    })

}
dataIn("666")