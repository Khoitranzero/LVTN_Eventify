"use client"
import React from "react";
import { DndProvider } from "react-dnd";
import { HTML5Backend } from "react-dnd-html5-backend";

const layout = ({ children }) => {
  return (
    <div>
      <DndProvider backend={HTML5Backend}>{children}</DndProvider>
    </div>
  );
};

export default layout;
