import React from 'react';

export VGap = ({ height, className }) =>
  h = (height or 1) * 16
  style =
    display: 'block'
    height: "#{h}px"
  return <div className={className} style={style} />
