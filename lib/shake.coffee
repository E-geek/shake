shake = (array) ->
  # work with copy only
  array = array.slice 0
  j = array.length
  if j < 2
    return array
  while j
    i = Math.floor Math.random() * (j--)
    t = array[j]
    array[j] = array[i]
    array[i] = t
  return array

module.exports = { shake }
