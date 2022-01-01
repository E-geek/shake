import { makeAutoObservable, runInAction } from 'mobx'

import { generate, getList, saveList, shakeList, nextInList } from '../services/api'

export class ListStore
  isInit: no

  id: ''

  meta: null

  actual: ''

  prev: ''

  loading: true

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

  setMeta: (meta) ->
    @meta = meta
    if meta? and meta.pointer? and meta.pointer >= 0 and meta.variants?.length > 0
      @actual = meta.variants[meta.order[meta.pointer]]
      if meta.prev >= 0
        @prev = meta.variants[meta.prev]
    return

  processResponse: (listResponse) ->
    if listResponse.status isnt 200
      alert "We have problem: #{listResponse.error}"
      return
    @setMeta listResponse.data
    @loading = false
    return

  newList: ->
    listResponse = await generate()
    if listResponse.status isnt 200
      alert "We have problem: #{listResponse.error}"
      return
    runInAction =>
      { id, meta } = listResponse.data
      @id = id
      @setMeta meta
      @loading = false
      return
    return

  choseList: (id) ->
    @id = id
    listResponse = await getList id
    @processResponse listResponse
    return

  save: ({ variants }) ->
    @loading = true
    listResponse = await saveList {
      id: @id
      variants: variants.filter (v) -> !!v.trim()
    }
    @processResponse listResponse
    return

  shake: ->
    @loading = true
    listResponse = await shakeList @id
    @processResponse listResponse
    return

  next: ->
    @loading = true
    listResponse = await nextInList @id
    @processResponse listResponse
    return

