import React, { useEffect } from 'react'
import { observer } from 'mobx-react'

import { useStores } from '../hooks/useStores'

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

  save = ->
    await listStore.save variants: actualList.map ([, value]) => value
    editStore.drop()
    uiStore.setEdit no
    return

  return <div>
    <div>
      {actualList.map ([id, value]) =>
        <div key={id}>
          <input type="text" value={value} onChange={(e) => editStore.updateListItem(id, e.target.value); return} />
          <div onClick={=> editStore.removeListItem(id); return}>X</div>
        </div>
      }
      <br />
      <div onClick={save}>Save</div>
      <br />
      <div onClick={() => editStore.reset()}>Reset</div>
    </div>
  </div>
