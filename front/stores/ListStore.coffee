import { makeAutoObservable, runInAction } from 'mobx'

import { generate, getList } from '../services/api'

export class ListStore
  isInit: no

  id: ''

  meta: null

  constructor: () ->
    makeAutoObservable @
    @meta =
      variants: []
      order: []
      pointer: 0
      prev: -1
    return

  setId: (id) ->
    @id = id
    return

  initDone: ->
    @isInit = yes
    return

  newList: ->
    listResponse = await generate()
    if listResponse.status isnt 200
      alert "We have problem: #{listResponse.error}"
      return
    runInAction =>
      { id, meta } = listResponse.data
      @id = id
      @meta = meta
      return
    return

  choseList: (id) ->
    @id = id
    listResponse = await getList id
    if listResponse.status isnt 200
      alert "We have problem: #{listResponse.error}"
      return
    runInAction =>
      @meta = listResponse.data.meta
      return
    return
