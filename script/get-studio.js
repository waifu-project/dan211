// https://jav.guru/jav-studio-list/
// https://www4.javxxx.me/studios/
// https://javrave.club/studio/
// https://fbjav.com/studios-list/

const cheerio = require('cheerio');
const { writeFileSync } = require('fs');
const { $fetch } = require('ohmyfetch');
const { join } = require('path');

const API = "aHR0cHM6Ly9qYXYuZ3VydS9qYXYtc3R1ZGlvLWxpc3Qv"

;(async ()=> {

  const api = Buffer.from(API, "base64").toString()
  
  const body = await $fetch(api)

  const $ = cheerio.load(body)

  const data = Array.from($(".cat-item")).map(item=> {
    return $(item).find("a").text()
  })

  var _path = join(__dirname, "../assets/buitln/av_studios.json")

  writeFileSync(_path, JSON.stringify(data), 'utf-8')

})()