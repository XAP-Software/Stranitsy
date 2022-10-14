import React from "react";
import CreatePage from "./CreatePage";

type EditingContainerProps = {
  children?: React.ReactNode;
  readOnly: boolean;
  dark: boolean;
  pageName: string;
  action: () => void;
  deletePage: (pageName: string) => void;
  handleSaveValue: () => void;
  handleToggleDark: () => void;
  handleToggleReadOnly: () => void;
};

const EditingContainer = ({
  readOnly,
  dark,
  pageName,
  children,
  action,
  deletePage,
  handleSaveValue,
  handleToggleDark,
  handleToggleReadOnly,
}: EditingContainerProps) => {
  return (
    <>
      <div className='editing-container'>
        <div className='space-button'>
          <div className='editing-buttons'>
            <br />
            <CreatePage action={action} />
            <button type='button' onClick={handleToggleReadOnly}>
              {readOnly ? "Редактировать" : "Только для чтения"}
            </button>{" "}
            <button type='button' onClick={handleToggleDark}>
              {dark ? "Светлая тема" : "Темная тема"}
            </button>{" "}
            <button type='button' onClick={handleSaveValue}>
              Сохранить
            </button>{" "}
            <button
              type='button'
              onClick={() => {
                deletePage(pageName);
              }}
            >
              Удалить страницу
            </button>
          </div>
          <br />
        </div>
        <div className='editorSpace'>
          {children}
        </div>
      </div>
    </>
  );
};

export default EditingContainer;
