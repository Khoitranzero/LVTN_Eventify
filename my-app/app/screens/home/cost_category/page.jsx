"use client";
import BudgetCategoryAnalysis from "@/app/component/BudgetCategoryAnalysis";
import { Breadcrumb, Divider } from "antd";
import Link from "next/link";
import { useRouter } from "next/navigation";
import React, { useEffect } from "react";
import { HomeOutlined } from "@ant-design/icons";
import { useDispatch, useSelector } from "react-redux";
import { getFilteredUserByTimeRequest } from "@/app/store/reducer";

const page = () => {
  //selector
  const { isAuthenticated } = useSelector((state) => state.user);
  //router
  const router = useRouter();
  //breadcrumb
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
      title: "Danh mục chi phí",
    },
  ];
  return (
    <div>
      {isAuthenticated ? (
        <div className="budget-category">
          <div className="px-4 py-3">
            <Breadcrumb items={breadcrumbList} />
            <BudgetCategoryAnalysis />
          </div>
        </div>
      ) : (
        router.replace("/screens/login")
      )}
    </div>
  );
};

export default page;
