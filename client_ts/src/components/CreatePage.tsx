import React from "react";
import axios from "axios";
type CreatePageProps = {
  action: () => void;
  children?: React.ReactNode;
};

const CreatePage = ({ children, action }: CreatePageProps) => {
  const host = "http://" + window.location.hostname + ":8080";
  const [title, setTitle] = React.useState<string>();
  const [userName, setUserName] = React.useState<string>();
  const [level, setLevel] = React.useState<number>();
  const [sNumber, setSNumber] = React.useState<string>();
  const [parentID, setParentID] = React.useState<string>();

  const handleChange = (event: React.FormEvent<HTMLInputElement>) => {
    switch (event.currentTarget.name) {
      case "title":
        setTitle(event.currentTarget.value);
        break;
      case "userName":
        setUserName(event.currentTarget.value);
        break;
      case "level":
        setLevel(+event.currentTarget.value);
        break;
      case "sNumber":
        setSNumber(event.currentTarget.value);
        break;
      case "parentID":
        setParentID(event.currentTarget.value);
        break;
    }
  };

  const handleSubmit = (event: React.SyntheticEvent) => {
    event.preventDefault();
    const page = {
      title: title,
      userName: userName,
      level: level,
      sNumber: sNumber,
      parentID: parentID,
    };
    axios.post(`${host}/list/createPage`, page).then((res) => {
      action();
    });
  };
  return (
    <>
      <div>
        <form onSubmit={handleSubmit}>
          <label>
            Название страницы:
            <input type='text' name='title' onChange={handleChange} />
          </label>
          <label>
            Имя пользователя:
            <input type='text' name='userName' onChange={handleChange} />
          </label>
          <label>
            Уровень страницы:
            <input type='text' name='level' onChange={handleChange} />
          </label>
          <label>
            Порядковый номер:
            <input type='text' name='sNumber' onChange={handleChange} />
          </label>
          <label>
            Родительская страница:
            <input type='text' name='parentID' onChange={handleChange} />
          </label>
          <button type='submit'>Создать</button>
        </form>
      </div>
    </>
  );
};
export default CreatePage;
