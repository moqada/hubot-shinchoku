# Description:
#   進捗どうですか
#
# Commands:
#   shinchoku - 進捗画像をランダムに返す
#   進捗 - 進捗画像をランダムに返す
#
# Author:
#   moqada

request = require 'request'
cheerio = require 'cheerio'

url = 'http://shinchokudodesuka.tumblr.com/random'
retries = 3

module.exports = (robot) ->
  robot.hear /(shinchoku|進捗)/i, (msg) ->
    post_shinchoku = (retry_left) ->
      request url: url, (err, res, body) ->
        $ = cheerio.load body
        imgUrl = $('#posts > div.photo img').attr 'src'
        if imgUrl
          msg.send imgUrl
        else if not retry_left
          msg.send 'No Image'
        else
          post_shinchoku retry_left-1
    post_shinchoku retries
