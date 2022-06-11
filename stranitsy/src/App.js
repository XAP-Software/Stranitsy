import './styles/App.css';
import React from "react";
import Editor from "rich-markdown-editor";
import { StyledEditor } from './components/editor';
import { debounce } from "lodash";
import axios from 'axios';
// import { parse } from 'jekyll-markdown-parser';
import { 
  BrowserRouter,
  Link
} from "react-router-dom";

const savedText = localStorage.getItem("saved");

const exampleText = `
# Hello this is example text

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
    pageName: ''
  };

  async componentDidMount () {
    await axios.get(`http://localhost:8080/list`)
      .then(res => {
        const pages = res.data;
        this.setState({ pages });
      });
    
    console.log(this.state.pages);

    // POST request using axios with async/await
  }

  async showContent (page) {
    await axios.get(`http://localhost:8080/list${page}`)
      .then(res => {
        var content = res.data;
        if (res.data === '') content = exampleText;
        this.setState({ content })
      });
    var pageName = page;
    this.setState({ pageName })
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
    console.log(existing);
    localStorage.setItem("saved", existing);
    
    this.setState({ value });
  };

  // Write file contents to local storage and upload to server for update
  handleChange = debounce(async value => {
    const text = value();
    localStorage.setItem("saved", text);

    const content = { content: text};
    console.log(this.state.pageName)
    const response = await axios.post(`http://localhost:8080/list/${this.state.pageName}`, content);
    this.setState({ contentId: response.data.id });
  }, 1000);

  render() {
    const { body } = document;
    if (body) body.style.backgroundColor = this.state.dark ? "#181A1B" : "#FFF";
    console.log(localStorage)

    return (
      <div>
        <StyledEditor
          dir={"auto"}
          ref={ref => (this.element = ref)}
        />
        <div className='App'>
          <div className='sidebarSpace'>
            <BrowserRouter>
              <ul>
                {
                  this.state.pages?.map(page => 
                    <li key={page.name}>
                      <Link className='a-sidebar' onClick={() => {this.showContent(page.url)}} to={page.url}>{page.name}</Link>
                    </li>
                    )
                }
              </ul>
            </BrowserRouter>
          </div>
          <div className='editing-container'>
            <div className='space-button'>
              <div className='editing-buttons'>
                <br />
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
            </div>
            <div className='editorSpace'>
              <Editor
                id="examples"
                readOnly={this.state.readOnly}
                value={this.state.content}
                defaultValue={defaultValue}
                placeholder="Document content goes here..."
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
        </div>
        </div>
    );
  }
}

export default App;