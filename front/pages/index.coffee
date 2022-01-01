import React, { useEffect } from 'react'
import { observer } from 'mobx-react'
import { useHistory, useLocation } from 'react-router-dom'

import { useStores } from '../hooks/useStores'

import { VGap } from '../components/VGap'

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
    <h1 className="index__actual">{listStore.actual}</h1>
    <h4 className="index__prev">{listStore.prev}</h4>
    <div className="index__buttons">
      <div className="button" onClick={=> listStore.next(); return}>Next</div>
      <VGap height={8} />
      <div className="button button--orange" onClick={=> listStore.shake(); return}>Shake</div>
      <VGap height={4} />
      <div className="button" onClick={=> uiStore.setEdit yes; return}>Edit</div>
    </div>
  </div>
