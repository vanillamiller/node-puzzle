fs = require 'fs'

exports.countryIpCounter = (countryCode, cb) ->
	return cb() unless countryCode
  counter = 0
	stream = fs.createReadStream "#{__dirname}/../data/geo.txt"
  # stream.setEncoding 'utf8'

	stream.on 'data', (chunk) -> 
		data = chunk.toString().split '\n'
    for line in data when line
	    line = line.split '\t'
      if line[3] == countryCode then counter += +line[1] - +line[0]

  stream.on 'end' () ->
    cb null, counter
  stream.on 'error' (err) ->
    cb err, null
  
	# fs.readFile "#{__dirname}/../data/geo.txt", 'utf8', (err, data) ->
	# 	if err then return cb err

	# 	data = data.toString().split '\n'
	# 	counter = 0

	# 	for line in data when line
	# 	  line = line.split '\t'
	# 		# GEO_FIELD_MIN, GEO_FIELD_MAX, GEO_FIELD_COUNTRY
	# 		# line[0],       line[1],       line[3]

	# 		if line[3] == countryCode then counter += +line[1] - +line[0]

	#   cb null, counter
