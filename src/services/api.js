import axios from 'axios'

const API_BASE_URL = 'https://ai-psiholog-bot-production.up.railway.app/api'

const api = axios.create({
  baseURL: API_BASE_URL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
})

// Users API
export const usersApi = {
  getAll: () => api.get('/users'),
  getPremium: () => api.get('/users/premium'),
  getById: (tgId) => api.get(`/users/${tgId}`),
  create: (userData) => api.post('/users', userData),
  delete: (tgId) => api.delete(`/users/${tgId}`),
  togglePremium: (tgId) => api.patch(`/users/${tgId}`)
}

// Messages API - ИСПРАВЛЕНО
export const messagesApi = {
  getByUserId: (tgId) => api.get(`/messages/${tgId}`),
  deleteHistory: (tgId) => api.delete(`/messages/${tgId}`)
}

export default api