import { updateBudgetCategoryRequest } from "@/app/store/reducer";
import { Form, Input, Modal } from "antd";
import React from "react";
import { useDispatch } from "react-redux";

const UpdateBudgetModal = (props) => {
  const { openUpdateModal, setOpenUpdateModal, updateBudget } = props;
  const [form] = Form.useForm();
  const dispatch = useDispatch();
  const closeModal = () => {
    setOpenUpdateModal(false);
    form.resetFields();
  };
  const onFinish = (values) => {
    dispatch(
      updateBudgetCategoryRequest({
        id: updateBudget.id,
        name: values.name,
        totalActualAmount: updateBudget.totalActualAmount,
      })
    );
    setOpenUpdateModal(false);
    form.resetFields();
  };
  return (
    <div>
      <Modal
        title={`Sửa danh mục ${updateBudget.name}`}
        open={openUpdateModal}
        onCancel={closeModal}
        onOk={() => form.submit()}
        okText="Lưu"
        cancelText="Hủy"
      >
        <Form layout="vertical" form={form} onFinish={onFinish}>
          <Form.Item
            label="Tên danh mục chi phí"
            name="name"
            rules={[{ required: true, message: "Nhập tên danh mục" }]}
          >
            <Input placeholder="Ăn uống, xăng xe,..." />
          </Form.Item>
        </Form>
      </Modal>
    </div>
  );
};

export default UpdateBudgetModal;
