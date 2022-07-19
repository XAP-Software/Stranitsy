import React from 'react';
import axios from 'axios';

let host = 'http://' + window.location.hostname + ':8080';

export default class CreatePage extends React.Component {
    state = {
        title: '',
        userName: '',
        level: 0,
        sNumber: 0,
        parentID: ''
    };

    handleChange = event => {
        this.setState({ [event.target.name]: event.target.value });
        console.log(typeof(event.target.value));
    };

    handleSubmit = event => {
        event.preventDefault();

        const page = {
            title: this.state.title,
            userName: this.state.userName,
            level: this.state.level,
            sNumber: this.state.sNumber,
            parentID: this.state.parentID
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
              <label>
                Уровень страницы:
                <input type="text" name="level" onChange={this.handleChange} />
              </label>
              <label>
                Порядковый номер:
                <input type="text" name="sNumber" onChange={this.handleChange} />
              </label>
              <label>
                Родительская страница:
                <input type="text" name="parentID" onChange={this.handleChange} />
              </label>
              <button type="submit">Создать</button>
            </form>
          </div>
        )
    }
}