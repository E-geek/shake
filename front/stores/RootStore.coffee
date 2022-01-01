import React from 'react'
import { ListStore } from './ListStore'
import { UIStore } from './UIStore'

listStore = new ListStore()
uiStore = new UIStore()

export storesContext = React.createContext {
  listStore
  uiStore
}
