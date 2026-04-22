<template>
  <div class="space-y-6">
    <!-- Поиск и фильтры -->
    <div :class="['rounded-lg border p-4 md:p-6', isDarkMode ? 'bg-gray-900 border-gray-800' : 'bg-gray-100 border-gray-300']">
      <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
        <div>
          <label :class="['block text-sm font-medium mb-2', isDarkMode ? 'text-gray-300' : 'text-gray-700']">
            Поиск по TG ID
          </label>
          <input
            v-model="searchTgId"
            type="number"
            placeholder="ID"
            :class="[
              'w-full px-4 py-2 rounded focus:outline-none focus:border-gray-600 transition',
              isDarkMode
                ? 'bg-gray-800 border border-gray-700 text-white placeholder-gray-500'
                : 'bg-white border border-gray-300 text-black placeholder-gray-400'
            ]"
            @keyup.enter="searchUser"
          />
        </div>
        <div class="flex items-end">
          <button
            @click="searchUser"
            :class="[
              'w-full px-4 py-2 font-medium rounded hover:opacity-90 transition text-sm md:text-base',
              isDarkMode ? 'bg-white text-black' : 'bg-black text-white'
            ]"
          >
            Поиск
          </button>
        </div>
        <div class="flex items-end">
          <button
            @click="loadAllUsers"
            :class="[
              'w-full px-4 py-2 rounded font-medium hover:opacity-90 transition text-sm md:text-base',
              isDarkMode
                ? 'bg-gray-800 text-white border border-gray-700'
                : 'bg-gray-200 text-black border border-gray-300'
            ]"
          >
            Все
          </button>
        </div>
      </div>

      <div class="mt-4 flex gap-2 flex-wrap">
        <button
          @click="showPremiumOnly = false"
          :class="[
            'px-3 md:px-4 py-2 rounded font-medium transition text-sm',
            !showPremiumOnly
              ? isDarkMode ? 'bg-white text-black' : 'bg-black text-white'
              : isDarkMode ? 'bg-gray-800 text-gray-300 border border-gray-700 hover:bg-gray-700' : 'bg-gray-200 text-gray-700 border border-gray-300 hover:bg-gray-300'
          ]"
        >
          Все
        </button>
        <button
          @click="showPremiumOnly = true"
          :class="[
            'px-3 md:px-4 py-2 rounded font-medium transition text-sm',
            showPremiumOnly
              ? isDarkMode ? 'bg-white text-black' : 'bg-black text-white'
              : isDarkMode ? 'bg-gray-800 text-gray-300 border border-gray-700 hover:bg-gray-700' : 'bg-gray-200 text-gray-700 border border-gray-300 hover:bg-gray-300'
          ]"
        >
          Premium ⭐
        </button>
        <button
          @click="exportToCSV"
          :class="[
            'px-3 md:px-4 py-2 rounded font-medium transition text-sm ml-auto',
            isDarkMode
              ? 'bg-green-700 text-white hover:bg-green-600'
              : 'bg-green-600 text-white hover:bg-green-700'
          ]"
        >
          📥 CSV
        </button>
      </div>
    </div>

    <!-- Desktop таблица -->
    <div :class="['hidden md:block rounded-lg border overflow-hidden', isDarkMode ? 'bg-gray-900 border-gray-800' : 'bg-white border-gray-300']">
      <div v-if="loading" :class="['p-8 text-center', isDarkMode ? 'text-gray-400' : 'text-gray-600']">
        Загрузка...
      </div>
      <div v-else-if="filteredUsers.length === 0" :class="['p-8 text-center', isDarkMode ? 'text-gray-400' : 'text-gray-600']">
        Пользователи не найдены
      </div>
      <table v-else class="w-full">
        <thead>
          <tr :class="['border-b', isDarkMode ? 'border-gray-800 bg-gray-800' : 'border-gray-300 bg-gray-200']">
            <th :class="['px-4 md:px-6 py-3 text-left text-sm font-semibold', isDarkMode ? 'text-gray-300' : 'text-gray-700']">
              TG ID
            </th>
            <th :class="['px-4 md:px-6 py-3 text-left text-sm font-semibold', isDarkMode ? 'text-gray-300' : 'text-gray-700']">
              Username
            </th>
            <th :class="['px-4 md:px-6 py-3 text-left text-sm font-semibold', isDarkMode ? 'text-gray-300' : 'text-gray-700']">
              Имя
            </th>
            <th :class="['px-4 md:px-6 py-3 text-left text-sm font-semibold', isDarkMode ? 'text-gray-300' : 'text-gray-700']">
              Premium
            </th>
            <th :class="['px-4 md:px-6 py-3 text-left text-sm font-semibold hidden lg:table-cell', isDarkMode ? 'text-gray-300' : 'text-gray-700']">
              Создано
            </th>
            <th :class="['px-4 md:px-6 py-3 text-right text-sm font-semibold', isDarkMode ? 'text-gray-300' : 'text-gray-700']">
              Действия
            </th>
          </tr>
        </thead>
        <tbody :class="['divide-y', isDarkMode ? 'divide-gray-800' : 'divide-gray-300']">
          <tr
            v-for="user in paginatedUsers"
            :key="user.id"
            :class="['transition', isDarkMode ? 'hover:bg-gray-800' : 'hover:bg-gray-50']"
          >
            <td :class="['px-4 md:px-6 py-4 text-sm font-mono', isDarkMode ? 'text-white' : 'text-black']">
              {{ user.tg_id }}
            </td>
            <td :class="['px-4 md:px-6 py-4 text-sm', isDarkMode ? 'text-white' : 'text-black']">
              {{ user.username || '-' }}
            </td>
            <td :class="['px-4 md:px-6 py-4 text-sm', isDarkMode ? 'text-white' : 'text-black']">
              {{ user.first_name || '-' }}
            </td>
            <td class="px-4 md:px-6 py-4 text-sm">
              <span
                :class="[
                  'inline-block px-2 md:px-3 py-1 rounded text-xs font-medium',
                  user.is_premium
                    ? isDarkMode ? 'bg-white text-black' : 'bg-black text-white'
                    : isDarkMode ? 'bg-gray-800 text-gray-400 border border-gray-700' : 'bg-gray-200 text-gray-600 border border-gray-300'
                ]"
              >
                {{ user.is_premium ? '✓ Premium ⭐' : 'Regular' }}
              </span>
            </td>
            <td :class="['px-4 md:px-6 py-4 text-sm hidden lg:table-cell', isDarkMode ? 'text-gray-400' : 'text-gray-600']">
              {{ formatDate(user.created_at) }}
            </td>
            <td class="px-4 md:px-6 py-4 text-sm text-right space-x-1">
              <button
                @click="togglePremium(user.tg_id)"
                :class="[
                  'px-2 md:px-3 py-1 rounded font-medium text-xs transition inline-block',
                  user.is_premium
                    ? isDarkMode ? 'bg-gray-800 text-gray-300 hover:bg-gray-700' : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
                    : isDarkMode ? 'bg-white text-black hover:bg-gray-200' : 'bg-black text-white hover:bg-gray-900'
                ]"
              >
                {{ user.is_premium ? 'Убрать' : 'Дать' }}
              </button>
              <button
                @click="deleteUser(user.tg_id)"
                :class="[
                  'px-2 md:px-3 py-1 rounded font-medium text-xs transition inline-block',
                  isDarkMode ? 'bg-gray-800 text-red-400 hover:bg-gray-700' : 'bg-red-100 text-red-700 hover:bg-red-200'
                ]"
              >
                🗑️
              </button>
            </td>
          </tr>
        </tbody>
      </table>

      <!-- Пагинация для десктопа -->
      <div v-if="filteredUsers.length > itemsPerPage" :class="['flex items-center justify-between px-4 md:px-6 py-4 border-t flex-wrap gap-2', isDarkMode ? 'border-gray-800 bg-gray-800' : 'border-gray-300 bg-gray-100']">
        <button
          @click="currentPage--"
          :disabled="currentPage === 1"
          :class="[
            'px-3 py-2 rounded font-medium text-sm transition',
            currentPage === 1
              ? isDarkMode ? 'bg-gray-700 text-gray-500 cursor-not-allowed' : 'bg-gray-300 text-gray-500 cursor-not-allowed'
              : isDarkMode ? 'bg-gray-700 text-white hover:bg-gray-600' : 'bg-gray-300 text-black hover:bg-gray-400'
          ]"
        >
          ← Назад
        </button>
        <span :class="['text-sm font-medium', isDarkMode ? 'text-gray-300' : 'text-gray-700']">
          {{ currentPage }} из {{ totalPages }}
        </span>
        <button
          @click="currentPage++"
          :disabled="currentPage === totalPages"
          :class="[
            'px-3 py-2 rounded font-medium text-sm transition',
            currentPage === totalPages
              ? isDarkMode ? 'bg-gray-700 text-gray-500 cursor-not-allowed' : 'bg-gray-300 text-gray-500 cursor-not-allowed'
              : isDarkMode ? 'bg-gray-700 text-white hover:bg-gray-600' : 'bg-gray-300 text-black hover:bg-gray-400'
          ]"
        >
          Вперед →
        </button>
      </div>
    </div>

    <!-- Mobile карточки -->
    <div class="md:hidden space-y-4">
      <div v-if="loading" :class="['p-8 text-center rounded-lg', isDarkMode ? 'text-gray-400 bg-gray-900' : 'text-gray-600 bg-gray-100']">
        Загрузка...
      </div>
      <div v-else-if="filteredUsers.length === 0" :class="['p-8 text-center rounded-lg', isDarkMode ? 'text-gray-400 bg-gray-900' : 'text-gray-600 bg-gray-100']">
        Пользователи не найдены
      </div>
      <div v-else>
        <div
          v-for="user in paginatedUsers"
          :key="user.id"
          :class="['rounded-lg border p-4', isDarkMode ? 'bg-gray-900 border-gray-800' : 'bg-gray-100 border-gray-300']"
        >
          <div class="space-y-3">
            <div class="flex justify-between items-start gap-2">
              <div>
                <p :class="['text-xs font-semibold', isDarkMode ? 'text-gray-400' : 'text-gray-600']">TG ID</p>
                <p :class="['text-lg font-mono font-bold', isDarkMode ? 'text-white' : 'text-black']">{{ user.tg_id }}</p>
              </div>
              <span
                :class="[
                  'inline-block px-2 py-1 rounded text-xs font-medium whitespace-nowrap',
                  user.is_premium
                    ? isDarkMode ? 'bg-white text-black' : 'bg-black text-white'
                    : isDarkMode ? 'bg-gray-800 text-gray-400 border border-gray-700' : 'bg-gray-200 text-gray-600 border border-gray-300'
                ]"
              >
                {{ user.is_premium ? '⭐ Premium' : 'Regular' }}
              </span>
            </div>

            <div>
              <p :class="['text-xs font-semibold', isDarkMode ? 'text-gray-400' : 'text-gray-600']">Username</p>
              <p :class="['text-sm', isDarkMode ? 'text-white' : 'text-black']">{{ user.username || '-' }}</p>
            </div>

            <div>
              <p :class="['text-xs font-semibold', isDarkMode ? 'text-gray-400' : 'text-gray-600']">Имя</p>
              <p :class="['text-sm', isDarkMode ? 'text-white' : 'text-black']">{{ user.first_name || '-' }}</p>
            </div>

            <div>
              <p :class="['text-xs font-semibold', isDarkMode ? 'text-gray-400' : 'text-gray-600']">Создано</p>
              <p :class="['text-sm', isDarkMode ? 'text-gray-400' : 'text-gray-600']">{{ formatDate(user.created_at) }}</p>
            </div>

            <div class="flex gap-2 pt-3 border-t" :class="isDarkMode ? 'border-gray-800' : 'border-gray-300'">
              <button
                @click="togglePremium(user.tg_id)"
                :class="[
                  'flex-1 px-3 py-2 rounded font-medium text-sm transition',
                  user.is_premium
                    ? isDarkMode ? 'bg-gray-800 text-gray-300 hover:bg-gray-700' : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
                    : isDarkMode ? 'bg-white text-black hover:bg-gray-200' : 'bg-black text-white hover:bg-gray-900'
                ]"
              >
                {{ user.is_premium ? 'Убрать ⭐' : 'Дать ⭐' }}
              </button>
              <button
                @click="deleteUser(user.tg_id)"
                :class="[
                  'px-3 py-2 rounded font-medium text-sm transition',
                  isDarkMode ? 'bg-gray-800 text-red-400 hover:bg-gray-700' : 'bg-red-100 text-red-700 hover:bg-red-200'
                ]"
              >
                🗑️
              </button>
            </div>
          </div>
        </div>

        <!-- Пагинация для мобиля -->
        <div v-if="filteredUsers.length > itemsPerPage" :class="['flex items-center justify-between gap-2 mt-4 p-4 rounded-lg', isDarkMode ? 'bg-gray-800' : 'bg-gray-100']">
          <button
            @click="currentPage--"
            :disabled="currentPage === 1"
            :class="[
              'px-2 py-1 rounded font-medium text-sm transition',
              currentPage === 1
                ? isDarkMode ? 'bg-gray-700 text-gray-500 cursor-not-allowed' : 'bg-gray-300 text-gray-500 cursor-not-allowed'
                : isDarkMode ? 'bg-gray-700 text-white hover:bg-gray-600' : 'bg-gray-300 text-black hover:bg-gray-400'
            ]"
          >
            ←
          </button>
          <span :class="['text-xs font-medium', isDarkMode ? 'text-gray-300' : 'text-gray-700']">
            {{ currentPage }}/{{ totalPages }}
          </span>
          <button
            @click="currentPage++"
            :disabled="currentPage === totalPages"
            :class="[
              'px-2 py-1 rounded font-medium text-sm transition',
              currentPage === totalPages
                ? isDarkMode ? 'bg-gray-700 text-gray-500 cursor-not-allowed' : 'bg-gray-300 text-gray-500 cursor-not-allowed'
                : isDarkMode ? 'bg-gray-700 text-white hover:bg-gray-600' : 'bg-gray-300 text-black hover:bg-gray-400'
            ]"
          >
            →
          </button>
        </div>
      </div>
    </div>

    <!-- Статистика -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
      <div :class="['rounded-lg border p-4 md:p-6', isDarkMode ? 'bg-gray-900 border-gray-800' : 'bg-gray-100 border-gray-300']">
        <p :class="['text-sm', isDarkMode ? 'text-gray-400' : 'text-gray-600']">
          Всего пользователей
        </p>
        <p :class="['text-3xl font-bold mt-2', isDarkMode ? 'text-white' : 'text-black']">
          {{ totalUsers }}
        </p>
      </div>
      <div :class="['rounded-lg border p-4 md:p-6', isDarkMode ? 'bg-gray-900 border-gray-800' : 'bg-gray-100 border-gray-300']">
        <p :class="['text-sm', isDarkMode ? 'text-gray-400' : 'text-gray-600']">
          Premium пользователей ⭐
        </p>
        <p :class="['text-3xl font-bold mt-2', isDarkMode ? 'text-white' : 'text-black']">
          {{ premiumUsers }}
        </p>
      </div>
      <div :class="['rounded-lg border p-4 md:p-6', isDarkMode ? 'bg-gray-900 border-gray-800' : 'bg-gray-100 border-gray-300']">
        <p :class="['text-sm', isDarkMode ? 'text-gray-400' : 'text-gray-600']">
          Процент Premium
        </p>
        <p :class="['text-3xl font-bold mt-2', isDarkMode ? 'text-white' : 'text-black']">
          {{ premiumPercent }}%
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { usersApi } from '../services/api'

