module.exports = {
  purge: ["app/vite/**/*.{js,jsx,ts,tsx}"],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      animation: {
        "material-spin": "spin 1.4s linear infinite",
        "material-spin-circle":
          "material-spin-circle 1.4s ease-in-out infinite",
        wiggle: "wiggle 1s ease-in-out infinite",
      },
      keyframes: {
        "material-spin-circle": {
          "0%": {
            "stroke-dasharray": "1px, 200px",
            "stroke-dashoffset": "0px",
          },
          "50%": {
            "stroke-dasharray": "100px, 200px",
            "stroke-dashoffset": "-15px",
          },
          "100%": {
            "stroke-dasharray": "100px, 200px",
            "stroke-dashoffset": "-125px",
          },
        },
        wiggle: {
          "0%, 100%": {
            transform: "rotate(-3deg)",
          },
          "50%": {
            transform: "rotate(3deg)",
          },
        },
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
};
