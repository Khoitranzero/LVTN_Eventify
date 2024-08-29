/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      fontFamily: {
        courier: ["Courier New", "Courier", "monospace"],
      },
      colors: {
        primary: "#475467",
        "text-color": "#ffffff",
        "text-gray": "black",
        "orange-fade-color": "#FDEAD7",
        "orange-bold-color": "#EF6820",
      },
      backgroundImage: {
        "login-background": "url('./assets/image/login-background1.png')",
      },
      screens: {
        sm: "640px",
        md: "760px",
      },
    },
  },
  plugins: [],
};
