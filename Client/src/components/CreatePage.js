import React from 'react';
import axios from 'axios';

let host = 'http://' + window.location.hostname + ':8080';

export default class CreatePage extends React.Component {
    state = {
        title: '',
        userName: ''
    };

    handleChange = event => {
        this.setState({ [event.target.name]: event.target.value });
        console.log(event.target.value, 'something')
        console.log(this.state.title, 'nothing')

    };

    handleSubmit = event => {
        event.preventDefault();

        const page = {
            title: this.state.title,
            userName: this.state.userName 
        };
        axios.post(`${host}/list/createPage`, page)
            .then(res => {
                console.log(res.data);
            })
    }

    render() {
        return (
          <div>
            <form onSubmit={this.handleSubmit}>
              <label>
                Название страницы:
                <input type="text" name="title" onChange={this.handleChange} />
              </label>
              <label>
                Имя пользователя:
                <input type="text" name="userName" onChange={this.handleChange} />
              </label>
              <button type="submit">Создать</button>
            </form>
          </div>
        )
    }
}