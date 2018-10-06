import React from 'react';
import ReactDOM from 'react-dom';

import {Provider} from 'react-redux';
import {createStore, applyMiddleware} from 'redux';
import reduxThunk from 'redux-thunk';
import reducers from './reducers';

import { Switch, Route, Router } from 'react-router';
import createBrowserHistory from 'history/createBrowserHistory';

// CSS 
import '../node_modules/font-awesome/css/font-awesome.min.css';
import '../node_modules/materialize-css/dist/css/materialize.css';
import 'react-transitions/dist/animations.css';
import './assets/css/shared.css';

// basic user pages
import Home from './pages/Home';
import Trade from './pages/Trade';

const createStoreWithMiddleware = applyMiddleware(reduxThunk)(createStore);
const history = createBrowserHistory();

ReactDOM.render(
  <Provider store={createStoreWithMiddleware(reducers)}>
    <Router history={history}>

      <Switch>
        <Route exact path='/' component={ Home } />
        <Route exact path='/trade' component={ Trade } />
      </Switch>

    </Router>
  </Provider>
  ,document.getElementById('app')
);