defineProps({
  isDarkMode: Boolean
})

const emit = defineEmits(['show-toast'])

const users = ref([])
const loading = ref(false)
const searchTgId = ref('')
const showPremiumOnly = ref(false)
const currentPage = ref(1)
const itemsPerPage = 10

const filteredUsers = computed(() => {
  let filtered = users.value

  if (showPremiumOnly.value) {
    filtered = filtered.filter(u => u.is_premium)
  }

  return filtered
})

const totalPages = computed(() => {
  return Math.ceil(filteredUsers.value.length / itemsPerPage)
})

const paginatedUsers = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage
  const end = start + itemsPerPage
  return filteredUsers.value.slice(start, end)
})

const totalUsers = computed(() => users.value.length)
const premiumUsers = computed(() => users.value.filter(u => u.is_premium).length)
const premiumPercent = computed(() => {
  if (totalUsers.value === 0) return 0
  return Math.round((premiumUsers.value / totalUsers.value) * 100)
})

const loadAllUsers = async () => {
  loading.value = true
  try {
    const response = await usersApi.getAll()
    users.value = response.data
    currentPage.value = 1
    searchTgId.value = ''
    emit('show-toast', '✅ Пользователи загружены', 'success')
  } catch (error) {
    console.error('Ошибка загрузки пользователей:', error)
    emit('show-toast', '❌ Ошибка при загрузке пользователей', 'error')
  } finally {
    loading.value = false
  }
}

