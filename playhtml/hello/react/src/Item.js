import React from 'react';


/*
  todo: convert to a function - why? why not?
 */

export default class Item extends React.Component {

  render() {
    const item = this.props.item;

    return(
<div style={{
		   padding: 10,
		   margin: 10,
		   background: 'white',
		   boxShadow: '0 1px 5px rgba(0,0,0,0.5)'
	   }}
     key={item.id}>
		  <p>{item.text}</p>
</div>);
  }

} // class Item
