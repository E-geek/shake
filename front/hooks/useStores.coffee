import { useContext } from 'preact/hooks';
import { storesContext } from '../stores/RootStore'

export useStores = () => useContext storesContext
