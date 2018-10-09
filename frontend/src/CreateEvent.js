import React, { Component } from 'react';
import './CreateEvent.css';

export class CreateEvent extends Component {
  constructor(props) {
    super(props);
    this.state = {
      inputStart: new Date(),
      inputEnd: new Date(),
      inputActive: true,
      inputName: '',
      inputDescription: '',
      inputLink: ''
    }
  }
  
  onSubmit(event) {
    event.preventDefault();
    
  }
  
  render() {
    return (
      <form onSubmit={this.onSubmit}>
        <p>Hi!</p>
        <label for="dateStart">Startdatum:</label>
        <input type="datetime-local" 
          id="dateStart" 
          value={this.state.inputStart}
          onChange={(e) => this.setState({inputStart: e.target.value})} />
        <label for="dateEnd">Startdatum:</label>
        <input type="datetime-local" 
          id="dateEnd"
          value={this.state.inputEnd}
          onChange={(e) => this.setState({inputEnd: e.target.value})} />
      </form>
    );
  }
}
