import { addBudgetCategoryRequest } from "@/app/store/reducer";
import { Form, Input, Modal } from "antd";
import React from "react";
import { useDispatch } from "react-redux";

const CreateBudgetModal = (props) => {
  const { openCreateModal, setOpenCreateModal } = props;
  const [form] = Form.useForm();
  const dispatch = useDispatch();
  const closeModal = () => {
    form.resetFields();
    setOpenCreateModal(false);
  };
  const onFinish = async (values) => {
    dispatch(addBudgetCategoryRequest(values.name));
    setOpenCreateModal(false);
    form.resetFields();
  };
  return (
    <div>
      <Modal
        title="Thêm danh mục chi phí"
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

export default CreateBudgetModal;
