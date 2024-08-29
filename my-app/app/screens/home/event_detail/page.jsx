"use client";
import {
  formatCurrency,
  formatDateTime,
  formatFullTime,
  mapStatus,
  removeHyphens,
} from "@/app/helper";
import {
  getEventDetailRequest,
  updateTaskDnDRequest,
} from "@/app/store/reducer";
import { Breadcrumb, Divider } from "antd";
import Timeline, { TimelineGroup } from "react-calendar-timeline";
import "react-calendar-timeline/lib/Timeline.css";
import update from "immutability-helper";
import { useSearchParams } from "next/navigation";
import { HomeOutlined } from "@ant-design/icons";
import React, { useCallback, useEffect, useMemo, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import Link from "next/link";
import BudgetHeader from "@/app/component/budget/budget.header";
import MemberInEvent from "@/app/component/event/member.event";
import EventInfoSection from "@/app/component/event/EventInfoSection";
import FullCalendar from "@fullcalendar/react";

import dayGridPlugin from "@fullcalendar/daygrid";
import timeGridPlugin from "@fullcalendar/timegrid";
import viLocale from "@fullcalendar/core/locales/vi";
import interactionPlugin from "@fullcalendar/interaction";
import moment from "moment";
import TaskItem from "@/app/component/task/taskItem";
import { useDrop } from "react-dnd";
import DropContainer from "@/app/component/task/DropContainer";
import NoData from "@/app/component/UI/NoData";
function Task() {
  const searchParams = useSearchParams();
  const eventId = searchParams.get("eventId");
  const eventName = searchParams.get("name");
  const dispatch = useDispatch();
  const { listTaskEvent, budgetPricing, memberInEvent, eventInfo } =
    useSelector((state) => state.user);
  useEffect(() => {
    dispatch(getEventDetailRequest(eventId));
  }, [eventId, dispatch]);
  const sortedTasks = listTaskEvent
    .slice()
    .sort((a, b) => new Date(a.startAt) - new Date(b.startAt));

  const item = sortedTasks?.map((item, index) => {
    let style = {};
    if (index === 0) {
      style = "green";
    } else if (index === sortedTasks?.length - 1) {
      style = "red";
    } else {
      style = "blue";
    }

    return {
      color: style,
      children: (
        <>
          <p>Tên sự kiện: {item?.name}</p>
          <p>
            Thời gian: {formatDateTime(item?.startAt)} -{" "}
            {formatDateTime(item?.endAt)}
          </p>
          <p>Trạng thái: {mapStatus(item?.status)}</p>
          <p className="flex gap-1 items-center">
            {item.users?.length !== 0 ? "Thành viên:" : ""}
            {item.users?.map((user) => {
              return (
                <>
                  <div className="w-[30px] h-[30px]">
                    <img src={user.avatarUrl} alt="avatar" title={user?.name} />
                  </div>
                </>
              );
            })}
          </p>
        </>
      ),
    };
  });
  const breadcrumbList = [
    {
      title: (
        <>
          <Link href={"/screens/home"}>
            <HomeOutlined />
          </Link>
        </>
      ),
    },
    {
      title: "Chi tiết sự kiện",
    },
    {
      title: removeHyphens(eventName),
    },
  ];
  const budgetInfo = [
    {
      label: "Dự kiến",
      price: formatCurrency(budgetPricing.totalBudgetAmount) || 0,
    },
    {
      label: "Thực tế",
      price: formatCurrency(budgetPricing.totalCost?.totalBudget) || 0,
    },
    {
      label: "Còn lại",
      price:
        formatCurrency(
          budgetPricing.totalBudgetAmount - budgetPricing.totalCost?.totalBudget
        ) || 0,
    },
  ];
  const budgetInfoVon = [
    {
      label: "Vốn",
      price: formatCurrency(budgetPricing.totalCost?.totalActualCost) || 0,
    },
    {
      label: "Thực tế",
      price: formatCurrency(budgetPricing.totalCost?.totalBudget) || 0,
    },
    {
      label: "Còn lại",
      price:
        formatCurrency(
          budgetPricing.totalCost?.totalActualCost -
            budgetPricing.totalCost?.totalBudget
        ) || 0,
    },
  ];
  const resources = sortedTasks?.map((event) => ({
    id: event.id,
    title: event.name,
  }));
  const convertEvents = (events) => {
    return events?.map((event) => ({
      id: event.id,
      title: event.name,
      start: event.startAt,
      end: event.endAt || event.startAt,
      description: event.description,
    }));
  };
  //handle group date
  // const groupTasksByStartAt = (tasks) => {
  //   const groups = tasks.reduce((result, task) => {
  //     const date = task.startAt.split("T")[0];
  //     if (!result[date]) {
  //       result[date] = [];
  //     }
  //     result[date].push(task);
  //     return result;
  //   }, {});

  //   return Object.entries(groups).map(([date, tasks]) => ({
  //     dayGroup: date,
  //     tasks: tasks,
  //   }));
  // };

  // //useMemo
  // console.log("list task: ", listTaskEvent.data);
  // const groupTaskByDay = useMemo(() => groupTasksByStartAt(sortedTasks));
  const groups = sortedTasks?.map((item, index) => {
    return {
      id: item.id,
      title: item?.name,
    };
  });

  const items = listTaskEvent?.map((item, index) => {
    return {
      id: item.id || index + 1,
      group: item.id,
      title: item.name,
      start_time: moment(item.startAt).toDate(),
      end_time: moment(item.endAt).toDate(),
      canMove: true,
      canResize: true,
      canResizeLeft: true,
      canResize: "both",
    };
  });
  const earliestStartTime = Math.min(
    ...items.map((item) => new Date(item.start_time).getTime())
  );
  const latestEndTime = Math.max(
    ...items.map((item) => new Date(item.end_time).getTime())
  );
  const handleOnItemMove = (itemId, dragTime, newGroupOrder) => {
    const currentTask = listTaskEvent.find((task) => task.id === itemId);

    if (currentTask) {
      const startAtOld = moment(currentTask.startAt);
      const endAtOld = moment(currentTask.endAt);
      const duration = endAtOld.diff(startAtOld, "days");
      const newStartAt = formatFullTime(dragTime);
      const newEndAt = moment(dragTime)
        .add(duration, "days")
        .format("YYYY-MM-DD HH:mm:ss");

      const updateTask = {
        id: itemId,
        startAt: newStartAt,
        endAt: newEndAt,
      };
      // Dispatch hành động cập nhật task
      dispatch(updateTaskDnDRequest(updateTask));
    }
  };
  const handleOnItemResize = (itemId, time, edge) => {
    if (edge === "right") {
      const updateTaskRight = {
        id: itemId,
        endAt: formatFullTime(time),
      };
      dispatch(updateTaskDnDRequest(updateTaskRight));
    } else {
      const updateTaskLeft = {
        id: itemId,
        startAt: formatFullTime(time),
      };
      dispatch(updateTaskDnDRequest(updateTaskLeft));
    }
  };
  const handleItemClick = (itemId, e, time) => {
    console.log("item click: ", formatFullTime(time));
  };
  return (
    <div className="py-3 px-8">
      <div className="task-header">
        <Breadcrumb items={breadcrumbList} />
      </div>
      <div className="task-body">
        <span className="font-bold text-[30px] whitespace-nowrap">
          Chi tiết sự kiện
        </span>
        <Divider />
        <div className="budget-header">
          <div className="text-lg font-bold mb-4">Ngân sách</div>
          <BudgetHeader budgetInfo={budgetInfo} />
          <div className="mt-3"></div>
          <BudgetHeader budgetInfo={budgetInfoVon} />
        </div>
        <Divider />
        <div className="event-info">
          <div className="text-lg font-bold mb-4">Thông tin</div>
          <EventInfoSection eventInfo={eventInfo} />
        </div>
        <Divider />
        <div className="task-timeline py-4">
          <div className="text-lg font-bold mb-6">Timeline sự kiện</div>
          {/* <div className="task-container h-full gap-3  flex overflow-auto">
            {groupTaskByDay?.map((item, index) => {
              return (
                <div className="">
                  <h1>Ngày {item.dayGroup}</h1>
                  <DropContainer tasks={item.tasks} dayGroup={item.dayGroup} />
                </div>
              );
            })}
          </div> */}
          {items.length == 0 ? (
            <NoData />
          ) : (
            <Timeline
              key={groups.length + item.length}
              groups={groups}
              sidebarWidth={200}
              rightSidebarWidth={0}
              items={items}
              defaultTimeStart={moment(earliestStartTime)}
              defaultTimeEnd={moment(latestEndTime)}
              lineHeight={100}
              timeSteps={{
                minute: 5,
                hour: 1,
                day: 1,
                month: 1,
                year: 1,
              }}
              maxZoom={30 * 86400 * 1000}
              onItemMove={(itemId, dragTime, newGroupOrder) =>
                handleOnItemMove(itemId, dragTime, newGroupOrder)
              }
              onItemResize={(itemId, time, edge) =>
                handleOnItemResize(itemId, time, edge)
              }
              onItemClick={(itemId, e, time) =>
                handleItemClick(itemId, e, time)
              }
            />
          )}
        </div>
        <Divider />
        <div className="task-member">
          <div className="text-lg font-bold mb-2">Thành viên tham dự</div>
          <MemberInEvent memberInEvent={memberInEvent} />
        </div>
      </div>
    </div>
  );
}

export default Task;
