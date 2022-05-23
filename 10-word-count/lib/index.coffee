through2 = require 'through2'


module.exports = ->
  words = 0
  lines = 1
  tail = ""
  bytes = 0
  transform = (chunk, encoding, cb) ->

    camelRegex = /^[(a-z|A-Z)]+([A-Z][a-z0-9]+)+/
    camelDelim = /[A-Z]/g

    bytes += chunk.length

    appendedChunk = tail + chunk.toString()
    newlineRegex = /\n/g
    newlines = appendedChunk.match(newlineRegex)
    lines += if newlines then newlines.length else 0;

    quoted = appendedChunk.match(/\\"|"(?:\\"|[^"])*"|(\+)/g) 
    words += if quoted then quoted.length else 0;

    if quoted
      for sentence in quoted  
        do ->
          appendedChunk = appendedChunk.replace(sentence, "")

    trailingQuote = appendedChunk.match /"/
    if trailingQuote
      tail = appendedChunk.slice trailingQuote.index
      appendedChunk = appendedChunk.slice 0, trailingQuote.index

    tokens = appendedChunk.split(' ')

    if !trailingQuote && !chunk[chunk.length - 1].match /\s/
      tail = tokens[tokens.length - 1]

    regex = /^[a-zA-Z0-9_.-]+$/

    legalTokens = tokens.filter (t) -> t.match regex
    words += legalTokens.length
    camelCase = legalTokens.filter (t) -> t.match camelRegex
    legalTokens.filter (t) -> !t.match camelRegex
    words += count for count in camelCase.map (t) -> if t[0] == t[0].toUpperCase then t.match(camelDelim).length else t.match(camelDelim).length + 1

    return cb()

  flush = (cb) ->
    this.push {words, lines}
    this.push null
    return cb()

  return through2.obj transform, flush
