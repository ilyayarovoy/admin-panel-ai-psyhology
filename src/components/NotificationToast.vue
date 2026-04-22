<template>
  <div v-if="show" :class="[
    'fixed bottom-6 right-6 px-6 py-4 rounded-lg text-white font-medium shadow-lg transition-all duration-300 animate-slideIn',
    type === 'success' ? 'bg-green-600' :
    type === 'error' ? 'bg-red-600' :
    'bg-blue-600'
  ]">
    <div class="flex items-center gap-3">
      <span v-if="type === 'success'">✅</span>
      <span v-else-if="type === 'error'">❌</span>
      <span v-else>ℹ️</span>
      <span>{{ message }}</span>
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'

const props = defineProps({
  message: String,
  type: {
    type: String,
    default: 'success' // success, error, info
  },
  duration: {
    type: Number,
    default: 3000
  }
})

const show = ref(false)

watch(() => props.message, (newMessage) => {
  if (newMessage) {
    show.value = true
    setTimeout(() => {
      show.value = false
    }, props.duration)
  }
})
</script>

<style scoped>
@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateX(100%);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

.animate-slideIn {
  animation: slideIn 0.3s ease-out;
}
</style>