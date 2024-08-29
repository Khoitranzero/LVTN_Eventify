"use client";
import { formatDateTime, mapStatus } from "@/app/helper";
import { EditOutlined } from "@ant-design/icons";
import { DatePicker, Form, Modal, Select } from "antd";
import { Input } from "postcss";
import React, { useState } from "react";
import { useDrag } from "react-dnd";
import dayjs from "dayjs";
const TaskItem = (props) => {
  const { data } = props;
  //local state
  const [openEditTask, setOpenEditTask] = useState(false);
  const [modalData, setModalData] = useState({});
  //handle drag
  const [{ isDragging }, drag] = useDrag(() => ({
    type: "TASK",
    item: { data },
    collect: (monitor) => ({
      isDragging: !!monitor.isDragging(),
    }),
  }));
  //form
  const [form] = Form.useForm();
  //modal function
  const onFinish = (values) => {
    console.log("data submit: ", values);
    setOpenEditTask(false);
    form.resetFields();
  };
  const handleCancel = () => {
    setOpenEditTask(false);
    form.resetFields();
  };
  const handleClickItem = (data) => {
    setOpenEditTask(true);
    setModalData(data);
  };
  //select option
  const options = [
    {
      value: "Pending",
      label: "Đang chờ xử lý",
    },
    {
      value: "In Progress",
      label: "Đang tiến hành",
    },
    {
      value: "Completed",
      label: "Hoàn thành",
    },
    {
      value: "Cancelled",
      label: "Đã hủy",
    },
  ];
  console.log("data: ", data);
  return (
    <div
      ref={data.isShow ? drag : null}
      className={`task-name w-full text-start p-3 border-[1px] border-black rounded-lg ${data.isShow ? "cursor-move bg-green-200" : "cursor-not-allowed bg-gray-200"} ${
        isDragging ? "text-red-300" : ""
      }`}
    >
      <p
        className="flex justify-between items-center cursor-pointer"
        onClick={() => handleClickItem(data)}
      >
        {data?.name} <EditOutlined />
      </p>
      <p className="flex gap-1 justify-end">
        {data.users?.map((user, index) => {
          return (
            <>
              <div className="w-[30px] h-[30px]" key={index}>
                <img src={user.avatarUrl} alt="avatar" title={user?.name} />
              </div>
            </>
          );
        })}
      </p>
      <Modal
        title={"Chỉnh sửa công việc"}
        open={openEditTask}
        onOk={() => form.submit()}
        centered
        onCancel={handleCancel}
        okText={"Xác nhận"}
        cancelText={"Hủy"}
      >
        <Form layout="vertical" form={form} onFinish={onFinish}>
          <Form.Item label="Tên công việc" name="name">
            <input
              value={data.name}
              className="w-full outline-0 p-3 border-[1px] border-gray-300 rounded-lg"
              type="text"
              placeholder={data.name}
            />
          </Form.Item>
          <Form.Item label="Mô tả" name="description">
            <textarea
              value={data.description}
              className="w-full outline-0 p-3 border-[1px] border-gray-300 rounded-lg"
              type="text"
              placeholder={data.description}
            />
          </Form.Item>
          <Form.Item label="Trạng thái" name="status">
            <Select options={options} />
          </Form.Item>
          <div className="flex ">
            <Form.Item label="Ngày bắt đầu" name="startAt">
              <DatePicker defaultValue={dayjs(data.startAt)} width={200} />
            </Form.Item>
            <Form.Item label="Ngày kết thúc" name="endAt">
              <DatePicker defaultValue={dayjs(data.endAt)} width={200} />
            </Form.Item>
          </div>

          <Form.Item label="Hiển thị" name="isShow">
            <Select
              defaultValue={data.isShow}
              options={[
                {
                  value: true,
                  label: "Hiển thị",
                },
                {
                  value: false,
                  label: "Ẩn",
                },
              ]}
            />
          </Form.Item>
        </Form>
      </Modal>
    </div>
  );
};

export default TaskItem;
