"use client";
import React, { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { getBudgetCategoryRequest } from "../store/reducer";
import BudgetCategory from "./data-analysis/budgetCategory.table";
import CreateBudgetModal from "./data-analysis/budget.create";
import { Divider } from "antd";
import { PieChart } from "@mui/x-charts";
import { formatCurrency } from "../helper";
function BudgetCategoryAnalysis() {
  //selector
  const { budgetCategory } = useSelector((state) => state.user);
  //local state
  const [openCreateModal, setOpenCreateModal] = useState(false);
  //dispatch
  const dispatch = useDispatch();
  //toggle show modal
  const showCreateModal = () => {
    setOpenCreateModal(true);
  };
  //header
  const theader = ["No.", "Loại chi phí", "Thống kê", "Thao tác"];
  //useEffect
  useEffect(() => {
    if (budgetCategory.length == 0) {
      dispatch(getBudgetCategoryRequest());
    }
  }, []);
  //custom array
  const dataPieChart = budgetCategory
    ?.map((item) => {
      if (item.totalActualAmount > 0) {
        return {
          id: item.id,
          value: item.totalActualAmount,
          label: item.name,
        };
      }
      return null;
    })
    .filter(Boolean);
  const sortedCostCategory = [...budgetCategory].sort(
    (a, b) => b.totalActualAmount - a.totalActualAmount
  );

  return (
    <div className="p-3">
      <div className="data-analysis-heading mb-2">
        <div className="mb-4 text-[30px] font-bold">Danh mục chi phí</div>
      </div>
      <Divider />
      <div className="chart-analysis flex items-center ">
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
                position: {
                  horizontal: "left",
                },
                itemMarkWidth: 20,
                itemMarkHeight: 10,
                markGap: 5,
                itemGap: 10,
                style: {
                  paddingLeft: "20px", // Tạo khoảng cách giữa PieChart và legend
                  marginLeft: "50px", // Tăng thêm khoảng cách nếu cần
                },
              },
            }}
            margin={{left: 150 }}
            width={600}
            height={400}
          />
        </div>
        <Divider type="vertical" />
        <div className="h-[400px] overflow-y-auto w-full">
          <table>
            <thead>
              <tr>
                <th>Loại chi phí</th>
                <th>Được sử dụng</th>
                <th>Thống kê</th>
              </tr>
            </thead>
            {sortedCostCategory
              ?.filter((item) => item.totalActualAmount > 0)
              .map((item, index) => {
                return (
                  <>
                    <tr
                      key={index}
                      className={index % 2 !== 0 ? "!bg-gray-100" : "!bg-white"}
                    >
                      <td>{item.name}</td>
                      <td>{item.taskCount}</td>
                      <td>{formatCurrency(item.totalActualAmount)}</td>
                    </tr>
                  </>
                );
              })}
          </table>
        </div>
      </div>
      <Divider />
      <div className="btns flex justify-between mb-2 items-center">
        <span className="font-bold text-[20px]">Danh sách loại chi phí</span>
        <button
          onClick={showCreateModal}
          className="bg-orange-bold-color px-3 mx-2 py-[7px] border-[1px] text-white font-bold text-[15px] rounded-lg hover:bg-orange-fade-color transition-all duration-300 delay-100 hover:text-orange-bold-color"
        >
          Thêm danh mục chi phí
        </button>
      </div>
      <div className="data-analysis-body !h-[calc(100vh-250px)] overflow-auto w-[calc(100vw - 0.75rem)]">
        <div className="table w-full">
          <CreateBudgetModal
            openCreateModal={openCreateModal}
            setOpenCreateModal={setOpenCreateModal}
          />
        </div>
        <BudgetCategory theader={theader} tbody={budgetCategory} />
      </div>
    </div>
  );
}

export default BudgetCategoryAnalysis;
