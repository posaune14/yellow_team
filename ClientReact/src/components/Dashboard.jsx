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
    TextInput,
    Badge,
    UnstyledButton,
    Table,
    Modal
  } from '@mantine/core'
  import {
    IconSettings,
    IconGauge,
    IconCalendar,
    IconUser,
    IconChartBar,
    IconMessage,
    IconSend,
    IconInfoCircle
  } from '@tabler/icons-react'
  import { useState } from 'react'
  const DashboardComp = ()=>{
    return(
      <Stack spacing="md">
            <Grid>
              <Grid.Col span={3}>
                <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#f1f3f5' }}>
                  <Text size="sm" color="dimmed">Total Volunteers</Text>
                  <Text size="xl" fw={700}>8</Text>
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

 

  function InvItems({ item, editing }){
    
    return(

      <Grid.Col span={2} key={`${item.name}-${item.type}`}>
        <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: item.current / item.full >= .35 ? '#f4fbf6' : '#fff5f5' }} >
          <Text size="lg" color="darks">{item.name}</Text>
          <Text size="xl" fw={700} style={{ color: item.current / item.full >= .35 ? 'green' : 'red' }}>{item.current}/{item.full}</Text>
          {editing && <Badge color="red">
            <Center>
                <TextInput variant="unstyled" placeholder='__' p={0}/>
                <Text p={0}>/</Text>
                <TextInput variant="unstyled" placeholder='__' p={0}/>
            </Center>
          </Badge>}
        </Paper>
      </Grid.Col>
    )}
  const Inventory = ()=> {
    
    //maybe use a switch?
    const [sort, setSort] = useState("") 
    const [editing, setEditing] = useState(false)
    const items = [
    { name: 'Tomatoe', current: 44, full: 50, type: 'Vegetables' },
    { name: 'Brocoli', current: 5, full: 50, type: 'Nonperishable' },
    { name: 'Tomatoe', current: 44, full: 50, type: 'Fruits' },
    { name: 'Tomatoe', current: 15, full: 50, type: 'Proteins' },
    { name: 'Tomatoe', current: 44, full: 50, type: 'Vegetables' },
    { name: 'Carrots', current: 30, full: 50, type: 'Vegetables' },
    { name: 'Apples', current: 50, full: 50, type: 'Fruits' },
    { name: 'Tuna Can', current: 12, full: 40, type: 'Nonperishable' },
    { name: 'Chicken Breast', current: 22, full: 50, type: 'Proteins' },
    { name: 'Bananas', current: 18, full: 50, type: 'Fruits' },
    { name: 'Spinach', current: 35, full: 50, type: 'Vegetables' },
    { name: 'Beans (Dry)', current: 44, full: 50, type: 'Nonperishable' },
    { name: 'Eggs', current: 10, full: 30, type: 'Proteins' },
    { name: 'Oranges', current: 27, full: 50, type: 'Fruits' },
    { name: 'Canned Corn', current: 8, full: 50, type: 'Nonperishable' },
    { name: 'Beef Patties', current: 20, full: 50, type: 'Proteins' },
    { name: 'Zucchini', current: 12, full: 50, type: 'Vegetables' },
    { name: 'Canned Soup', current: 41, full: 50, type: 'Nonperishable' },
    { name: 'Grapes', current: 29, full: 50, type: 'Fruits' },
    { name: 'Canned Beans', current: 45, full: 50, type: 'Nonperishable' },
    { name: 'Turkey Slices', current: 9, full: 50, type: 'Proteins' },
    { name: 'Peppers', current: 40, full: 50, type: 'Vegetables' },
    { name: 'Strawberries', current: 33, full: 50, type: 'Fruits' },
    { name: 'Rice', current: 36, full: 50, type: 'Nonperishable' },
    { name: 'Lentils', current: 23, full: 50, type: 'Nonperishable' }
  ]

  let filteredItems;
  switch (sort) {
    case 'Fruits':
      filteredItems = items.filter((item) => item.type === 'Fruits');
      break;
    case 'Vegetables':
      filteredItems = items.filter((item) => item.type === 'Vegetables');
      break;
    case 'Proteins':
      filteredItems = items.filter((item) => item.type === 'Proteins');
      break;
    case 'Nonperishable':
      filteredItems = items.filter((item) => item.type === 'Nonperishable');
      break;
    default:
      filteredItems = items; 
  }

    return(
      <>
      <Flex mih={50}
        gap="xl"
        justify="center"
        align="center"
        direction="row"
        wrap="wrap">
          <Text>TASK's Inventory</Text>
          <Button variant='light' onClick={()=> setEditing(!editing)}>
          <Text color='Blue' size='1.1em'>Edit</Text></Button>
        </Flex>
        <Center>
        <Select
          label="Filter"
          placeholder="Pick value"
          data={['Fruits', 'Vegetables', 'Proteins', 'Nonperishable']}
          searchable
          clearable
          style={{width: '10rem'}}
          value={sort}
          onChange={setSort}
          />
        </Center>
        <Grid p={'xl'}>
          {filteredItems.map((item, index) => (
            <InvItems key={index} item={item} editing={editing} />
          ))}
        </Grid>
      </>
    )
  }
  const Volunteer = ()=> {
    const [volunteerInfo, setVolunteerInfo] = useState(false)
    const [inboxInfo, setInboxInfo] = useState(false)
    return(
      <>
        <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#f1f3f5' }}>
          <Title order={1}>TASK's Volunteer Page</Title>
        </Paper>
        <Grid>
          <Grid.Col span={6}>
            <Paper mt={'xl'} p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#f1f3f5' }}>
              <Title order={3}>Volunteers</Title>
              <Table>
                <Table.Thead>
                  <Table.Tr>
                    <Table.Th>Name</Table.Th>
                    <Table.Th>Email</Table.Th>
                  </Table.Tr>
                </Table.Thead>
                <Table.Tbody>
                  <Table.Tr>
                    <Modal p={0} opened={volunteerInfo} onClose={()=> setVolunteerInfo(false)} centered size="lg" radius="md" padding="lg">
                      
                        <Paper m={0} p="md" radius="md" withBorder style={{ backgroundColor: "#f8fafc" }}>
                          <Group align="center" mb="md" spacing="lg">
                            <Avatar size={64} radius="xl" color="blue">JD</Avatar>
                            <div>
                              <Title order={3} mb={2}>John Doe</Title>
                              <Text size="sm" color="dimmed">john.doe@example.com</Text>
                            </div>
                          </Group>
                          <Grid gutter="md" mb="md">
                            <Grid.Col span={6}>
                              <Text size="sm" fw={500}><b>Phone:</b> 123-456-7890</Text>
                              <Text size="sm" fw={500}><b>Town:</b> Belle Mead</Text>
                              <Text size="sm" fw={500}><b>State:</b> NJ</Text>
                              <Text size="sm" fw={500}><b>Zip:</b> 08502</Text>
                            </Grid.Col>
                            <Grid.Col span={6}>
                              <Text size="sm" fw={500}><b>Shift:</b> Morning</Text>
                              <Text size="sm" fw={500}><b>Date of Birth:</b> 01/01/1990</Text>
                              <Text size="sm" fw={500}><b>Preferred Role:</b> Server</Text>
                            </Grid.Col>
                            
                          </Grid>
                          <Paper p="sm" radius="md" withBorder bg="gray.0">
                            <Title order={5} mb={4} color="blue">Emergency Contact</Title>
                            <Text size="sm" fw={500}><b>Name:</b> Jane Doe</Text>
                            <Text size="sm" fw={500}><b>Phone:</b> 123-456-7890</Text>
                          </Paper>
                        </Paper>
                    </Modal>
                    <Table.Td>John Doe</Table.Td>
                    <Table.Td>john.doe@example.com</Table.Td>
                    <Table.Td><Button variant="light" color="gray" radius="xl" onClick={()=> setVolunteerInfo(true)}><IconInfoCircle size={20} /></Button></Table.Td>
                  </Table.Tr>
                  <Table.Tr>
                    <Table.Td>Sarah Johnson</Table.Td>
                    <Table.Td>sarah.johnson@example.com</Table.Td>
                    <Table.Td><Button variant="light" color="gray" radius="xl"><IconInfoCircle size={20} /></Button></Table.Td>
                  </Table.Tr>
                  <Table.Tr>
                    <Table.Td>Mike Chen</Table.Td>
                    <Table.Td>mike.chen@example.com</Table.Td>
                    <Table.Td><Button variant="light" color="gray" radius="xl"><IconInfoCircle size={20} /></Button></Table.Td>
                  </Table.Tr>
                  <Table.Tr>
                    <Table.Td>Emily Rodriguez</Table.Td>
                    <Table.Td>emily.rodriguez@example.com</Table.Td>
                    <Table.Td><Button variant="light" color="gray" radius="xl"><IconInfoCircle size={20} /></Button></Table.Td>
                  </Table.Tr>
                  <Table.Tr>
                    <Table.Td>David Thompson</Table.Td>
                    <Table.Td>david.thompson@example.com</Table.Td>
                    <Table.Td><Button variant="light" color="gray" radius="xl"><IconInfoCircle size={20} /></Button></Table.Td>
                  </Table.Tr>
                  <Table.Tr>
                    <Table.Td>Lisa Wang</Table.Td>
                    <Table.Td>lisa.wang@example.com</Table.Td>
                    <Table.Td><Button variant="light" color="gray" radius="xl"><IconInfoCircle size={20} /></Button></Table.Td>
                  </Table.Tr>
                  <Table.Tr>
                    <Table.Td>Robert Martinez</Table.Td>
                    <Table.Td>robert.martinez@example.com</Table.Td>
                    <Table.Td><Button variant="light" color="gray" radius="xl"><IconInfoCircle size={20} /></Button></Table.Td>
                  </Table.Tr>
                  <Table.Tr>
                    <Table.Td>Jennifer Lee</Table.Td>
                    <Table.Td>jennifer.lee@example.com</Table.Td>
                    <Table.Td><Button variant="light" color="gray" radius="xl"><IconInfoCircle size={20} /></Button></Table.Td>
                  </Table.Tr>
                </Table.Tbody>
              </Table>
            </Paper>
            
            {/* Inbox Section under Volunteers List */}
            <Paper mt={'xl'} p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#f1f3f5' }}>
              <Title order={3} mb="md">Inbox</Title>
              <Button variant="gradient" gradient={{ from: 'teal', to: 'green' }} radius="xl" onClick={()=> setInboxInfo(true)}>Open Inbox<Badge p={5} m={5} color="red">3</Badge></Button>
              <Modal p={0} opened={inboxInfo} onClose={()=> setInboxInfo(false)} centered size="lg" radius="md" padding="lg">
                <Paper m={0} p="md" radius="md" withBorder style={{ backgroundColor: "#f8fafc" }}>
                  <Title order={3}>Inbox</Title>
                  <Table>
                    <Table.Thead>
                      <Table.Tr>
                        <Table.Th>Name</Table.Th>
                        <Table.Th>Email</Table.Th>
                      </Table.Tr>
                    </Table.Thead>
                    <Table.Tbody>
                      {[
                        {
                          name: "John Doe",
                          email: "john.doe@example.com",
                          phone: "123-456-7890",
                          town: "Belle Mead",
                          state: "NJ",
                          zip: "08502",
                          shift: "Mornings and Tuesdays",
                          dob: "01/01/1990",
                          role: "Server",
                          emergency: { name: "Jane Doe", phone: "123-456-7890" },
                          bio: "I want to volunteer because I want to help people and I want to make a difference."
                        },
                        {
                          name: "Jane Doe",
                          email: "jane.doe@example.com",
                          phone: "987-654-3210",
                          town: "Princeton",
                          state: "NJ",
                          zip: "08540",
                          shift: "Afternoons and Weekends",
                          dob: "02/02/1992",
                          role: "Cook",
                          emergency: { name: "John Doe", phone: "987-654-3210" },
                          bio: "I want to volunteer because I want to help people and I want to make a difference."
                        }
                      ].map((applicant, idx) => {
                        const [expanded, setExpanded] = useState(false);
                        // To allow per-row expansion, use a component per row
                        function ApplicantRow() {
                          const [expanded, setExpanded] = useState(false);
                          return (
                            <>
                              <Table.Tr style={{ cursor: "pointer" }} onClick={() => setExpanded((e) => !e)}>
                                <Table.Td>
                                  <Button
                                    variant="subtle"
                                    size="xs"
                                    onClick={e => { e.stopPropagation(); setExpanded(exp => !exp); }}
                                    style={{ marginRight: 8 }}
                                  >
                                    {expanded ? "▼" : "▶"}
                                  </Button>
                                  {applicant.name}
                                </Table.Td>
                                <Table.Td>{applicant.email}</Table.Td>
                              </Table.Tr>
                              <tr>
                                <td colSpan={2} style={{
                                  background: "#f8fafc",
                                  padding: 0,
                                  border: 0,
                                  height: 0,
                                  transition: "height 0.3s cubic-bezier(.4,0,.2,1)"
                                }}>
                                  <div
                                    style={{
                                      maxHeight: expanded ? 500 : 0,
                                      overflow: "hidden",
                                      transition: "max-height 0.35s cubic-bezier(.4,0,.2,1), opacity 0.35s cubic-bezier(.4,0,.2,1)",
                                      opacity: expanded ? 1 : 0,
                                    }}
                                  >
                                    <Paper p="md" radius="md"  style={{ margin: 0, background: "#f8fafc" }}>
                                      <Grid gutter="md" mb="md">
                                        <Grid.Col span={6}>
                                          <Text size="sm" fw={500}><b>Phone:</b> {applicant.phone}</Text>
                                          <Text size="sm" fw={500}><b>Town:</b> {applicant.town}</Text>
                                          <Text size="sm" fw={500}><b>State:</b> {applicant.state}</Text>
                                          <Text size="sm" fw={500}><b>Zip:</b> {applicant.zip}</Text>
                                        </Grid.Col>
                                        <Grid.Col span={6}>
                                          <Text size="sm" fw={500}><b>Availability:</b> {applicant.shift}</Text>
                                          <Text size="sm" fw={500}><b>Date of Birth:</b> {applicant.dob}</Text>
                                          <Text size="sm" fw={500}><b>Role:</b> {applicant.role}</Text>
                                          <Text size="sm" fw={500}><b>Bio:</b> {applicant.bio}</Text>
                                        </Grid.Col>
                                      </Grid>
                
                                      <Group mt="md">
                                        <Button color="green" variant="light" radius="xl">Accept</Button>
                                        <Button color="red" variant="light" radius="xl">Decline</Button>
                                      </Group>
                                    </Paper>
                                  </div>
                                </td>
                              </tr>
                            </>
                          );
                        }
                        return <ApplicantRow key={applicant.email} />;
                      })}
                    </Table.Tbody>
                  </Table>
                </Paper>
              </Modal>
            </Paper>
          </Grid.Col>
          <Grid.Col mt={'xl'} span={6}>
            <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#f1f3f5' }}>
              <Title order={3} mb="md">Today's Volunteer Schedule</Title>
              <Stack spacing="md">
                <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#fff' }}>
                  <Text fw={700} size="lg" mb="xs">8:00 AM - 12:00 PM</Text>
                  <Text size="sm" color="dimmed">Morning Shift</Text>
                  <Stack mt="sm" spacing="xs">
                    <Text size="sm"><b>John Doe</b> - Server</Text>
                    <Text size="sm"><b>Sarah Johnson</b> - Cook</Text>
                  </Stack>
                </Paper>
                <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#fff' }}>
                  <Text fw={700} size="lg" mb="xs">12:00 PM - 4:00 PM</Text>
                  <Text size="sm" color="dimmed">Afternoon Shift</Text>
                  <Stack mt="sm" spacing="xs">
                    <Text size="sm"><b>Mike Chen</b> - Server</Text>
                    <Text size="sm"><b>Emily Rodriguez</b> - Cook</Text>
                    <Text size="sm"><b>David Thompson</b> - Server</Text>
                  </Stack>
                </Paper>
                <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#fff' }}>
                  <Text fw={700} size="lg" mb="xs">4:00 PM - 8:00 PM</Text>
                  <Text size="sm" color="dimmed">Evening Shift</Text>
                  <Stack mt="sm" spacing="xs">
                    <Text size="sm"><b>Lisa Wang</b> - Server</Text>
                    <Text size="sm"><b>Robert Martinez</b> - Cook</Text>
                  </Stack>
                </Paper>
                <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#fff' }}>
                  <Text fw={700} size="lg" mb="xs">On Call</Text>
                  <Text size="sm" color="dimmed">Backup Volunteers</Text>
                  <Stack mt="sm" spacing="xs">
                    <Text size="sm"><b>Jennifer Lee</b> - Server</Text>
                  </Stack>
                </Paper>
              </Stack>
            </Paper>
          </Grid.Col>
        </Grid>
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
                    <TextInput p={'sm'} radius={'xl'} placeholder="Type your message..." leftSection={<IconMessage size={16} />} rightSection={<Button p={0} variant="light" size="xs" radius="xl"><IconSend /></Button>} />
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