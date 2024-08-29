"use client";
import React, { useState } from "react";
import {
  DeleteOutlined,
  EditTwoTone,
  InfoCircleOutlined,
} from "@ant-design/icons";
import { message, Popconfirm } from "antd";
import { useDispatch, useSelector } from "react-redux";
import { deleteEventCategoryRequest } from "@/app/store/reducer";
import "../../assets/css/table_custom.scss";
import UpdateCategoryModal from "./data.update";
const DataTable = (props) => {
  const { theader, tbody, handleEventInCategoryClick } = props;
  const dispatch = useDispatch();
  const { eventCategory } = useSelector((state) => state.user);
  const [openUpdateModal, setOpenUpdateModal] = useState(false);
  const [updateCategory, setUpdateCategory] = useState({});
  const handleDeteleCategory = (categoryId) => {
    if (
      eventCategory.some(
        (category) => category.id === categoryId && category.eventCount > 0
      )
    ) {
      message.error("Danh mục này đã có sự kiện, không thể xóa !!!");
    } else {
      dispatch(deleteEventCategoryRequest(categoryId));
    }
  };
  return (
    <div>
      <UpdateCategoryModal
        openUpdateModal={openUpdateModal}
        setOpenUpdateModal={setOpenUpdateModal}
        updateCategory={updateCategory}
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
                  <td>{item.name}</td>
                  <td>{item.eventCount}</td>
                  <td>
                    <InfoCircleOutlined
                      className="cursor-pointer"
                      onClick={() => handleEventInCategoryClick(item.id)}
                    />
                    <Popconfirm
                      className="ml-2"
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
                        setUpdateCategory(item);
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

export default DataTable;
