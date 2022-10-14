import React from "react";
import PageEditor from "./components/PageEditor";

import "./styles/App.css";

function App() {
  let host = "http://" + window.location.hostname + ":8080";

  return <>
    <PageEditor host={host} />
  </>
}
export default App;