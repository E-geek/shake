import React from 'react'
import { ListStore } from './ListStore'
import { UIStore } from './UIStore'
import { EditStore } from './EditStore'

editStore = new EditStore()
listStore = new ListStore()
uiStore = new UIStore()

export storesContext = React.createContext gap = {
  listStore
  uiStore
  editStore
}

window.T = gap
