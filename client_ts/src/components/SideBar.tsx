import { BrowserRouter, Routes, Link, Route } from "react-router-dom";
import React from "react";
import "../styles/SideBar.css";

type SideBarProps = {
  action: (pathValue: string, index: number) => void;
  pages?: { key: string; directory: string; value: string }[][];
  path: string;
  children?: React.ReactNode;
};

type SideBarLevelProps = {
  action: (pathValue: string, index: number) => void;
  pages: { key: string; directory: string; value: string }[][];
  path: string[];
  level: number;
};

const SideBarLevel = ({ path, action, pages, level }: SideBarLevelProps) => {
  if (pages! === undefined && pages![level] === undefined) return <></>;
  else {
    return (
      <>
        <ul>
          {pages![0].map(({ value, key }) => {
            return (
              <li key={String(key)}>
                
                  <Link
                    className='a-sidebar'
                    onClick={() => {
                      action(key, level);
                    }}
                    to={String(key.split(".")[0])}
                  >
                    {value}
                  </Link>
                  {path[1] !== undefined &&
                  path[1] !== "" &&
                  key.split(".")[0] === path[1] &&
                  pages[1] !== undefined &&
                  pages[0].length ? (
                    <>
                      <div className="sidebar_flex-container">
                        <div className="sidebar_emty-div"></div>
                        <SideBarLevel
                          pages={pages.slice(1)}
                          path={path.slice(1)}
                          action={action}
                          level={level+1}
                        />
                      </div>
                    </>
                  ) : (
                    <></>
                  )}
                
              </li>
            );
          })}
        </ul>
      </>
    );
  }
};

const SideBar = ({ children, pages, path, action }: SideBarProps) => {
  const local_path: string[] = path.split("/");
  var level: number = 0;
  return (
    <>
      <div className='sidebarSpace'>
        <BrowserRouter>
          
            {pages! === undefined ? (
              ""
            ) : (
              <SideBarLevel
                pages={pages!}
                path={local_path}
                action={action}
                level={level}
              />
            )}
        
        </BrowserRouter>
      </div>
    </>
  );
};

export default SideBar;
