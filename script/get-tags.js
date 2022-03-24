const { writeFileSync } = require('fs')
const cheerio = require('cheerio')
const { $fetch } = require('ohmyfetch')
const { join } = require('path')

const API = "aHR0cHM6Ly93d3cuZmF5dXFpMi54eXov"

;(async ()=> {

  const api = Buffer.from(API, "base64").toString()
  
  const body = await $fetch(api)

  const $ = cheerio.load(body)

  const data = Array.from($(".resou a")).map(item=> {
    /// get the type id
    const id = +$(item).attr("href").split("/")[2].split(".")[0]
    const text = $(item).text()
    return {
      id,
      text
    }
  })

  const path = join(__dirname, "../assets/buitln/tags.json")

  writeFileSync(path, JSON.stringify(data), 'utf-8')

})()