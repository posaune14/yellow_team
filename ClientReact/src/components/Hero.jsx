import { Box, Text, Title, Button } from '@mantine/core'
import { useNavigate } from 'react-router-dom'

function Hero() {
    return (
        <Box style={{ backgroundColor: '#d9d9d9', color: '#000', padding: '2rem', width: '100vw', height: '100vh'}}>
            <Text>Food Bank Management System</Text>
            <Text>Manage your food bank with ease</Text>
            <Button onClick={() => Navigate('/signin')}>Get Started</Button>
        </Box>
    )
}

export default Hero