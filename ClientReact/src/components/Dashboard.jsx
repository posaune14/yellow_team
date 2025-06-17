import { Container, Title, Text, Button, Center, Drawer, AppShell, Menu } from '@mantine/core'
import { useNavigate } from 'react-router-dom'

function Dashboard() {
    const navigate = useNavigate()
    // https://dribbble.com/shots/25241984-Task-Management-Dashboard

    return (
        <AppShell>
                        <Button  
                            onClick={() => navigate('/')} 
                            variant="light" 
                            color="gray" 
                            size="md" 
                            radius="xl"
                        >
                            Sign Out
                        </Button>
            <AppShell.Header style={{marginLeft: '24vw'}}>
            <Container w='90vw' h='7vh' style={{backgroundColor: '#e3e3e3', margin: '2rem', borderRadius: '20px'}}>
            <Menu>
                <Menu.Target>
                    <Button>Settings icon</Button>
                </Menu.Target>
                <Menu.Dropdown>
                    <Menu.Label>Application</Menu.Label>
                        <Menu.Item>
                            Itewm
                        </Menu.Item>
                    <Menu.Divider />
                    <Menu.Label>Account</Menu.Label>
                    <Menu.Item>
                        Account settings
                    </Menu.Item>
                    <Menu.Item onClick={() => navigate('/')} color='red'>
                        Sign out
                    </Menu.Item>
                </Menu.Dropdown>
            </Menu>
            </Container>
            </AppShell.Header>
            <AppShell.Navbar withBorder={false}>
                <Container h='90vh' w='20vw' style={{backgroundColor: '#e3e3e3', margin: '2rem', borderRadius: '20px'}}>

                </Container>
            </AppShell.Navbar>
            <AppShell.Main>

            </AppShell.Main>
        </AppShell>
    )
}

export default Dashboard 