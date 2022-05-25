import React from 'react';
import axios from 'axios';

export default class ListPages extends React.Component {
  state = {
    pages: []
  }

  componentDidMount() {
    axios.get(`http://localhost:8080/list`)
      .then(res => {
        const pages = res.data;
        this.setState({ pages });
      })
  }

  render() {
    return (
      <ul>
        {
          this.state.pages
            .map(person =>
              // <Link to={`${person.url}`} activeClassName="active">{person.name}</Link>,
              <li>
                <a href={person.url}>{person.name}</a>
              </li>
              // <li key={person.name}>{person.name}</li>
            )
        }
      </ul>
    )
  }
}