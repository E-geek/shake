import { makeAutoObservable } from 'mobx'

uid = 8745

export class EditStore
  protect: no

  pass: ''

  passConfirm: ''

  actualList: null

  sourceList: null

  getListAsArray: () ->
    unless @actualList
      return []
    return [@actualList.entries()...]

  constructor: ->
    makeAutoObservable @
    return

  updateListItem: (id, value) ->
    @actualList.set(id, value)
    return

  addListItem: () ->
    @actualList.set(uid += 7, '')
    return

  removeListItem: (id) ->
    @actualList.delete(id)
    return

  setPass: (pass) ->
    @pass = pass
    return

  setPassConfirm: (passConfirm) ->
    @passConfirm = passConfirm
    return

  setProtect: (protect) ->
    @protect = protect
    return

  edit: (list) ->
    prepared = list.map (value) => [uid += 7, value]
    @actualList = new Map prepared.slice 0
    @sourceList = prepared
    return

  reset: ->
    @actualList = new Map @sourceList.slice 0
    return

  drop: ->
    @actualList = null
    @sourceList = null
    # no active
    @protect = no
    @pass = ''
    @passConfirm = ''
    return
