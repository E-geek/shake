import { request } from '../helpers/request'

export generate = ->
  return await request "/api/"

export getList = (id) ->
  return await request "/api/id/#{id}"
