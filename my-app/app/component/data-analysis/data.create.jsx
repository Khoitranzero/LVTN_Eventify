import { addEventCategoryRequest } from "@/app/store/reducer";
import { Form, Input, Modal } from "antd";
import React from "react";
import { useDispatch, useSelector } from "react-redux";

const CreateCategoryModal = (props) => {
  const { openCreateModal, setOpenCreateModal } = props;
  const [form] = Form.useForm();
  const dispatch = useDispatch();
  const closeModal = () => {
    form.resetFields();
    setOpenCreateModal(false);
  };
  const onFinish = async (values) => {
    dispatch(addEventCategoryRequest(values.name));
    setOpenCreateModal(false);
    form.resetFields();
  };
  return (
    <div>
      <Modal
        title="Thêm danh mục sự kiện"
        open={openCreateModal}
        onCancel={closeModal}
        onOk={() => form.submit()}
        okText="Tạo"
        cancelText="Hủy"
      >
        <Form layout="vertical" form={form} onFinish={onFinish}>
          <Form.Item
            label="Tên danh mục"
            name="name"
            rules={[{ required: true, message: "Nhập tên danh mục" }]}
          >
            <Input placeholder="Ra mắt sản phẩm, âm nhạc,..." />
          </Form.Item>
        </Form>
      </Modal>
    </div>
  );
};

export default CreateCategoryModal;
