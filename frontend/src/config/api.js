// Centralized API configuration
export const API_CONFIG = {
  BACKEND_URL: process.env.REACT_APP_BACKEND_URL || 'http://159.65.134.137:9000',
  PRODUCTION_URL: 'http://159.65.134.137:9000',
  FRONTEND_URL: process.env.NODE_ENV === 'production' 
    ? 'https://www.aurapass.xyz' 
    : 'http://localhost:3000'
};

export const getBackendUrl = () => {
  return API_CONFIG.BACKEND_URL;
};

export default API_CONFIG;
