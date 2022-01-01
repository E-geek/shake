password = require './password'
{ shake } = require './shake'

checkPass = (list, pass, res) ->
  if list.pass
    if not pass or not password.check pass, list.pass
      res
        .status 403
        .send error: req.query.pass ? 'Password not correct' : 'Password required'
      return false
  return true

shakeOrder = (order, currentVariant = -1) ->
  order = shake order
  maxReShake = 40
  while maxReShake-- > 0 and order[0] is currentVariant
    order = shake order
  if maxReShake <= 0
    console.warn 'Shake strange: has duplicate'
  return order

module.exports = { checkPass, shakeOrder }
