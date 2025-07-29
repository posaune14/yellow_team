import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.jsx'
import '@mantine/core/styles.css';
import '@gfazioli/mantine-text-animate/styles.css';
import { MantineProvider } from '@mantine/core';
import '@gfazioli/mantine-onboarding-tour/styles.css';

createRoot(document.getElementById('root')).render(
  <MantineProvider>
    <StrictMode>
      <App />
    </StrictMode>
  </MantineProvider>
)
