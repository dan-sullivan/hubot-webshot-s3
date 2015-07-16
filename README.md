# hubot-webshot-s3

Take a webshot of a site, upload to s3 and return the url

See [`src/webshot-s3.coffee`](src/webshot-s3.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-webshot-s3 --save`

Then add **hubot-webshot-s3** to your `external-scripts.json`:

```json
[
  "hubot-webshot-s3"
]
```

## Sample Interaction

### Take a webshot

```
user1>> hubot webshot http://www.google.com default
hubot>> https://your_image_bucket/2015-07-16-abcd1234.png
```

### List Profiles

```
user1>> hubot webshot list profiles
hubot>> default, mobile 
```

### Describe a Profile

```
user1>> hubot webshot describe mobile
hubot>> {"screenSize":{"width":320,"height":480},"shotSize":{"width":320,"height":"all"},"userAgent":"Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_2 like Mac OS X; en-us) AppleWebKit/531."} 
```
