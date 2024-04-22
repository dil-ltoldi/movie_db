const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
        SourceSansPro: ['"Source Sans Pro"', "Arial", "sans-serif"]
      },
      backgroundImage: {
        search: "url('https://media.themoviedb.org/t/p/w1920_and_h600_multi_faces_filter(duotone,00192f,00baff)/u7OpeS4eckBSR1wFxFTuyy3FjHE.jpg')",
        card: "url('https://www.themoviedb.org/assets/2/v4/misc/trending-bg-39afc2a5f77e31d469b25c187814c0a2efef225494c038098d62317d923f8415.svg')"
      },
      maxWidth: {
        page: "1300px"
      },
      screens: {
        'xl': '1400px',
      },
      fontFamily: {
        'ssp': ['"Source Sans Pro"','Arial','sans-serif']
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
