import React, { Component } from 'react';
import './Authentication.css';

export default class Authentication extends Component {
  constructor(props) {
    super(props);
    this.state = {
      user: '',
      pass: ''
    }
    this.submit = this.submit.bind(this);
  }

  submit(event) {
    event.preventDefault();
    this.props.onLogin(this.state);
  }

  render() {
    const loggedIn = this.props.loggedIn;
    return (
      <React.Fragment>
      { loggedIn === true ? 
        <button onClick={this.props.onLogout}>Abmelden</button>
      :
        <form onSubmit={this.submit}>
          <input 
            type="text"
            placeholder="Nutzer"
            value={this.user}
            onChange={(e) => this.setState({user: e.target.value})}
            />
          <input 
            type="password"
            placeholder="Passwort"
            value={this.pass}
            onChange={(e) => this.setState({pass: e.target.value})}
            />
          <input type="submit" value="Anmelden" />
        </form>
      }
      </React.Fragment>
    );
  }
}
