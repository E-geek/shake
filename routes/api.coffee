express = require 'express'
password = require '../lib/password'
db = require '../lib/db'
{ checkPass, shakeOrder } = require '../lib/helpers'

r = express.Router()

getListPassById = ({ id, pass, res }) ->
  list = await db.List.findOne where: { id }
  unless list
    res
      .status 404
      .send error: 'Not found'
    return false
  return false unless checkPass list, pass, res
  return list

r.get '/', (req, res) ->
  list = db.List.build
    pass: null
    meta:
      variant: []
      order: []
      pointer: 0
      prev: -1
  try
    await list.save()
  catch err
    console.error err
    res
      .status 500
      .send error: 'Internal error'
    return
  res.send
    id: list.id
    meta: list.meta
  return

# QS:
# pass (optional) for password-protected
r.get '/id/:id', (req, res) ->
  list = await getListPassById
    id: req.params.id
    pass: req.query.pass
    res: res
  return unless list
  res.send list.meta
  return

# QS:
# id list,
# pass (optional)
r.get '/shake', (req, res) ->
  { id, pass } = req.query
  list = await getListPassById { id, pass, res }
  return unless list
  unless list.meta?.variants?
    res
      .status 500
      .send error: 'Meta is empty'
    return
  # if all right
  if list.meta.variant.length < 2
    list.meta.order = if list.meta.variant.length then [0] else []
    list.meta.pointer = 0
  else
    { variants, order, pointer, prev } = list.meta
    currentVariant = order[pointer]
    if order.length isnt variants.length
      order = variants.map (v, idx) -> idx
    pointer = 0
    order = shakeOrder order, currentVariant
    list.meta = { variants, order, pointer, prev }
  try
    await list.save()
  catch err
    res
      .status 500
      .send error: 'Internal error'
    return
  res.send list.meta
  return

# Body (json) id string list, newPassword (optional), variants string[]
r.post 'save', (req, res) ->
  body = if typeof req.body is 'string' then JSON.parse(req.body) else req.body
  unless body
    res
      .status 400
      .send error: 'Empty storage'
  { id, newPassword, pass, variants } = body
  list = await getListPassById { id, pass, res }
  return unless list
  gap = []
  order = []
  i = 0
  for variant in variants
    variant = variant.trim()
    if variant.length > 0
      gap.push
      order.push i++
  if newPassword
    list.pass = password.hash newPassword
  else if not newPassword and pass
    list.pass = null
  list.meta =
    variants: gap
    order: shakeOrder order
    pointer: 0
    prev: -1
  try
    await list.save()
  catch err
    res
      .status 500
      .send error: 'Internal error'
    return
  res.send list.meta
  return

# QS: id, pass
r.get '/next', (req, res) ->
  { id, pass } = req.query
  list = await getListPassById { id, pass, res }
  return unless list
  { order, pointer } = list.meta
  list.meta.prev = order[pointer]
  list.meta.pointer++
  if pointer >= list.meta.variants.length
    currentVariant = order[pointer]
    order = shakeOrder order, currentVariant
    list.meta.order = order
    list.meta.pointer = 0
  try
    await list.save()
  catch err
    res
      .status 500
      .send error: 'Internal error'
    return
  res.send list.meta
  return

module.exports = r
