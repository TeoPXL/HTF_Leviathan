// stores/appStore.js
import { defineStore } from 'pinia'
import { ref, watch, computed } from 'vue'

export const useAppStore = defineStore('app', () => {
  const systemStatus = ref(null)
// Function to check system health
  const checkSystemHealth = async () => {
    try {
      const response = await fetch('/api/v1/status')
      if (!response.ok) throw new Error('HTTP error ' + response.status)

      const data = await response.json();
      if (data.status === 'healthy') {
        systemStatus.value = 'healthy'
      } else if (data.status === 'damaged') {
        systemStatus.value = 'damaged'
      } else {
        systemStatus.value = 'error'
      }
    } catch (error) {
      console.error('System health check failed:', error)
      systemStatus.value = 'error'
    }
  }

// Computed message based on system status and maintenance mode
  const systemMessage = computed(() => {
    switch (systemStatus.value) {
      case 'maintenance':
        return 'Systems undergoing maintenance'
      case 'healthy':
        return 'All systems operational'
      case 'damaged':
        return 'Systems damaged'
      default:
        return 'All systems offline'
    }
  })

  return {
    systemStatus, systemMessage, checkSystemHealth,
  }
})
