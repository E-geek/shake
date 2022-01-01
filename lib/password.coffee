crypto = require 'crypto'

hash = (pass) ->
  h = crypto.createHash 'sha256'
  return h
    .update "Snjcn92^61ij#{pass}c*2+ирс(())цырфнп"
    .digest 'base64'

check = (pass, stored) ->
  return hash(pass) is stored

module.exports = { hash, check }
