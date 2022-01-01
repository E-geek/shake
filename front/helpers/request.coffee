export request = (url, body = null) ->
  data = null
  try
    options = method: 'GET'
    if body?
      options.method = 'POST'
      options.headers = { 'Content-Type': 'application/json;charset=utf-8' }
      options.body = JSON.stringify body
    res = await fetch url, options
    try
      data = await res.json()
    catch
      text = await res.text()
      data = error: "Parse error after response: #{res.status} #{text}"
  catch
    data = error: "Request to #{url} failed"
  return {
    status: res.status
    error: data?.error or null
    data: data or null
  }
