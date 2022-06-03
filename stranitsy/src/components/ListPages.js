import React from 'react';
import axios from 'axios';

export default function ListPages() {
  const [pages, setPages] = React.useState(null);

  React.useEffect(() => {
    axios.get('http://localhost:8080/list')
      .then(res => {
        setPages(res.data);
      });
  }, []);

  if (!pages) return 'Book is empty';

  return (
    <ul>
      {
        pages.map(person =>
          <li>
            <a href={person.url}>{person.name}</a>
          </li>
        )
      }
    </ul>
  )
}