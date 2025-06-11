import { Container, Title, Text, Button, Center } from '@mantine/core'
import { useNavigate } from 'react-router-dom'

function Dashboard() {
    const navigate = useNavigate()

    return (
        <Center>
            
                <Text size="lg" style={{ padding: '2rem', textAlign: 'center' }}>
                    You have successfully signed in!
                </Text>
                <Center>
                    <Button 
                        onClick={() => navigate('/')} 
                        variant="light" 
                        color="gray" 
                        size="md" 
                        radius="xl"
                    >
                        Sign Out
                    </Button>
                </Center>
        </Center>
    )
}

export default Dashboard 