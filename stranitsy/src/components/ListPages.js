import React from 'react';
import axios from 'axios';

export default class ListPages extends React.Component {
  state = {
    pages: []
  }

  componentDidMount() {
    axios.get(`http://localhost:8080/list`)
      .then(res => {
        const pages = res.data.split('\n');
        console.log(pages);
        this.setState({ pages });
      })
  }

  render() {
    return (
      <ul>
        {
          this.state.pages
            .map(person =>
              <li key={person.id}>{person.name}</li>
            )
        }
      </ul>
    )
  }
}