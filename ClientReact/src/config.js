// Single source of truth for the backend base URL.
// Override locally by creating ClientReact/.env.local with:
//   VITE_API_BASE_URL=http://localhost:3000
export const API_BASE_URL =
  import.meta.env.VITE_API_BASE_URL || 'https://yellow-team.onrender.com';
