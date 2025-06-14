import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import { Center } from '@mantine/core'
import SignIn from './pages/SignIn'
import Landing from './pages/Landing'
import Nav from './components/Nav'
import Dashboard from './components/Dashboard'
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
      </Routes>
    </Router>
  )
}

export default App
