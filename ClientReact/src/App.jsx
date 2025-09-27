import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import { Center } from '@mantine/core'
import SignIn from './pages/SignIn'
import SignUp from './pages/SignUp'
import Landing from './pages/Landing'
import Dashboard from './pages/Dashboard'
import Credits from './pages/Credits'
import './App.css'

function App() {
  return (
    
    <Router>
      <Routes>
        <Route path="/" element={
          <Center> 
            <Landing />
          </Center>
        } />
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/signin" element={<SignIn />} />
        <Route path="/signup" element={<SignUp />} />
        <Route path="/credits" element={<Credits />} />
      </Routes>
    </Router>
  )
}

export default App
