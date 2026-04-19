import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import { setupVant } from './vant'

const app = createApp(App)

setupVant(app)
app.use(router)

app.mount('#app')
