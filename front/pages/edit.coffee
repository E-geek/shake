import React, { useEffect } from 'react'
import { observer } from 'mobx-react'

import { useStores } from '../hooks/useStores'

import { VGap } from '../components/VGap'
import { HGap } from '../components/HGap'

import RemoveIcon from '../res/icons/remove.svg'

import "./edit.styl"

export Edit = observer ({ list }) ->
  { editStore, uiStore, listStore } = useStores()
  actualList = editStore.getListAsArray()

  useEffect =>
    editStore.edit list
  , []

  useEffect =>
    if actualList.length is 0 or actualList[actualList.length - 1][1]
      editStore.addListItem()
  , [ actualList ]

  back = ->
    editStore.drop()
    uiStore.setEdit no
    return

  save = ->
    await listStore.save variants: actualList.map ([, value]) => value
    editStore.drop()
    uiStore.setEdit no
    return

  return <div className="edit-wrapper">
    <div className="edit__back">
      <div className="edit__back-button" onClick={back}>⇠ Back</div>
    </div>
    <div className="edit">
      {actualList.map ([id, value]) =>
        <div className="edit__item" key={id}>
          <input type="text" value={value} onChange={(e) => editStore.updateListItem(id, e.target.value); return} />
          <HGap height={1} />
          <div className="edit__remove" onClick={=> editStore.removeListItem(id); return}>
            <RemoveIcon />
          </div>
        </div>
      }
      <VGap height={2} />
      <div className="edit__buttons">
        <div className="button button--orange" onClick={() => editStore.reset()}>Reset</div>
        <HGap height={2} />
        <div className="button" onClick={save}>Save</div>
      </div>
    </div>
  </div>
