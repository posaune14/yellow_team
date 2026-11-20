import { lazy, Suspense } from 'react'
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
const SignIn = lazy(() => import('./pages/SignIn'))
const SignUp = lazy(() => import('./pages/SignUp'))
import Landing from './pages/Landing'
const Dashboard = lazy(() => import('./pages/Dashboard'))
const Credits = lazy(() => import('./pages/Credits'))
const Privacy = lazy(() => import('./pages/Privacy'))
import './App.css'

function App() {
  return (
    
    <Router>
      <Suspense fallback={null}>
      <Routes>
        <Route path="/" element={<Landing />} />
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/signin" element={<SignIn />} />
        <Route path="/signup" element={<SignUp />} />
        <Route path="/credits" element={<Credits />} />
        <Route path="/privacy" element={<Privacy />} />
      </Routes>
      </Suspense>
    </Router>
  )
}

export default App
