# Description
#   Take a webshot of a site, upload to s3 and return the url
#
# Configuration:
#   HUBOT_AWS_ACCESS_KEY_ID="ACCESS_KEY"
#   HUBOT_AWS_SECRET_ACCESS_KEY="SECRET_ACCESS_KEY"
#   HUBOT_AWS_REGION="eu-west-1"
#   HUBOT_WEBSHOT_S3_BUCKET="my_image_bucket"
#   HUBOT_WEBSHOT_PROFILES="{'profile_name': {screenSize: {width: 320, height: 480},\
#   shotSize: {width: 320, height: 'all'}, userAgent:\
#   'Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.20 (KHTML, like Gecko) Mobile/7B298g'}"
#
# Commands:
#   hubot webshot <URL> <profile>
#   hubot webshot list profiles
#   hubot webshot describe <profile>
#
# Notes:
#   Uses the following packages
#
#   - https://www.npmjs.com/package/aws-sdk
#   - https://www.npmjs.com/package/webshot
#   -- https://www.npmjs.com/package/phantomjs
#   
#   profiles are options objects passed straight to node-webshot. See the docs there.
#
# Author:
#   Dan Sullivan

# Built-in Profiles

profiles = {
  "default":{}
  "mobile": {
    "screenSize": {
      "width": 320,
      "height": 480
    },
    "shotSize": {
      "width": 320,
      "height": "all"
    },
    "userAgent": "Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_2 like Mac OS X; en-us) AppleWebKit/531."
  }
}

module.exports = (robot) ->
  
  # Populate variables from environment variables
  aws_akid = process.env.HUBOT_AWS_ACCESS_KEY_ID
  aws_sk = process.env.HUBOT_AWS_SECRET_ACCESS_KEY
  aws_region = process.env.HUBOT_AWS_REGION
  aws_s3_bucket = process.env.HUBOT_WEBSHOT_S3_BUCKET
  # TODO: concat profiles if specified in env


  robot.respond /webshot (https?\:\/\/.*) (.*)/i, (res) ->
    webshot = require("webshot")
    AWS = require("aws-sdk")

    [url, profile] = res.match[1..2]
    datestamp = new Date
    datestamp = datestamp.toISOString().slice(0,10)
    psrandomstr = Math.random().toString(36).replace(/[^a-zA-Z0-9]+/g, "").slice(1,9)

    AWS.config.update({accessKeyId: aws_akid, secretAccessKey: aws_sk, region: aws_region});
    s3bucket = new AWS.S3 {params: {Bucket: aws_s3_bucket}}

    image_stream = webshot url, profiles[profile]

    image_buffers = []
    image_stream.on "data", (buffer) ->
      image_buffers.push buffer
    
    image_stream.on "error", (err) ->
      res.reply "Webshot error: " + err

    image_stream.on "end", () ->
      image_data = Buffer.concat(image_buffers);
      params = {Key: "#{datestamp}-#{psrandomstr}.png", Body: image_data, ContentType: "image/png"}
      s3bucket.upload params, (err, data) ->
        if err
          res.reply "S3 Upload error: " + err
        else
          res.reply data["Location"]

  robot.respond /webshot list profiles/i, (res) ->
    res.reply "#{Object.keys(profiles).join(", ")}"


  robot.respond /webshot describe (.*)/i, (res) ->
    if res.match[1] of profiles
      profile_desc = JSON.stringify(profiles[res.match[1]])
    else
      profile_desc = "Profile \"#{res.match[1]}\" not found"
    res.reply profile_desc

