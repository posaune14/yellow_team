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
    Menu,
    Select,
    Center,
    Title,
    Loader,
    Blockquote,
    TextInput
  } from '@mantine/core'
  import {
    IconSettings,
    IconGauge,
    IconCalendar,
    IconUser,
    IconChartBar,
    IconMessage,
    IconSend
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

  const items = [
    {name:'Tomatoe', current: 44, full: 50, type: 'Vegetables'},
    {name:'Brocoli', current: 5, full: 50, type: 'Nonperishable'},
    {name:'Tomatoe', current: 44, full: 50, type: 'Fruits'},
    {name:'Tomatoe', current: 15, full: 50, type: 'Proteins'},
    {name:'Tomatoe', current: 44, full: 50, type: 'Vegetables'},
  ]

  function InvItems({ item }){
    return(

      <Grid.Col span={2} key={`${item.name}-${item.type}`}>
        <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: item.current / item.full >= .35 ? '#edf5ed' : '#ffdede' }} >
          <Text size="lg" color="dimmed">{item.name}</Text>
          <Text size="xl" fw={700} style={{ color: item.current / item.full >= .35 ? 'green' : 'red' }}>{item.current}/{item.full}</Text>
        </Paper>
      </Grid.Col>
    )}
  const Inventory = ()=> {
    
    //maybe use a switch?
    const [sort, setSort] = useState("")
    return(
      <>
      <Flex mih={50}
        gap="xl"
        justify="center"
        align="center"
        direction="row"
        wrap="wrap">
          <Text>TASK's Inventory</Text>
          <Button variant='light'>
          <Text color='Blue' size='1.1em'>Edit</Text></Button>
        </Flex>
        <Center>
        <Select
          label="Filter"
          placeholder="Pick value"
          data={['Fruits', 'Vegetables', 'Proteins', 'Nonperishable']}
          searchable
          style={{width: '10rem'}}
          value={sort}
          onChange={setSort}
          />
        </Center>
        <Grid>
          {items.map((item, index) =>(
            <InvItems key={index} item={item} />
          ))}
        </Grid>
      </>
    )
  }
  const Volunteer = ()=> {
    return(
      <>
        <Text>Volunteer Page</Text>
      </>
    )
  }
  const Stream = ()=> {
    return(
      <>
        <Stack spacing="md">
          <Title order={1}>TASK's Stream</Title>
          <Grid>
              <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#f1f3f5', width: '100%' }}>
                <Loader />
                <Text size="sm" color="dimmed">Stream Loading...</Text>
                <ScrollArea style={{ height: '30rem' }}>
                <Stack spacing="xs" mt="md">
                    {Array.from({ length: 10 }, (_, i) => (
                      <Blockquote key={i} p={'sm'} color='blue'>
                        <Flex justify="space-between" align="center" style={{ position: 'relative' }}>
                          <Text fw={900}>12.21.2024</Text>
                          <div style={{ position: 'absolute', left: '50%', transform: 'translateX(-50%)' }}>
                            <Text>Tamales and horchata available for a limited time only!</Text>
                          </div>
                        </Flex>
                      </Blockquote>
                    ))}
                    </Stack>
                    </ScrollArea>
                    <TextInput p={'sm'} radius={'xl'} placeholder="Type your message..." leftSection={<IconMessage size={16} />} rightSection={<Button variant="light" size="xs" radius="xl">Button</Button>} />
              </Paper>
          </Grid>
        </Stack>
      </>
    )
  }
 function Dashboard() {
    let [page, setPage] = useState("")
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
            <NavLink label="Dashboard" icon={<IconGauge size={20} />}  onClick={() => setPage("dash")}  />
            <NavLink label="Inventory" icon={<IconChartBar size={20} />}  onClick={() => setPage("inv")} />
            <NavLink label="Volunteers" icon={<IconChartBar size={20} />} onClick={()=> setPage("vol")}/>
            <NavLink label="Stream" icon={<IconUser size={20} />} onClick={()=> setPage("stream")}/>
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
                Help
              </Button>
              <Menu>
                <Menu.Target>
                  <Avatar radius="xl" />
                </Menu.Target>
                <Menu.Dropdown>
                  <Menu.Item color='red'>Log Out</Menu.Item>
                </Menu.Dropdown>
              </Menu>
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
              case 'vol':
                return <Volunteer />;
              case 'stream':
                return <Stream />
              default:
                return <DashboardComp />;
            }
          })()}
        </AppShell.Main>
      </AppShell>
    )
  }
export default Dashboard  