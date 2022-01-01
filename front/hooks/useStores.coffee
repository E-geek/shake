import React from 'react'
import { storesContext } from '../stores/RootStore'

export useStores = () => React.useContext storesContext
