assert = require 'assert'
WordCount = require '../lib'


helper = (input, expected, done) ->
  pass = false
  counter = new WordCount()

  counter.on 'readable', ->
    return unless result = this.read()
    assert.deepEqual result, expected
    assert !pass, 'Are you sure everything works as expected?'
    pass = true

  counter.on 'end', ->
    if pass then return done()
    done new Error 'Looks like transform fn does not work'

  counter.write input
  counter.end()


describe '10-word-count', ->

  it 'should count a single word', (done) ->
    input = 'test'
    expected = words: 1, lines: 1
    helper input, expected, done

  it 'should count words in a phrase', (done) ->
    input = 'this is a basic test'
    expected = words: 5, lines: 1
    helper input, expected, done

  it 'should count quoted characters as a single word', (done) ->
    input = '"this is one word!"'
    expected = words: 1, lines: 1
    helper input, expected, done

  it 'should count camel case as multiple words', (done) ->
    input = 'hi there BigFella'
    expected = words: 4, lines: 1
    helper input, expected, done
  
  it 'should handle lowercase camel case as multiple words', (done) ->
    input = 'hi there bigFella'
    expected = words: 4, lines: 1
    helper input, expected, done

  it 'should not count invalid characters', (done) ->
    input = 'hi there An&*!'
    expected = words: 2, lines: 1
    helper input, expected, done
 
  it 'should count lines correctly', (done) ->
    input = 'hi \n there \n AdSlot'
    expected = words: 4, lines: 3
    helper input, expected, done

  it 'count anything between quotes as legit', (done) ->
    input = '"709873 *&(** AAA" is nonsense'
    expected = words: 3, lines: 1
    helper input, expected, done
  # !!!!!
  # Make the above tests pass and add more tests!
  # !!!!!
