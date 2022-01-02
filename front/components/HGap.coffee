import React from 'react';

export HGap = ({ width, className }) =>
  w = (width or 1) * 16
  style =
    display: 'block'
    width: "#{w}px"
  return <div className={className} style={style} />
