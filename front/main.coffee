import React from 'react'
import ReactDOM from 'react-dom'
import { observer } from 'mobx-react'
import { BrowserRouter as Router, Route } from 'react-router-dom'

import { Index } from './pages/index'

App = observer () ->
  return <div className="main">
    <Router>
      <Route path="/">
        <Index />
      </Route>
    </Router>
  </div>


ReactDOM.render <App />, document.getElementById 'root'
