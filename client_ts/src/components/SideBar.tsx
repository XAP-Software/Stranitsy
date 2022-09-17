import { BrowserRouter, Routes, Link, Route } from "react-router-dom";
import React from "react";

type SideBarProps = {
  action: (key: String) => void;
  pages: {
    key: String;
    directory: String;
    value: String;
  }[];
  children?: React.ReactNode;
};

const SideBar = ({ children, pages, action }: SideBarProps) => {
  return (
    <>
      <BrowserRouter>
        <ul>
          {pages.map(({ value, key }) => {
            return (
              <li key={String(key)}>
                <Link
                  className='a-sidebar'
                  onClick={() => {
                    action(key);
                  }}
                  to={String(key)}
                >
                  {value}
                </Link>
              </li>
            );
          })}
        </ul>
      </BrowserRouter>
    </>
  );
};

export default SideBar;
