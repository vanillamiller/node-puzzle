fs = require 'fs'

# FOR SOME REASON WOULD NOT COMPILE WITH
# REGULAR INDENTS...COULD ONLTY GET COFFEE SCRIPT
# COMPILE WITH SINGLE SPACE INDENTS
exports.countryIpCounter = (countryCode, cb) ->

 counter = 0
 tail = ""
 stream = fs.createReadStream "#{__dirname}/../data/geo.txt"
 stream.setEncoding "utf8"

 onData = (chunk) ->
  appendedChunk = tail + chunk.toString()
  data = appendedChunk.split '\r\n'

  if appendedChunk[appendedChunk.length - 1] != '\r\n'
    tail = data[data.length - 1]
    data.pop()

  for line in data when line
   line = line.split '\t'
   if line.length > 5
   if line[3] == countryCode then counter += +line[1] - +line[0]

  return

 stream.on 'data', onData
    
 stream.on 'end', () ->
  cb null, counter

 stream.on 'error', (err) ->
  cb err