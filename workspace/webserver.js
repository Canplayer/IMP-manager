const express = require('express')
const path = require('path')
const app = express()

app.use(express.static(path.join(__dirname, '../build/web')))

app.listen(80, () => {
  console.log('App listening at port 80')
})