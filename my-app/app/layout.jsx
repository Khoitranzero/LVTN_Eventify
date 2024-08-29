import { Inter } from "next/font/google";
import "./globals.css";
import "./assets/base/_base.scss";
import StyledComponentsRegistry from "./lib/antd.registry";
import { DndProvider } from "react-dnd";
import { HTML5Backend } from "react-dnd-html5-backend";
const inter = Inter({ subsets: ["latin"] });

export const metadata = {
  title: "Eventify Admin",
  // description: "Generated by create next app",
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body className="scroll-bar">
        <StyledComponentsRegistry>{children}</StyledComponentsRegistry>
      </body>
    </html>
  );
}
