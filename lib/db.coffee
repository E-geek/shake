{ Sequelize, Model, DataTypes } = require 'sequelize'

db = new Sequelize "#{process.env.DB_TYPE}://#{process.env.DB_USER}:#{process.env.DB_PASS}@#{process.env.DB_HOST}/#{process.env.DB_NAME}"

List = db.define 'list', {
  id:
    type: DataTypes.UUID
    defaultValue: Sequelize.UUIDV4,
    primaryKey: true
  pass:
    type: DataTypes.STRING
    defaultValue: null
    default: null
  meta:
    type: DataTypes.JSONB
    defaultValue: {}
    default: null
  type:
    type: DataTypes.INTEGER
    defaultValue: 1
    default: 1
}, { sequelize: db, modelName: 'list' }

module.exports = { db, List }

await db.authenticate()
console.log 'DB connectied'
if process.env.DB_SYNC
  try
    await db.sync { alter: true }
    console.log 'DB sync done'
  catch err
    console.error err
    process.exit 1
else
  console.log 'DB sync skip'

