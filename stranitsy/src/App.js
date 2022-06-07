import './App.css';
import React from "react";
import Editor from "rich-markdown-editor";
import { StyledEditor } from './components/editor';
import { debounce } from "lodash";
import axios from 'axios';
import { parse } from 'jekyll-markdown-parser';

const savedText = localStorage.getItem("saved");

// const exampleText = `
// # Hello Advocate Pod

// ## H2

// ### H3

// #### H4

// This is a markdown paragraph.

// - unordered lists
// - lists
// [this is a link](google.com)
// 1. numbered
// 2. lists

// \`\`\`
// const foo = 'foo'; // code
// \`\`\`

// ---

// `;

// const defaultValue = savedText || exampleText;

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
    content: '',
    pages: [],

  };

  componentDidMount () {
    axios.get(`http://localhost:8080/list`)
      .then(res => {
        const pages = res.data;
        this.setState({ pages })
      });
    
    console.log(this.state.pages)
  }

  showContent (page) {
    axios.get(`http://localhost:8080/list${page}`)
      .then(res => {
        // if (res.data === '') console.log('empty string')
        var content;
        if (res.data !== '') content = res.data;
        else content = '';
        this.setState({ content })
      });
  }

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
  };

  handleChanges = debounce(value => {
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
    this.setState({file: event.target.files[0]})
    console.log(this.setState({file: event.target.files[0]}))
  }

  onFileUpload = (page) => {
    
    const formData = new FormData();
  
    formData.append(
      "file",
      this.state.file,
      this.state.file.name
    );
  
    console.log(this.state.file);

    axios.post(`http://localhost:8080/updatedFile?key=${page}`, formData);
  };

  render() {
    const { body } = document;
    if (body) body.style.backgroundColor = this.state.dark ? "#181A1B" : "#FFF";
    console.log(this.state.content)
    
    return (
      <div>
        <StyledEditor
          dir={"auto"}
          ref={ref => (this.element = ref)}
        />
        <div className='App'>
          <div className='sidebarSpace'>
            <ul>
              {
                this.state.pages?.map(page => 
                    <li key={page.name}>
                      <button className='ul-button' onClick={() => {this.showContent(page.url)}}>
                        {/* <a href={page.url}>{page.name}</a> */}{page.name}
                      </button>
                    </li>
                  )
              }
            </ul>
          </div>
          
          <div className='editorSpace'>
            <div>
              <br />
              <div>
                <div>
                  <input type="file" onChange={this.handleChange} />
                  {this.state.pages?.map(page => 
                    <button key={page.name} onClick={() => {this.onFileUpload(page.name)}}>
                      {page.name}
                    </button>
                  )}
                </div>
              </div>
              {/* <button type="button" onClick={this.saveFile}>Save file</button> */}

              <button type="button" onClick={this.handleToggleReadOnly}>
                {this.state.readOnly ? "Editable" : "Read only"}
              </button>{" "}
              <button type="button" onClick={this.handleToggleDark}>
                {this.state.dark ? "Light theme" : "Dark theme"}
              </button>{" "}
              {/* <button type="button" onClick={this.handleSaveValue}>
                Update value
              </button> */}
            </div>
            <br />
            <br />
            <Editor
              id="examples"
              readOnly={this.state.readOnly}
              value={this.state.content}
              placeholder="Document content goes here..."
              onSave={options => console.log("Save triggered", options)}
              onCancel={() => console.log("Cancel triggered")}
              onChange={this.handleChanges}
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
        </div>
    );
  }
}

export default App;