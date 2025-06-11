import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import { Center } from '@mantine/core'
import SigninBox from './components/SigninBox'
import Landing from './pages/Landing'
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
        <Route path="/signin" element={<SigninBox />} />
      </Routes>
    </Router>
  )
}

export default App
