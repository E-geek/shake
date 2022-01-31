import { h } from 'preact';

import './empty.styl'

export Empty = ({ onCreate }) ->
  return <div className="empty">
    <h1>This list empty.</h1>
    <div className="button" onClick={onCreate}>Fill!</div>
  </div>
