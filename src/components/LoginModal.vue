<template>
  <div class="fixed inset-0 bg-black/80 flex items-center justify-center z-50">
    <div class="bg-gray-900 border border-gray-800 rounded-lg p-8 w-96">
      <h2 class="text-2xl font-bold text-white mb-2">🔐 Доступ к админке</h2>
      <p class="text-gray-400 text-sm mb-6">Введите пароль для входа</p>

      <div class="space-y-4">
        <input
          v-model="password"
          type="password"
          placeholder="Пароль"
          class="w-full px-4 py-3 bg-gray-800 border border-gray-700 rounded text-white placeholder-gray-500 focus:outline-none focus:border-gray-600"
          @keyup.enter="login"
        />

        <button
          @click="login"
          class="w-full px-4 py-3 bg-white text-black font-bold rounded hover:bg-gray-200 transition"
        >
          Войти
        </button>

        <p v-if="error" class="text-red-400 text-sm text-center">
          {{ error }}
        </p>

        <p class="text-gray-500 text-xs text-center">
          Подсказка: пароль по умолчанию <strong>admin</strong>
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const emit = defineEmits(['authenticated'])

const password = ref('')
const error = ref('')

const DEFAULT_PASSWORD = 'admin'

const login = () => {
  if (password.value === DEFAULT_PASSWORD) {
    localStorage.setItem('adminAuth', 'true')
    emit('authenticated')
  } else {
    error.value = 'Неверный пароль!'
    password.value = ''
    setTimeout(() => {
      error.value = ''
    }, 3000)
  }
}
</script>