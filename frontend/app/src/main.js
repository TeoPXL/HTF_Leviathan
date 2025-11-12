import './assets/main.css'
import {createApp} from 'vue'
import { createPinia } from 'pinia'
import router from '@/router/index.js'
import { createHead } from '@unhead/vue/client'
import App from './App.vue'

const app = createApp(App)
const pinia = createPinia()
const head = createHead()
app.use(pinia)
app.use(head)
app.use(router)
app.mount('#app')
