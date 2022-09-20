import { BrowserRouter, Routes, Link, Route } from "react-router-dom";
import React from "react";

type SideBarProps = {
  action: (pathValue: String, index: number) => void;
  pages?: { key: String; directory: String; value: String }[][];
  path: String;
  children?: React.ReactNode;
};

type SideBarLevelProps = {
  action: (pathValue: String, index: number) => void;
  pages: { key: String; directory: String; value: String }[][];
  path: String[];
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
                <>
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
                      <SideBarLevel
                        pages={pages.slice(1)}
                        path={path.slice(1)}
                        action={action}
                        level={level + 1}
                      />
                    </>
                  ) : (
                    <></>
                  )}
                </>
              </li>
            );
          })}
        </ul>
      </>
    );
  }
};

const SideBar = ({ children, pages, path, action }: SideBarProps) => {
  const local_path: String[] = path.split("/");
  var level: number = 0;
  return (
    <>
      <div className='sidebarSpace'>
        <BrowserRouter>
          <ul>
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
          </ul>
        </BrowserRouter>
      </div>
    </>
  );
};

export default SideBar;
