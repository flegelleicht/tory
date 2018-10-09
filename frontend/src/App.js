import React, { Component } from 'react';
import { BrowserRouter as Router, Route, Link } from 'react-router-dom';
import './App.css';
import { CreateEvent } from './CreateEvent'
import Authentication from './Authentication'

class App extends Component {
  constructor(props) {
    super(props);

    this.state = JSON.parse(window.localStorage.getItem('state'));
    if(!this.state) {
      this.state = {
        token: null,
        loggedIn: false,
        events: []
      }
      this.save();
    }

    fetch('http://localhost:4567/api/v1/public/events')
      .then(response => {
        response.json().then(events => { 
          this.setState({events: events });
        });
      })
      .catch(error => console.log(`Got error fetching all events: ${error}`));

    this.onLogin = this.onLogin.bind(this);
    this.onLogout = this.onLogout.bind(this);
  }

  save() {
    window.localStorage.setItem('state', JSON.stringify(this.state));
  }

  onLogin(credentials) {
    fetch('http://localhost:4567/api/v1/public/login', {
      method: 'POST',
      body: JSON.stringify({user: credentials.user, pass: credentials.pass})
    })
    .then(response => {
      if (response.ok) {
        response.json().then(json => {
          this.setState({
            token: json.token,
            loggedIn: true
          });
        });
      }
    })
    .catch((e) => {
      if(e.name === 'TypeError' && e.message.match(/NetworkError/)) {
         console.error(`Can’t connect, server seems to be down: ${e.message}`);
      }  
    });
  }

  onLogout() {
    this.setState({
      token: null,
      loggedIn: false
    });
  }

  render() {
    const events = this.state.events.map(e => <li key={e.id}>{e.name}</li>)
    return (
      <React.Fragment>
        <div id="login-bar">
          <Authentication
            loggedIn={this.state.loggedIn}
            onLogin={this.onLogin}
            onLogout={this.onLogout}
            />
        </div>
        <div id="events">
          <ul>
          {events}
          </ul>
        </div>
        <Router>
          <div>
            <Link to="/event/new">Neuer Event</Link>
            <Route path="/event/new" component={CreateEvent}/>
          </div>
        </Router>
      </React.Fragment>
    );
  }
}

export default App;
