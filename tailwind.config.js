/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./app/views/**/*.{erb,haml,html,slim,rb}",
    "./app/views/components/**/*.rb",
    "./app/helpers/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.js",
    "./app/frontend/**/*.css",
    "./app/frontend/**/*.js",
  ],
  theme: { extend: {} },
  plugins: [
    require('daisyui'),
  ],
  daisyui: {
    themes: [
      "nord",
      "dracula",
    ]
  }
}

