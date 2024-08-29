import React from "react";
import TaskItem from "./taskItem";
import { useDrop } from "react-dnd";
import { useDispatch } from "react-redux";
import { updateTaskDnDRequest } from "@/app/store/reducer";

const DropContainer = (props) => {
  //props
  const { tasks, dayGroup } = props;
  //dispatch
  const dispatch = useDispatch();
  //handle useDrop
  const [{ isOver }, drop] = useDrop(() => ({
    accept: "TASK",
    drop: (item) => addTaskToContainer(item),
    collect: (monitor) => ({
      isOver: !!monitor.isOver(),
    }),
  }));
  //custom function
  const addTaskToContainer = (item) => {
    const updateTask = {
      id: item.data.id,
      startAt: dayGroup,
    };
    dispatch(updateTaskDnDRequest(updateTask));
  };
  return (
    <div
      ref={drop}
      className=" w-fit h-fit border-[1px] border-gray-300 grid grid-cols-1 p-3 gap-3 rounded-lg min-w-[300px]"
    >
      {tasks?.map((item, index) => {
        return (
          <div key={index}>
            <TaskItem data={item} />
          </div>
        );
      })}
    </div>
  );
};

export default DropContainer;
