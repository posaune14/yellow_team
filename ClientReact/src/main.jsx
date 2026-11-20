import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.jsx'
import '@mantine/core/styles.css';
import '@gfazioli/mantine-text-animate/styles.css';
import '@mantine/notifications/styles.css';
import { MantineProvider } from '@mantine/core';
import { Notifications } from '@mantine/notifications';

// After a new deploy, an open tab or cached page can ask for JS chunks that no
// longer exist. Reload once to pick up the fresh build instead of breaking.
window.addEventListener('vite:preloadError', (event) => {
  event.preventDefault()
  if (!sessionStorage.getItem('pl-reloaded')) {
    sessionStorage.setItem('pl-reloaded', '1')
    window.location.reload()
  }
})
window.addEventListener('load', () => setTimeout(() => sessionStorage.removeItem('pl-reloaded'), 5000))

createRoot(document.getElementById('root')).render(
  <>                      
    <MantineProvider>
      <Notifications />
      <StrictMode>
        <App />
      </StrictMode>
    </MantineProvider>  
  </>
)