const searchUser = async () => {
  if (!searchTgId.value) {
    loadAllUsers()
    return
  }

  loading.value = true
  try {
    const response = await usersApi.getById(searchTgId.value)
    users.value = [response.data]
    currentPage.value = 1
    emit('show-toast', '✅ Пользователь найден', 'success')
  } catch (error) {
    console.error('Пользователь не найден:', error)
    users.value = []
    emit('show-toast', '❌ Пользователь не найден', 'error')
  } finally {
    loading.value = false
  }
}

const togglePremium = async (tgId) => {
  try {
    await usersApi.togglePremium(tgId)
    loadAllUsers()
    emit('show-toast', '✅ Premium статус изменен', 'success')
  } catch (error) {
    console.error('Ошибка изменения статуса:', error)
    emit('show-toast', '❌ Ошибка при изменении статуса', 'error')
  }
}

const deleteUser = async (tgId) => {
  if (!confirm('⚠️ Вы уверены? Будут удалены все данные пользователя!')) return

  try {
    await usersApi.delete(tgId)
    loadAllUsers()
    emit('show-toast', '✅ Пользователь удален', 'success')
  } catch (error) {
    console.error('Ошибка удаления:', error)
    emit('show-toast', '❌ Ошибка при удалении пользователя', 'error')
  }
}

const exportToCSV = () => {
  if (users.value.length === 0) {
    emit('show-toast', '❌ Нет данных для экспорта', 'error')
    return
  }

  const headers = ['TG ID', 'Username', 'Имя', 'Фамилия', 'Premium', 'Дата создания']
  const rows = users.value.map(u => [
    u.tg_id,
    u.username || '',
    u.first_name || '',
    u.last_name || '',
    u.is_premium ? 'Да' : 'Нет',
    new Date(u.created_at).toLocaleString('ru-RU')
  ])

  const csv = [headers, ...rows]
    .map(row => row.map(cell => `"${cell}"`).join(','))
    .join('\n')

  const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' })
  const link = document.createElement('a')
  const url = URL.createObjectURL(blob)

  link.setAttribute('href', url)
  link.setAttribute('download', `users_${new Date().toISOString().slice(0, 10)}.csv`)
  link.style.visibility = 'hidden'

  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)

  emit('show-toast', '✅ CSV экспортирован', 'success')
}

const formatDate = (dateString) => {
  if (!dateString) return '-'
  return new Date(dateString).toLocaleDateString('ru-RU', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit'
  })
}

onMounted(() => {
  loadAllUsers()
})
</script>