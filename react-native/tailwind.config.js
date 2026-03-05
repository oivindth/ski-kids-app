/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/**/*.{js,jsx,ts,tsx}',
    './src/**/*.{js,jsx,ts,tsx}',
  ],
  presets: [require('nativewind/preset')],
  theme: {
    extend: {
      colors: {
        primary: '#1A73E8',
        secondary: '#00897B',
        accent: '#FF6D00',
        warning: '#F59E0B',
        background: {
          light: '#F5F7FA',
          dark: '#1A1A2E',
        },
        surface: {
          light: '#FFFFFF',
          dark: '#2A2A3E',
        },
        'text-primary': {
          light: '#1A1A2E',
          dark: '#F0F0F5',
        },
        'text-secondary': {
          light: '#6B7280',
          dark: '#9CA3AF',
        },
      },
    },
  },
  plugins: [],
};
