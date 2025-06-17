import { Container, Title, Text, Button, Center, Drawer, AppShell, Menu, NavLink, Space } from '@mantine/core'
import { useNavigate } from 'react-router-dom'
import {
    IconSettings,
    IconInfoSquareRounded,
    IconArrowsLeftRight,
    IconChevronRight,
    IconGauge,
  } from '@tabler/icons-react';

 
function Dashboard() {
    const Navbar = () => {
        return(
            <>
            <Container h='90vh' w='20vw' style={{backgroundColor: '#e3e3e3', margin: '2rem', borderRadius: '20px', paddingTop: '2rem'}}>
            
            <NavLink 
                href="#required-for-focus"
                label="With right section"
                leftSection={<IconGauge size={16} stroke={1.5} />}
                rightSection={<IconChevronRight size={12} stroke={1.5} className="mantine-rotate-rtl" />}
            />
            </Container>
            </>
        )
    }
    const navigate = useNavigate()
    // https://dribbble.com/shots/25241984-Task-Management-Dashboard

    return (
        <AppShell withBorder={false}>
            <AppShell.Header style={{marginLeft: '24vw'}}>
            <Container w='90vw' h='7vh' style={{backgroundColor: '#e3e3e3', margin: '2rem', borderRadius: '20px'}}>
            <Menu>
                <Menu.Target>
                    <Button variant='light' color='grey' radius='xl'><IconSettings size={30} color='black'/></Button>
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
            <AppShell.Navbar >
                <Navbar />
            </AppShell.Navbar>
            <AppShell.Main>

            </AppShell.Main>
        </AppShell>
    )
}

export default Dashboard 