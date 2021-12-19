express = require('express')
router = express.Router()
db = require '../lib/db'

### GET home page. ###

router.get '/', (req, res, next) ->
  lists = await db.List.findAll()
  res.render 'index', count: lists.length
  return
module.exports = router
