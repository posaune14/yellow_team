import {
    AppShell,
    Button,
    Group,
    Avatar,
    Text,
    Box,
    ScrollArea,
    NavLink,
    Grid,
    Paper,
    Stack,
    Container,
    Flex,
  } from '@mantine/core'
  import {
    IconSettings,
    IconGauge,
    IconCalendar,
    IconUser,
    IconChartBar,
  } from '@tabler/icons-react'
  import { useState } from 'react'
  const DashboardComp = ()=>{
    return(
      <Stack spacing="md">
            <Grid>
              <Grid.Col span={3}>
                <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#f1f3f5' }}>
                  <Text size="sm" color="dimmed">Total Volunteers</Text>
                  <Text size="xl" fw={700}>24</Text>
                </Paper>
              </Grid.Col>
              <Grid.Col span={3}>
                <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#f1f3f5' }}>
                  <Text size="sm" color="dimmed">Stock(%)</Text>
                  <Text size="xl" fw={700}>58</Text>
                </Paper>
              </Grid.Col>
              <Grid.Col span={3}>
                <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#f1f3f5' }}>
                  <Text size="sm" color="dimmed">X</Text>
                  <Text size="xl" fw={700}>12</Text>
                </Paper>
              </Grid.Col>
              <Grid.Col span={3}>
                <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#f1f3f5' }}>
                  <Text size="sm" color="dimmed">X</Text>
                  <Text size="xl" fw={700}>2</Text>
                </Paper>
              </Grid.Col>
            </Grid>
  
            <Grid>
              <Grid.Col span={8}>
                <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#f1f3f5' }}>
                  <Text size="sm" fw={900} mb="xs">Schedule</Text>
                  <Paper p="md" radius="lg" shadow="xs" withBorder style={{ margin: '1rem', backgroundColor: '#fff' }}>
                    <Flex justify="space-between" align="center" style={{ position: 'relative' }}>
                      <Text fw={900}>8:00 AM</Text>
                      <div style={{ position: 'absolute', left: '50%', transform: 'translateX(-50%)' }}>
                        <Text>Opening</Text>
                      </div>
                    </Flex>
                  </Paper>
                  <Paper p="md" radius="lg" shadow="xs" withBorder style={{ margin:'1rem', backgroundColor: '#fff' }}>
                    <Flex justify="space-between" align="center" style={{ position: 'relative' }}>
                      <Text fw={900}>10:00 AM</Text>
                      <div style={{ position: 'absolute', left: '50%', transform: 'translateX(-50%)' }}>
                        <Text>2nd Volunteer shift starts</Text>
                      </div>
                    </Flex>
                  </Paper>
                  <Paper p="md" radius="lg" shadow="xs" withBorder style={{ margin:'1rem', backgroundColor: '#fff' }}>
                    <Flex justify="space-between" align="center" style={{ position: 'relative' }}>
                      <Text fw={900}>1:00 PM</Text>
                      <div style={{ position: 'absolute', left: '50%', transform: 'translateX(-50%)' }}>
                        <Text>Last Volunteer shift starts</Text>
                      </div>
                    </Flex>
                  </Paper>
                  <Paper p="md" radius="lg" shadow="xs" withBorder style={{ margin:'1rem', backgroundColor: '#fff' }}>
                    <Flex justify="space-between" align="center" style={{ position: 'relative' }}>
                      <Text fw={900}>4:00 PM</Text>
                      <div style={{ position: 'absolute', left: '50%', transform: 'translateX(-50%)' }}>
                        <Text>Closing</Text>
                      </div>
                    </Flex>
                  </Paper>
                </Paper>
              </Grid.Col>
              <Grid.Col span={4}>
                <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#f1f3f5' }}>
                  <Text size="sm" fw={500} mb="xs">Reminders</Text>
                  <Text>Meeting</Text>
                  <Text size="xs" color="dimmed">2:00 PM – 4:00 PM</Text>
                  <Button mt="sm" fullWidth radius="xl" variant="gradient" gradient={{ from: 'teal', to: 'green' }}>
                    Start Meeting
                  </Button>
                </Paper>
              </Grid.Col>
            </Grid>
          </Stack>
    )
  }

  const Inventory = ()=> {
    return(
      <>
        
      </>
    )
  }
 function Dashboard() {
    let [page, setPage] = useState("dash")
    return (
      <AppShell
        padding="md"
        navbar={{ width: 240 }}
        header={{ height: 70 }}
      >
       
        <AppShell.Navbar p="md">
          <ScrollArea>
            <Text fw={700} size="xl" mb="lg">
              PantryLink
            </Text>
            <NavLink label="Dashboard" icon={<IconGauge size={20} />} onClick={setPage ="dash"} />
            <NavLink label="Inventory" icon={<IconChartBar size={20} />} />
            <NavLink label="Volunteers" icon={<IconChartBar size={20} />} />
            <NavLink label="Stream" icon={<IconUser size={20} />} />
            <Box mt="lg">
              <NavLink label="Settings" icon={<IconSettings size={20} />} />
              <NavLink label="Logout" color='red'/>
            </Box>
          </ScrollArea>
        </AppShell.Navbar>
  

        <AppShell.Header px="md" style={{ backgroundColor: '#f8f9fa', borderBottom: '1px solid #eee' }}>
          <Group h="100%" position="apart">
            <Text fw={700} size="lg">Dashboard</Text>
            <Group>
              <Button variant="light" color="gray">
                + Add Project
              </Button>
              <Avatar radius="xl" />
            </Group>
          </Group>
        </AppShell.Header>
  
  
        <AppShell.Main>
          {(() => {
            switch (page) {
              case 'dash':
                return <DashboardComp />;
              case 'inv':
                return <Inventory />;
              default:
                return <DashboardComp />;
            }
          })()}
        </AppShell.Main>
      </AppShell>
    )
  }
export default Dashboard  