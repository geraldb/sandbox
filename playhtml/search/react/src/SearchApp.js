import React from 'react';
import Result from './Result.js';


export default class SearchApp extends React.Component {

  constructor(props) {
    super(props);
    this.state = {results: []};
  }


	componentDidMount() {
    const SEARCH = 'https://api.github.com/search/repositories';

    fetch(`${SEARCH}?q=factbook`)
       .then( res => res.json() )
       .then( json => {
             this.setState( { results: json && json.items || [] } );
            });
	}


	render() {
    const { results } = this.state;
    return(
			<div>
				<h1 style={{textAlign: "center"}}>GitHub Search Example</h1>
				<div className="list">
					{ results.map( result => (
						<Result result={result} />
					)) }
				</div>
			</div>
		);
	}

} // class SearchApp
