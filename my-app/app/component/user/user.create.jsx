"use client";
// import { createUser } from "@/app/action";
import dayjs from "dayjs";
import {
  Col,
  DatePicker,
  Form,
  Input,
  Modal,
  Row,
  TimePicker,
  message,
} from "antd";
import TextArea from "antd/es/input/TextArea";
import "./style/user.style.scss";
import { getCurrentDate } from "@/app/helper";
import { useState } from "react";
import moment from "moment";
const CreateUser = (props) => {
  const { openCreateModal, setOpenCreateModal } = props;
  const currentDay = getCurrentDate();
  const [startDay, setStartDay] = useState(null);
  const [endDay, setEndDay] = useState(null);
  const [form] = Form.useForm();
  const closeModal = () => {
    form.resetFields();
    setOpenCreateModal(false);
  };
  const onStartDayChange = (date, dateString) => {
    setStartDay(date);
  };
  const onEndDayChange = (date, dateString) => {
    setEndDay(date);
  };
  const onFinish = async (value) => {
    // const res = await createUser(value);
    // if (res?.id) {
    //   setOpenCreateModal(false);
    //   message.success("Create success");
    // }
    const formData = {
      name: value.eventName,
      desciption: value.eventDescription,
      startAt: `${moment(value.eventStartDay.$d).format("YYYY-MM-DD")} `,
    };
    console.log(
      "Giờ bắt đầu: ",
      moment(value.eventStartTime).format("hh:mm:ss"),
      startDay,
      endDay
    );
  };
  return (
    <>
      <Modal
        title="Thêm một sự kiện"
        open={openCreateModal}
        onCancel={closeModal}
        onOk={() => form.submit()}
        okText="Tạo"
        cancelText="Hủy"
      >
        <Form action="" layout="vertical" form={form} onFinish={onFinish}>
          <Row gutter={[15, 0]}>
            <Col span={24}>
              <Form.Item
                label="Tên sự kiện"
                name="eventName"
                rules={[{ required: true, message: "Nhập tên sự kiện" }]}
              >
                <Input placeholder="Tên sự kiện" />
              </Form.Item>
            </Col>
            <Col span={24}>
              <Form.Item
                label="Mô tả"
                name="eventDescription"
                rules={[{ required: true, message: "Nhập mô tả sự kiện" }]}
              >
                <TextArea rows={4} placeholder="Mô tả của sự kiện" />
              </Form.Item>
            </Col>
            <Col span={24} md={12}>
              <Form.Item
                label="Ngày bắt đầu"
                name="eventStartDay"
                rules={[{ required: true, message: "Nhập ngày bắt đầu" }]}
              >
                <DatePicker
                  defaultValue={dayjs()}
                  onChange={onStartDayChange}
                  value={startDay}
                />
              </Form.Item>
            </Col>
            <Col span={24} md={12}>
              <Form.Item
                label="Giờ bắt đầu"
                name="eventStartTime"
                rules={[{ required: true, message: "Nhập giờ bắt đầu" }]}
              >
                <TimePicker />
              </Form.Item>
            </Col>
            <Col span={24} md={12}>
              <Form.Item
                label="Ngày kết thúc"
                name="eventEndDay"
                rules={[{ required: true, message: "Nhập ngày kết thúc" }]}
              >
                <DatePicker
                  placeholder="Ngày kết thúc"
                  onChange={onEndDayChange}
                  value={endDay}
                />
              </Form.Item>
            </Col>
            <Col span={24} md={12}>
              <Form.Item
                label="Giờ kết thúc"
                name="eventEndTime"
                rules={[{ required: true, message: "Nhập giờ kết thúc" }]}
              >
                <TimePicker />
              </Form.Item>
            </Col>
          </Row>
        </Form>
      </Modal>
    </>
  );
};
export default CreateUser;
