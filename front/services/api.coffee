import { request } from '../helpers/request'

export generate = ->
  return await request "/api/"

export getList = (id) ->
  return await request "/api/id/#{id}"

export saveList = ({ id, newPassword, pass, variants }) ->
  return await request "/api/save", { id, newPassword, pass, variants }
