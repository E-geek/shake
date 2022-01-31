import { h } from 'preact';

export VGap = ({ height, className }) =>
  height = (height or 1) * 16
  style =
    display: 'block'
    height: "#{height}px"
  return <div className={className} style={style} />
