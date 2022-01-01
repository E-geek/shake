import React, { useEffect } from 'react'
import { observer } from 'mobx-react'
import { useHistory, useLocation } from 'react-router-dom'

import { useStores } from '../hooks/useStores'

export Index = observer ->
  { listStore, uiStore } = useStores()
  history = useHistory()
  location = useLocation()

  useEffect () ->
    unless listStore.isInit
      listStore.initDone()
      if location.pathname is '/'
        await listStore.newList()
        uiStore.setEdit yes
      else
        await listStore.choseList location.pathname.replace '/', ''
    return
  , [location.href, listStore.isInit]

  useEffect () ->
    if listStore.id and location.pathname isnt "/#{listStore.id}"
      history.push "/#{listStore.id}"
  , [listStore.id]

  return <>Hi</>
