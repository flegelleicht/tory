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
      <h2>Hello World!</h2>
    );
  }
}