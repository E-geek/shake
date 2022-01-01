express = require('express')
router = express.Router()

router.get '/', (req, res) ->
  res.render 'index', {}
  return

router.get '/:listId', (req, res) ->
  res.render 'index', {id: req.params.listId}
  return

module.exports = router
