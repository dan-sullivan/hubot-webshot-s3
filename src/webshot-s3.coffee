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

# Builtin Profiles

profiles = {
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
  robot.respond /webshot (.*) (.*)/i, (res) ->
    res.reply "this will snap #{res.match[1]} using profile #{res.match[2]}"

  robot.respond /webshot list profiles/i, (res) ->
    res.reply "#{Object.keys(profiles).join(", ")}"


