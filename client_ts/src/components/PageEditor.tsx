import React from "react";
import axios from "axios";
import SideBar from "./SideBar";
import EditingContainer from "./EditingContainer";

import Editor from "rich-markdown-editor";

type PageEditorProps = {
    children?: React.ReactNode;
    host : string;
}


const exampleText:string = ""

const PageEditor = ({host, children} : PageEditorProps) => 
{
    const reference = React.useRef(null);
    
    const [readOnly, setReadOnly] = React.useState(false);
    const [status, setStatus] = React.useState<string>("")
    const [value, setValue] = React.useState();
    const [content, setContent] = React.useState("");
    const [pageName, setPageName] = React.useState<string>("");
    const [path, setPath] = React.useState("");
    const [dark, setDark] = React.useState( localStorage.getItem("dark") === "enabled");
    const [pages, setPages] = React.useState<{ key: string; directory: string; value: string }[][]>();
  
    const setPagesFromBackend = async (): Promise<void> => {
      await axios.get(`${host}/list${path!}`)
      .then((res) => setPages(res.data));
    };

    const setContentFromBackend = async (path: string): Promise<void> => {

      if (path != "" ) {
            await axios.get(`${host}/list/blob/main${path.slice(0, path.length-1)}.md`)
            .then((res) => setContent(String(res.data)));
        }
    };

    const handleToggleReadOnly = (): void => { setReadOnly(!readOnly); };

    const handleToggleDark = (): void => {
      setDark(!dark);
      localStorage.setItem("dark", dark ? "enabled" : "disabled");
      console.log(localStorage.getItem("dark"), dark)
    };

    const deletePage = () => {
      axios.delete(`${host}/list/blob/main/${pageName}`)
      .then(() => setStatus("Страница удалена"))
    };

    const update_path = (file: string, index: number): void => {
      let new_path: string = "/";
      for ( let loc_index: number = 0; loc_index < path.split("/").length && loc_index < index + 1; loc_index++ ) {
        if (path.split("/")[loc_index] !== "") new_path += path.split("/")[loc_index] + "/";
      }
      new_path += file.split(".")[0] + "/";
      setPath(`${new_path}`);
      setContentFromBackend(new_path)
    };

    const handleChange = () => {}
    const handleSaveValue = () => {};

    React.useEffect(() => { 
      setPagesFromBackend(); 
      setContentFromBackend(path)
    }, [path]);

    return (
      <>
        <div>
            {/* <StyledEditor ref={reference} /> */}
            <div className='App'>
                <SideBar
                    pages={pages}
                    path={path}
                    action={(pathValue: string, index: number) =>
                    update_path(String(pathValue), index)
                    }
                />
                <EditingContainer
                    readOnly={readOnly}
                    dark={dark}
                    pageName={pageName}
                    deletePage={() => deletePage()}
                    handleSaveValue={handleSaveValue}
                    handleToggleDark={handleToggleDark}
                    handleToggleReadOnly={handleToggleReadOnly}
                    action={setPagesFromBackend}
                >
                  
                <Editor
                    id="example"
                    readOnly={readOnly}
                    value={content}
                    defaultValue=""
                    placeholder="Document content goes here..."
                    onSave={options => console.log("Save triggered", options)}
                    onCancel={() => console.log("Cancel triggered")}
                    onChange={handleChange}
                    onClickLink={href => console.log("Clicked link: ", href)}
                    onClickHashtag={tag => console.log("Clicked hashtag: ", tag)}
                    onShowToast={message => window.alert(message)}
                    // onSearchLink={async (term: string) => {
                    //   console.log("Searched link: ", term);
                    // }}
                    dark={dark}
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
                    autoFocus
                    />
                   
                </EditingContainer>
            </div>
        </div>
        </>
    );
}

export default PageEditor