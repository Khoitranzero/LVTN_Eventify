"use client";
import React, { useState } from "react";
import { DeleteOutlined, EditTwoTone } from "@ant-design/icons";
import { Popconfirm } from "antd";
import { useDispatch } from "react-redux";
import { deleteBudgetCategoryRequest } from "@/app/store/reducer";
import UpdateBudgetModal from "./budget.update";
import { formatCurrency } from "@/app/helper";
const BudgetCategory = (props) => {
  const { theader, tbody } = props;
  const dispatch = useDispatch();
  const [openUpdateModal, setOpenUpdateModal] = useState(false);
  const [updateBudget, setupdateBudget] = useState({});
  const handleDeteleCategory = (categoryId) => {
    dispatch(deleteBudgetCategoryRequest(categoryId));
  };
  return (
    <div>
      <UpdateBudgetModal
        openUpdateModal={openUpdateModal}
        setOpenUpdateModal={setOpenUpdateModal}
        updateBudget={updateBudget}
      />
      <table>
        <thead>
          <tr>
            {theader?.map((headerItem, index) => (
              <th key={index}>{headerItem}</th>
            ))}
          </tr>
        </thead>
        <tbody>
          {tbody?.map((item, index) => {
            return (
              <>
                <tr
                  key={index}
                  className={index % 2 !== 0 ? "!bg-gray-100" : "!bg-white"}
                >
                  <td>{index + 1}</td>
                  <td>{item.name || '-'}</td>
                  <td>
                    {formatCurrency(item.totalActualAmount) ||
                      formatCurrency(0)}
                  </td>
                  <td>
                    <Popconfirm
                      placement="leftTop"
                      title={"Xác nhận xóa danh mục"}
                      description={"Bạn có chắc chắn muốn xóa danh mục này ?"}
                      onConfirm={() => handleDeteleCategory(item.id)}
                      okText="Xác nhận"
                      cancelText="Hủy"
                    >
                      <span className="cursor-pointer text-red-500 text-[20px]">
                        <DeleteOutlined />
                      </span>
                    </Popconfirm>
                    <EditTwoTone
                      twoToneColor={"#f57800"}
                      className="cursor-pointer ml-2"
                      onClick={() => {
                        setOpenUpdateModal(true);
                        setupdateBudget(item);
                      }}
                    />
                  </td>
                </tr>
              </>
            );
          })}
        </tbody>
      </table>
    </div>
  );
};

export default BudgetCategory;
