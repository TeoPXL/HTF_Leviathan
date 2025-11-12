<script setup>

import { ref, onMounted, computed, watch, nextTick } from 'vue'

import { useAppStore } from '@/stores/appStore'
import Earth from "@/components/Earth.vue"

const appStore = useAppStore()
</script>

<template>
  <Earth />
</template>

<style scoped>

</style>
