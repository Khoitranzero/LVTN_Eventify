import { Breadcrumb } from "antd";
import Link from "next/link";
import React from "react";
import { HomeOutlined } from "@ant-design/icons";
import DataAnalysis from "@/app/component/DataAnalysis";
const Category = () => {
  const breadcrumbList = [
    {
      title: (
        <>
          <Link href={"/screens/home"}>
            <HomeOutlined />
          </Link>
        </>
      ),
    },
    {
      title: "Thống kê",
    },
  ];
  return (
    <div className="p-3">
      <div className="category-header">
        <Breadcrumb items={breadcrumbList} />
      </div>
      <div className="category-body">
        <DataAnalysis />
      </div>
    </div>
  );
};

export default Category;
