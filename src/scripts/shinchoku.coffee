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

pattern = /(shinchoku|進捗)/i
reactionMode = process.env.HUBOT_SHINCHOKU_REACTION_MODE or 'hear'
url = 'http://shinchokudodesuka.tumblr.com/random'
retries = 3

module.exports = (robot) ->
  if reactionMode is 'respond'
    robot.respond pattern, (msg) ->
      sendImage msg
  else
    robot.hear pattern, (msg) ->
      sendImage msg

  sendImage = (msg) ->
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
