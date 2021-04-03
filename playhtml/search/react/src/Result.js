import React from 'react';


/*
  todo: convert to a function - why? why not?
 */

export default class Result extends React.Component {

render() {
 const result = this.props.result;

 return(
	<div style={{
		padding: 10,
		margin: 10,
		background: 'white',
		boxShadow: '0 1px 5px rgba(0,0,0,0.5)'
	}}>
		<div>
			<a href={result.html_url} target="_blank">
				{result.full_name}
			</a>
			★<strong>{result.stargazers_count}</strong>
		</div>
		<p>{result.description}</p>
	</div>
);
}

} // class Result
