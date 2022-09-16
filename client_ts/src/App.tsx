import React from "react";
import Editor from "rich-markdown-editor";
import axios from "axios";
import { BrowserRouter, Routes, Link, Route } from "react-router-dom";
import "./styles/App.css";

function App() {
  let host = "http://" + window.location.hostname + ":8080";
  const [readOnly, setReadOnly] = React.useState(false);
  const [dark, setDark] = React.useState(
    localStorage.getItem("dark") === "enabled"
  );
  const [value, setValue] = React.useState();
  const [content, setContent] = React.useState("");
  const [pageName, setPageName] = React.useState("");
  const [pages, setPages] = React.useState([]);
  const [path, setPath] = React.useState("");
  const setPagesFromBackend = async (): Promise<void> => {
    await axios.get(`${host}/list${path!}`).then((res) => {
      setPages(res.data);
    });
  };

  const setContentFromBackend = async (path: String): Promise<void> => {
    await axios.get(`${host}/list/blob/main${path}`).then((res) => {
      setContent(res.data);
    });
  };

  const handleToggleReadOnly = (): void => {
    setReadOnly(!readOnly);
  };

  const handleToggleDark = (): void => {
    setDark(!dark);
    localStorage.setItem("dark", dark ? "enabled" : "disabled");
  };
  React.useEffect(() => {
    setPagesFromBackend();
  }, [path]);
  if (
    localStorage.getItem("path") == null ||
    localStorage.getItem("path") === ""
  ) {
    localStorage.setItem("path", "/");
    setPath("/");
  }
  return (
    <>
      <ul>
        {pages.map(({ value, key }) => {
          return <li key={key}>{value}</li>;
        })}
      </ul>
    </>
  );
}

export default App;
