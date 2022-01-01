import React, { useEffect } from 'react'
import { observer } from 'mobx-react'
import { useHistory, useLocation } from 'react-router-dom'

import { useStores } from '../hooks/useStores'

import { Loading } from './loading'
import { Empty } from './empty'
import { Edit } from './edit'

import './index.styl'

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

  if listStore.loading or not listStore.isInit or not listStore.meta?.variants
    return <Loading />

  unless listStore.meta?
    return <>Data is miss</>

  if uiStore.isEdit
    return <Edit list={listStore.meta?.variants} />

  unless listStore.meta.variants.length
    return <Empty onCreate={=> uiStore.setEdit yes; return} />

  return <div className="index">
    <h1>{listStore.actual}</h1>
    <br />
    <br />
    <h4>{listStore.prev}</h4>
    <br />
    <br />
    <div onClick={=> listStore.next(); return}>Next</div>
    <br />
    <br />
    <div onClick={=> listStore.shake(); return}>Shake</div>
    <br />
    <br />
    <div onClick={=> uiStore.setEdit yes; return}>Edit</div>
  </div>
