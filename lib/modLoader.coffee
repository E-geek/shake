{ getOptions } = require 'loader-utils'
validateOptions = require 'schema-utils'

schema =
  type: 'object'
  properties:
    test: anyOf: [
      { type: 'string' }
      { instanceof: 'RegExp' }
    ]
    prepend: anyOf: [
      { type: 'string' }
      { instanceof: 'Function' }
    ]
    append: anyOf: [
      { type: 'string' }
      { instanceof: 'Function' }
    ]

module.exports = (source, map) ->
  options = getOptions(this)
  validateOptions schema, options, 'Modify loader'
  if !options
    @callback null, source, map
    return
  test = if options.test then new RegExp(options.test) else /(?:)/
  unless test.test(@resourcePath)
    @callback null, source, map
    return
  { prepend, append } = options;
  if prepend
    if typeof prepend == 'string'
      source = prepend + source
    else if typeof prepend == 'function'
      source = prepend(source, @resourcePath)
  if append
    if typeof append == 'string'
      source += append
    else if typeof append == 'function'
      source = append(source, @resourcePath)
  @callback null, source, map
  return
