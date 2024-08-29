"use client";
import React, { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { getEventCategoryRequest } from "../store/reducer";
import DataTable from "./data-analysis/data.table";
import CreateCategoryModal from "./data-analysis/data.create";
import { PieChart } from "@mui/x-charts";
import { Divider } from "antd";
import { formatDateTime, slugify } from "../helper";
import { useRouter } from "next/navigation";
import NoData from "./UI/NoData";
function DataAnalysis() {
  //router
  const router = useRouter();
  const { eventCategory } = useSelector((state) => state.user);
  const [openCreateModal, setOpenCreateModal] = useState(false);
  const [selectedCategory, setSelectedCategory] = useState([]);
  const theader = ["No.", "Tên danh mục", "Tổng số sự kiện", "Thao tác"];
  const dispatch = useDispatch();
  //custom function
  const showCreateModal = () => {
    setOpenCreateModal(true);
  };
  const handleEventInCategoryClick = (id) => {
    setSelectedCategory(eventCategory.filter((item) => item.id === id));
    console.log("event in category: ", selectedCategory);
  };
  const showEventInfo = (eventId, eventName) => {
    const slugEventName = slugify(eventName);
    router.push(
      `/screens/home/event_detail?eventId=${eventId}&name=${slugEventName}`
    );
  };
  //useEffect
  useEffect(() => {
    if (eventCategory.length == 0) {
      dispatch(getEventCategoryRequest());
    }
  }, []);
  console.log("danh mục sự kiện: ", eventCategory);
  //custom array
  const dataPieChart = eventCategory
    ?.map((item) => {
      if (item.eventCount > 0) {
        return {
          id: item.id,
          value: item.eventCount,
          label: item.name,
        };
      }
      return null;
    })
    .filter(Boolean);
  return (
    <div className="p-3">
      <div className="text-[25px] font-bold">Thống kê danh mục</div>
      <div className="chart-analysis flex items-center">
        <div className="pie-chart border-[1px] border-gray-300 flex items-center h-[400px] rounded-lg">
          <PieChart
            series={[
              {
                data: dataPieChart,
                highlightScope: { faded: "global", highlighted: "item" },
                faded: {
                  innerRadius: 30,
                  additionalRadius: -30,
                  color: "gray",
                },
              },
            ]}
            slotProps={{
              legend: {
                direction: "column",
                position: { horizontal: "left" },
                itemMarkWidth: 20,
                itemMarkHeight: 10,
                markGap: 5,
                itemGap: 10,
              },
            }}
            margin={{ left: 250 }}
            width={600}
            height={400}
          />
        </div>
        <Divider type="vertical" />
        <div className="h-[400px] overflow-y-auto w-full p-3 border-[1px] text-center border-[#D0D5DD] rounded-lg flex flex-col gap-3">
          <div className="text-[25px] font-bold text-white rounded-lg bg-[#475467]">
            Sự kiện trong danh mục {selectedCategory[0]?.name}
          </div>
          {selectedCategory[0]?.Events.length > 0 ? (
            selectedCategory[0]?.Events?.map((item, index) => {
              return (
                <div
                  key={index}
                  className="w-full p-3 border-[1px] text-start border-[#D0D5DD] hover:bg-orange-fade-color transition-all rounded-lg cursor-pointer"
                  onClick={() => showEventInfo(item.id, item.name)}
                >
                  Tên sự kiện: <strong>{item.name}</strong>
                  <br />
                  Thời gian:{" "}
                  <strong>
                    {formatDateTime(item.startAt)} -{" "}
                    {formatDateTime(item.endAt)}
                  </strong>
                </div>
              );
            })
          ) : (
            <div className="flex items-center h-full">
              <NoData />
            </div>
          )}
        </div>
      </div>
      <Divider />
      <div className="data-analysis-body !h-[450px] overflow-auto w-[calc(100vw - 0.75rem)]">
        <div className="table w-full">
          <div className="data-analysis-heading mb-2">
            <div className="flex justify-between items-center">
              <div className="text-[25px] font-bold">Danh mục sự kiện</div>
              <div className="btns ">
                <button
                  onClick={showCreateModal}
                  className="bg-orange-bold-color px-3 mx-2 py-[7px] border-[1px]  text-white font-bold text-[15px] rounded-lg hover:bg-orange-fade-color transition-all duration-300 delay-100 hover:text-orange-bold-color"
                >
                  Thêm danh mục sự kiện
                </button>
              </div>
            </div>
          </div>
          <CreateCategoryModal
            openCreateModal={openCreateModal}
            setOpenCreateModal={setOpenCreateModal}
          />
          <DataTable
            theader={theader}
            tbody={eventCategory}
            handleEventInCategoryClick={handleEventInCategoryClick}
          />
        </div>
      </div>
    </div>
  );
}

export default DataAnalysis;
