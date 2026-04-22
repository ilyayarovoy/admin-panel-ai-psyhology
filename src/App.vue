<template>
  <div :class="['min-h-screen transition-colors', isDarkMode ? 'bg-black text-white' : 'bg-white text-black']">
    <!-- Login Modal -->
    <LoginModal v-if="!isAuthenticated" @authenticated="handleLogin" />

    <!-- Header -->
    <Header v-if="isAuthenticated" />

    <!-- Main Content -->
    <main v-if="isAuthenticated" class="max-w-7xl mx-auto px-6 py-12">
      <!-- Top Bar with Theme Toggle and Logout -->
      <div class="flex items-center justify-between mb-8">
        <h2 class="text-xl font-bold">Админ-панель</h2>
        <div class="flex gap-4">
          <!-- Theme Toggle -->
          <button
            @click="isDarkMode = !isDarkMode"
            :class="[
              'px-4 py-2 rounded font-medium transition',
              isDarkMode
                ? 'bg-gray-800 text-yellow-400 hover:bg-gray-700'
                : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
            ]"
          >
            {{ isDarkMode ? '☀️ Светлая' : '🌙 Тёмная' }}
          </button>

          <!-- Logout -->
          <button
            @click="logout"
            class="px-4 py-2 bg-red-600 text-white rounded font-medium hover:bg-red-700 transition"
          >
            Выход
          </button>
        </div>
      </div>

      <!-- Tabs Navigation -->
      <div class="flex gap-2 mb-8 border-b" :class="isDarkMode ? 'border-gray-800' : 'border-gray-300'">
        <button
          @click="activeTab = 'users'"
          :class="[
            'px-6 py-3 font-medium text-sm transition border-b-2',
            activeTab === 'users'
              ? isDarkMode ? 'border-white text-white' : 'border-black text-black'
              : isDarkMode ? 'border-transparent text-gray-400 hover:text-gray-200' : 'border-transparent text-gray-600 hover:text-gray-900'
          ]"
        >
          👥 Пользователи
        </button>
        <button
          @click="activeTab = 'messages'"
          :class="[
            'px-6 py-3 font-medium text-sm transition border-b-2',
            activeTab === 'messages'
              ? isDarkMode ? 'border-white text-white' : 'border-black text-black'
              : isDarkMode ? 'border-transparent text-gray-400 hover:text-gray-200' : 'border-transparent text-gray-600 hover:text-gray-900'
          ]"
        >
          💬 Сообщения
        </button>
      </div>

      <!-- Tab Content -->
      <div class="animate-fadeIn">
        <UsersManager
          v-show="activeTab === 'users'"
          :isDarkMode="isDarkMode"
          @show-toast="showToast"
        />
        <MessagesManager
          v-show="activeTab === 'messages'"
          :isDarkMode="isDarkMode"
          @show-toast="showToast"
        />
      </div>
    </main>

    <!-- Footer -->
    <footer v-if="isAuthenticated" :class="['border-t mt-16 py-8 text-center text-sm', isDarkMode ? 'border-gray-800 text-gray-500' : 'border-gray-300 text-gray-600']">
      <p>AI Psychologist Admin Panel © 2026</p>
    </footer>

    <!-- Toast Notification -->
    <NotificationToast
      :message="toast.message"
      :type="toast.type"
    />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import Header from './components/Header.vue'
import UsersManager from './components/UsersManager.vue'
import MessagesManager from './components/MessagesManager.vue'
import LoginModal from './components/LoginModal.vue'
import NotificationToast from './components/NotificationToast.vue'

const activeTab = ref('users')
const isAuthenticated = ref(false)
const isDarkMode = ref(true)

const toast = ref({
  message: '',
  type: 'success'
})

const handleLogin = () => {
  isAuthenticated.value = true
}

const logout = () => {
  if (confirm('Вы уверены?')) {
    localStorage.removeItem('adminAuth')
    isAuthenticated.value = false
    isDarkMode.value = true
  }
}

const showToast = (message, type = 'success') => {
  toast.value = { message, type }
}

onMounted(() => {
  // Проверяем аутентификацию
  const isAuth = localStorage.getItem('adminAuth')
  if (isAuth) {
    isAuthenticated.value = true
  }

  // Загружаем сохраненную тему
  const savedTheme = localStorage.getItem('theme')
  if (savedTheme) {
    isDarkMode.value = savedTheme === 'dark'
  }
})

// Сохраняем выбранную тему
watch(() => isDarkMode.value, (newValue) => {
  localStorage.setItem('theme', newValue ? 'dark' : 'light')
})
</script>

<script>
import { watch } from 'vue'
</script>

<style>
@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

.animate-fadeIn {
  animation: fadeIn 0.3s ease-in-out;
}
</style>