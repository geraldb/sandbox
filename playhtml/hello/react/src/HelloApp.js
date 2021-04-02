import React from 'react';
import Item from './Item.js';


export default class HelloApp extends React.Component {

  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
    this.handleClick  = this.handleClick.bind(this);
    this.state = {items: [], text: ''};

    this.maxLength = 160;
  }

  render() {
    const title = "Hello. What's Up?";

    return(
      <div>
        <h3>{title}</h3>

          <textarea className={this.isValid() ? 'valid' : 'invalid'}
                    rows="3" cols="84"
                    value={this.state.text} onChange={this.handleChange} />
          <span style={{color:this.hasCharsRemaining() ? 'green' : 'red'}}>
             {this.getCharsRemaining()}
          </span>
          <button disabled={!this.isValid()}
                  onClick={this.handleClick}>Publish</button>

        <div class="items">
					{ this.state.items.map( item => (
						<Item item={item} />
					)) }
				</div>
      </div>
    );
  }

  getCharsRemaining() {
    return this.maxLength - this.state.text.length;
  }

  hasCharsRemaining() {
    return this.getCharsRemaining() > 0;
  }

  isValid() {
    return this.state.text.length > 0 &&
           this.getCharsRemaining() >= 0;
  }

  handleChange(e) {
    this.setState({text: e.target.value});
  }

  handleClick(e) {
    e.preventDefault();
    var newItem = {
      text: this.state.text,
      id: Date.now()
    };
    this.setState( (prevState) => (
      // note: use unshift to prepend new items upfront (reverse chronological order)
      //   todo: find a better way
      prevState.items.unshift( newItem ),   // note: unshift returns array size (NOT array)
      {
        items: prevState.items,
        text: ''
      }));
  }

} // class HelloApp
