import React from 'react'

export Empty = ({ onCreate }) ->
  return <div>
    This list empty.
    <br />
    <div onClick={onCreate}>Fill!</div>
  </div>
