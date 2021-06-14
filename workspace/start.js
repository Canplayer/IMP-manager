
// const net = require("net")
const zmq = require("zeromq");
const redis = require("redis");
const moment = require("moment")
const fs = require("fs")



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

    let msg = `<?xml version="1.0" encoding="UTF-8"?><SOAP><MSGTYPE>000016</MSGTYPE><ACCOUNT>01599</ACCOUNT><BEGINDATE>2021-05-23</BEGINDATE><ENDDATE>2021-06-06</ENDDATE></SOAP>`
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
const client = redis.createClient({
    host: "10.10.142.81"
});
async function add_fault_order() {
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
add_fault_order()
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