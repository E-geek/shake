import { h, render } from 'preact'
import { observer } from 'mobx-preact'
import { Router } from 'preact-router'

import { Index } from './pages/index'

import './res/css/main.styl'

App = observer  ->
  return <div className="main">
    <Router>
      <Index path="/" />
      <Index path="/:id" />
    </Router>
  </div>


render <App />, document.getElementById 'root'
