import { updateEventCategoryRequest } from "@/app/store/reducer";
import { Form, Input, Modal } from "antd";
import React from "react";
import { useDispatch } from "react-redux";

const UpdateCategoryModal = (props) => {
  const { openUpdateModal, setOpenUpdateModal, updateCategory } = props;
  const [form] = Form.useForm();
  const dispatch = useDispatch();
  const closeModal = () => {
    setOpenUpdateModal(false);
    form.resetFields();
  };
  const onFinish = (values) => {
    setOpenUpdateModal(false);
    form.resetFields();
    console.log("Update id: ", values);
    dispatch(
      updateEventCategoryRequest({
        categoryId: updateCategory.id,
        name: values.name,
        eventCount: updateCategory.eventCount,
      })
    );
  };
  return (
    <div>
      <Modal
        title={`Sửa danh mục ${updateCategory.name}`}
        open={openUpdateModal}
        onCancel={closeModal}
        onOk={() => form.submit()}
        okText="Lưu"
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

export default UpdateCategoryModal;
