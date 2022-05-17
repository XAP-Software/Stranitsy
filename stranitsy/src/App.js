import './App.css';
import React from "react";
import ReactDOM from "react-dom";
import Editor from "rich-markdown-editor";
import Sidebar from "./sidebar";
// import {Navigation} from 'react-minimal-side-navigation';
// import 'react-minimal-side-navigation/lib/ReactMinimalSideNavigation.css';

const element = document.getElementById("main");
const savedText = localStorage.getItem("saved");
const exampleText = `
# Hello Advocate Pod

## H2

### H3

#### H4

This is a markdown paragraph.

- unordered lists
- lists
[this is a link](google.com)
1. numbered
2. lists

\`\`\`
const foo = 'foo'; // code
\`\`\`

---

`;

const defaultValue = savedText || exampleText;

class App extends React.Component {
  state = {
    readOnly: false,
    dark: localStorage.getItem("dark") === "enabled",
    value: undefined,
  };

  handleToggleReadOnly = () => {
    this.setState({ readOnly: !this.state.readOnly });
  };

  handleToggleDark = () => {
    const dark = !this.state.dark;
    this.setState({ dark });
    localStorage.setItem("dark", dark ? "enabled" : "disabled");
  };

  handleUpdateValue = () => {
    const existing = localStorage.getItem("saved") || "";
    const value = `${existing}\n\nedit!`;
    localStorage.setItem("saved", value);

    this.setState({ value });
  };

  render() {
    const { body } = document;
    if (body) body.style.backgroundColor = this.state.dark ? "#181A1B" : "#FFF";

    return (
      <React.Fragment>
        <div className='App'>
          <div className='sidebarSpace'>
            <Sidebar
              
            />
          </div>
          <div className='editorSpace'>
            <div>
              <br />
              <button type="button" onClick={this.handleToggleReadOnly}>
                {this.state.readOnly ? "Editable" : "Read only"}
              </button>{" "}
              <button type="button" onClick={this.handleToggleDark}>
                {this.state.dark ? "Light theme" : "Dark theme"}
              </button>{" "}
              <button type="button" onClick={this.handleUpdateValue}>
                Update value
              </button>
            </div>
            <br />
            <br />
            <Editor
              id="example"
              readOnly={this.state.readOnly}
              value={this.state.value}
              defaultValue={defaultValue}
              onSave={options => console.log("Save triggered", options)}
              onCancel={() => console.log("Cancel triggered")}
              onChange={this.handleChange}
              onClickLink={href => console.log("Clicked link: ", href)}
              onClickHashtag={tag => console.log("Clicked hashtag: ", tag)}
              onCreateLink={title => {
                // Delay to simulate time taken for remote API request to complete
                return new Promise((resolve, reject) => {
                  setTimeout(() => {
                    if (title !== "error") {
                      return resolve(
                        `/doc/${encodeURIComponent(title.toLowerCase())}`
                      );
                    } else {
                      reject("500 error");
                    }
                  }, 1500);
                });
              }}
              onShowToast={message => window.alert(message)}
              onSearchLink={async term => {
                console.log("Searched link: ", term);
              }}
              uploadImage={file => {
                console.log("File upload triggered: ", file);

                // Delay to simulate time taken to upload
                return new Promise(resolve => {
                  setTimeout(
                    () => resolve("https://loremflickr.com/1000/1000"),
                    1500
                  );
                });
              }}
              dark={this.state.dark}
              autoFocus
            />
          </div>
        </div>
      </React.Fragment>
    );
  }
}

if (element) {
  ReactDOM.render(<App />, element);
}

export default App;