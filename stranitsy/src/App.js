import './App.css';
import React, {useState} from "react";
import ReactDOM from "react-dom";
import Editor from "rich-markdown-editor";
// import Sidebar from "./sidebar";
import ListPages from './components/ListPages';
import multiNavbar from './components/multiNavBar';
import { Router, Route } from 'react-router-dom';
import Page from './components/Page';
import { debounce } from "lodash";
import axios from 'axios';

const element = document.getElementById("root");
const main = ReactDOM.createRoot(document.getElementById('root'));
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

// export const Persisted = Template.bind({});
// Persisted.args = {
//   defaultValue:
//     localStorage.getItem("saved") ||
//     `# Persisted
  
// The contents of this editor are persisted to local storage on change (edit and reload)`,
//   onChange: debounce(value => {
//     const text = value();
//     localStorage.setItem("saved", text);
//   }, 250),
// };

const menuData = [
  {
    name: "home",
    url: "/"
  },
  {
    name: "manu 1",
    children: [
      {
        name: "manu 1.1",
        url: "/page/manu-1-1"
      }
    ]
  },
  {
    name: "manu 2",
    url: "/page/manu-2"
  },
  {
    name: "manu 3",
    children: [
      {
        name: "manu 3.1",
        url: "/page/manu-3-1"
      },
      {
        name: "manu 3.2",
        url: "/page/manu-3-2"
      },
      {
        name: "manu 3.3",
        children: [
          {
            name: "manu 3.3.1",
            url: "/page/manu-3-3-1"
          },
        ]
      }
    ]
  },
  {
    name: "manu 4",
    children: [
      {
        name: "manu 4.1",
        url: "/page/manu-4-1"
      },
      {
        name: "manu 4.2",
        url: "/page/manu-4-2"
      },
      {
        name: "manu 4.3",
        children: [
          {
            name: "manu 4.3.1",
            url: "/page/manu-4-3-1"
          },
          {
            name: "manu 4.3.2",
            url: "/page/manu-4-3-2"
          },
          {
            name: "manu 4.3.3",
            children: [
              {
                name: "manu 4.3.3.1",
                children: [
                  {
                    name: "manu 4.3.3.1.1",
                    url: "/page/manu-4-3-3-1-1"
                  }
                ]
              },
              {
                name: "manu 4.3.3.2",
                url: "/page/manu-4-3-3-2"
              }
            ]
          }
        ]
      }
    ]
  }
]

const defaultValue = savedText || exampleText;

var FileSaver = require('file-saver');

class App extends React.Component {

  constructor() {
    super();
    this.state = {file: ''};
  }

  state = {
    readOnly: false,
    dark: localStorage.getItem("dark") === "enabled",
    value: undefined,
    file: null,
    setFile: null
  };

  handleToggleReadOnly = () => {
    this.setState({ readOnly: !this.state.readOnly });
  };

  handleToggleDark = () => {
    const dark = !this.state.dark;
    this.setState({ dark });
    localStorage.setItem("dark", dark ? "enabled" : "disabled");
  };

  handleSaveValue = () => {
    const existing = localStorage.getItem("saved") || "";
    const value = `${existing}`;
    localStorage.setItem("saved", value);
    
    this.setState({ value });
    console.log(value)
  };

  handleChange = debounce(value => {
    const text = value();
    localStorage.setItem("saved", text);
  }, 250);
  
  saveFile = () => {
    var blob = new Blob([savedText], {
      type: "text/plain;charset=utf-8"
    });
    FileSaver.saveAs(blob, "File.md");
  }

  handleSave = () => {
    const { onSave } = this.props;
    if (onSave) {
      onSave({ done: false });
    }
  };

  
  handleChange = (event) => {
    this.setState.File(event.target.files[0])
  }

  handleSubmit = (event) => {
    event.preventDefault()
    const url = 'http://localhost:8080/uploadFile';
    const formData = new FormData();
    formData.append('file', this.state.file);
    formData.append('fileName', this.state.file.name);
    console.log(formData)
    const config = {
      headers: {
        'content-type': 'text/plain',
      },
    };
    axios.post(url, formData, config).then((response) => {
      console.log(response.data);
    })
  }

  
  render() {
    const { body } = document;
    if (body) body.style.backgroundColor = this.state.dark ? "#181A1B" : "#FFF";
    
    return (
      <React.Fragment>
        <div className='App'>

          <form onSubmit={this.handleSubmit}>
            <input type="file" onChange={this.handleChange}/>
          </form>

          <div className='sidebarSpace'>
            <ListPages/>
          </div>
          
          <div className='editorSpace'>
            <div>
              <br />
              <button type="button" onClick={this.saveFile}>Save file</button>

              <button type="button" onClick={this.handleToggleReadOnly}>
                {this.state.readOnly ? "Editable" : "Read only"}
              </button>{" "}
              <button type="button" onClick={this.handleToggleDark}>
                {this.state.dark ? "Light theme" : "Dark theme"}
              </button>{" "}
              <button type="button" onClick={this.handleSaveValue}>
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