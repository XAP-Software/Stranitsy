import React from "react";
import Editor from "rich-markdown-editor";
import axios from "axios";
import SideBar from "./components/SideBar";
import EditingContainer from "./components/EditingContainer";
import "./styles/App.css";
import { nextTick } from "process";

function App() {
  let host = "http://" + window.location.hostname + ":8080";
  const [readOnly, setReadOnly] = React.useState(false);
  const [dark, setDark] = React.useState(
    localStorage.getItem("dark") === "enabled"
  );
  const [value, setValue] = React.useState();
  const [content, setContent] = React.useState("");
  const [pageName, setPageName] = React.useState("");
  const [pages, setPages] =
    React.useState<{ key: String; directory: String; value: String }[][]>();
  const [path, setPath] = React.useState("");

  const setPagesFromBackend = async (): Promise<void> => {
    await axios.get(`${host}/list${path!}`).then((res) => {
      setPages(res.data);
    });
  };

  const updateFileTree = (
    pageResult: { key: String; directory: String; value: String }[]
  ): void => {
    const path_array = path.split("/");
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

  const test_action = (key: string) => {
    setContent(key);
  };
  const handleSaveValue = () => {};
  const deletePage = (pageName: string) => {};
  const update_path = (file: string, index: number): void => {
    let new_path: string = "/";
    for (
      let loc_index: number = 0;
      loc_index < path.split("/").length && loc_index < index + 1;
      loc_index++
    ) {
      if (path.split("/")[loc_index] !== "")
        new_path += path.split("/")[loc_index] + "/";
      console.log(loc_index);
    }
    new_path += file.split(".")[0] + "/";
    setPath(`${new_path}`);
  };
  React.useEffect(() => {
    setPagesFromBackend();
  }, [path]);
  return (
    <>
      <div className='App'>
        <SideBar
          pages={pages}
          path={path}
          action={(pathValue: String, index: number) =>
            update_path(String(pathValue), index)
          }
        />
        <EditingContainer
          readOnly={readOnly}
          dark={dark}
          pageName={pageName}
          deletePage={(pageName: string) => deletePage(pageName)}
          handleSaveValue={handleSaveValue}
          handleToggleDark={handleToggleDark}
          handleToggleReadOnly={handleToggleDark}
        ></EditingContainer>
      </div>
    </>
  );
}

export default App;
