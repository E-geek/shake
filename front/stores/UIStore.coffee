import { makeAutoObservable } from 'mobx'

export class UIStore
  isEdit: no

  constructor: () ->
    makeAutoObservable @
    return

  setEdit: (isEdit) ->
    @isEdit = isEdit
    return
