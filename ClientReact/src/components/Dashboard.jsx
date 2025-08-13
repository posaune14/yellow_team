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
    IconInfoCircle,
    IconCheck,
    IconDeviceFloppy
  } from '@tabler/icons-react'
  import { useState } from 'react'
  import { notifications } from '@mantine/notifications'
  import axios from 'axios'
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
                  <Text size="xs" colo="dimmed">2:00 PM – 4:00 PM</Text>
                  <Button mt="sm" fullWidth radius="xl" variant="gradient" gradient={{ from: 'teal', to: 'green' }}>
                    Start Meeting
                  </Button>
                </Paper>
              </Grid.Col>
              <Grid.Col span={12}>
                <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#f1f3f5', marginTop: '1rem' }}>
                  <Text fw={700} size="md" mb="xs">Current Stream Post</Text>
                  <Blockquote color="blue" p="md" rightSection={<Text>12.24.2025 12:00 PM</Text>}>
                    <Text>
                      Latest Stream Post goes here
                    </Text>
                  </Blockquote>
                </Paper>
              </Grid.Col>
            </Grid>
          </Stack>
    )
  }

 

  function InvItems({ item, editing, onSave }){
    const [currentValue, setCurrentValue] = useState(item.current)
    const [fullValue, setFullValue] = useState(item.full)
    const [isEditing, setIsEditing] = useState(false)
    
    const handleSave = () => {
      onSave(item.name, currentValue, fullValue)
      setIsEditing(false)
    }
    
    const handleCancel = () => {
      setCurrentValue(item.current)
      setFullValue(item.full)
      setIsEditing(false)
    }
    
    return(
      <Grid.Col span={2} key={`${item.name}-${item.type}`}>
        <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: item.current / item.full >= .35 ? '#f4fbf6' : '#fff5f5' }} >
          <Text size="lg" color="darks">{item.name}</Text>
          {!isEditing ? (
            <Text size="xl" fw={700} style={{ color: item.current / item.full >= .35 ? 'green' : 'red' }}>
              {item.current}/{item.full}
            </Text>
          ) : (
            <Stack spacing="xs" mt="xs">
              <Group gap="xs" justify="center">
                <TextInput
                  variant="filled"
                  size="xs"
                  placeholder={item.current.toString()}
                  value={currentValue}
                  onChange={(e) => setCurrentValue(parseInt(e.target.value) || 0)}
                  style={{ width: '60px' }}
                  styles={{
                    input: {
                      textAlign: 'center',
                      fontSize: '14px',
                      fontWeight: 600
                    }
                  }}
                />
                <Text size="sm" fw={600}>/</Text>
                <TextInput
                  variant="filled"
                  size="xs"
                  placeholder={item.full.toString()}
                  value={fullValue}
                  onChange={(e) => setFullValue(parseInt(e.target.value) || 0)}
                  style={{ width: '60px' }}
                  styles={{
                    input: {
                      textAlign: 'center',
                      fontSize: '14px',
                      fontWeight: 600
                    }
                  }}
                />
              </Group>
              <Group gap="xs" justify="center">
                <Button 
                  size="xs" 
                  color="green" 
                  onClick={handleSave}
                  radius="sm"
                >
                  Save
                </Button>
                <Button 
                  size="xs" 
                  variant="light" 
                  color="gray" 
                  onClick={handleCancel}
                  radius="sm"
                >
                  Cancel
                </Button>
              </Group>
            </Stack>
          )}
          {editing && !isEditing && (
            <Button 
              size="xs" 
              variant="light" 
              color="blue" 
              onClick={() => setIsEditing(true)}
              mt="xs"
              radius="sm"
              fullWidth
            >
              Edit
            </Button>
          )}
        </Paper>
      </Grid.Col>
    )
  }
  const Inventory = ()=> {
    
    //maybe use a switch?
    const [sort, setSort] = useState("") 
    const [editing, setEditing] = useState(false)
    const [confirmSave, setConfirmSave] = useState(false)
    const [addNewModal, setAddNewModal] = useState(false)
    const [newItem, setNewItem] = useState({
      name: '',
      current: 0,
      full: 0,
      type: 'Vegetables'
    })
    const [items, setItems] = useState([
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
    ])

    const handleSaveItem = (itemName, current, full) => {
      setItems(prevItems => 
        prevItems.map(item => 
          item.name === itemName 
            ? { ...item, current, full }
            : item
        )
      )
      
      // Show success notification
      notifications.show({
        title: 'Inventory Updated!',
        message: `${itemName} quantity has been updated to ${current}/${full}`,
        color: 'green',
        icon: <IconCheck size={16} />,
        autoClose: 3000,
        withCloseButton: true,
      })
    }

    const handleSaveAll = () => {
      setConfirmSave(false)
      setEditing(false)
      
      // Show success notification
      notifications.show({
        title: 'All Changes Saved!',
        message: 'Your inventory has been updated successfully.',
        color: 'green',
        icon: <IconCheck size={16} />,
        autoClose: 3000,
        withCloseButton: true,
      })
    }

    const handleAddNewItem = () => {
      if (!newItem.name.trim()) {
        notifications.show({
          title: 'Error!',
          message: 'Please enter a name for the item.',
          color: 'red',
          icon: <IconInfoCircle size={16} />,
          autoClose: 3000,
          withCloseButton: true,
        })
        return
      }

      if (newItem.current > newItem.full) {
        notifications.show({
          title: 'Error!',
          message: 'Current quantity cannot be greater than full capacity.',
          color: 'red',
          icon: <IconInfoCircle size={16} />,
          autoClose: 3000,
          withCloseButton: true,
        })
        return
      }

      // Check if item already exists
      const itemExists = items.some(item => item.name.toLowerCase() === newItem.name.toLowerCase())
      if (itemExists) {
        notifications.show({
          title: 'Error!',
          message: 'An item with this name already exists.',
          color: 'red',
          icon: <IconInfoCircle size={16} />,
          autoClose: 3000,
          withCloseButton: true,
        })
        return
      }

      setItems(prevItems => [...prevItems, { ...newItem, name: newItem.name.trim() }])
      
      // Reset form
      setNewItem({
        name: '',
        current: 0,
        full: 0,
        type: 'Vegetables'
      })
      
      setAddNewModal(false)
      
      // Show success notification
      notifications.show({
        title: 'Item Added!',
        message: `${newItem.name.trim()} has been added to your inventory.`,
        color: 'green',
        icon: <IconCheck size={16} />,
        autoClose: 3000,
        withCloseButton: true,
      })
    }

    const handleCancelAdd = () => {
      setNewItem({
        name: '',
        current: 0,
        full: 0,
        type: 'Vegetables'
      })
      setAddNewModal(false)
    }

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
          <Group gap="md">
            <Button 
              variant="light" 
              color="green"
              onClick={() => setAddNewModal(true)}
              leftSection={<IconCheck size={16} />}
            >
              Add New Item
            </Button>
            <Button 
              variant={editing ? 'filled' : 'light'} 
              color={editing ? 'green' : 'blue'}
              onClick={()=> setEditing(!editing)}
              leftSection={editing ? <IconCheck size={16} /> : <IconSettings size={16} />}
            >
              {editing ? 'Exit Edit Mode' : 'Edit'}
            </Button>
            {editing && (
              <Button 
                variant="filled" 
                color="green"
                onClick={() => setConfirmSave(true)}
                leftSection={<IconDeviceFloppy size={16} />}
              >
                Save Changes
              </Button>
            )}
          </Group>
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
            <InvItems 
              key={index} 
              item={item} 
              editing={editing} 
              onSave={handleSaveItem}
            />
          ))}
        </Grid>

        {/* Add New Item Modal */}
        <Modal 
          opened={addNewModal} 
          onClose={handleCancelAdd} 
          centered 
          size="md" 
          radius="md" 
          padding="lg"
          title={
            <Group>
              <IconCheck size={20} />
              <Text fw={600}>Add New Inventory Item</Text>
            </Group>
          }
        >
          <Paper m={0} p="xl" radius="md" withBorder style={{ backgroundColor: "#f8fafc" }}>
            <Stack spacing="lg">
              <Text size="sm" color="dimmed" mb="md">
                Enter the details for the new inventory item.
              </Text>
              
              <TextInput 
                label="Item Name"
                placeholder="Enter item name" 
                value={newItem.name}
                onChange={(e) => setNewItem({...newItem, name: e.target.value})}
                radius="md"
                size="md"
                required
                styles={{
                  input: {
                    border: '1px solid #e9ecef',
                    '&:focus': {
                      borderColor: '#228be6',
                    }
                  }
                }}
              />
              
              <Select
                label="Item Type"
                placeholder="Select item type"
                data={['Fruits', 'Vegetables', 'Proteins', 'Nonperishable']}
                value={newItem.type}
                onChange={(value) => setNewItem({...newItem, type: value})}
                radius="md"
                size="md"
                required
                styles={{
                  input: {
                    border: '1px solid #e9ecef',
                    '&:focus': {
                      borderColor: '#228be6',
                    }
                  }
                }}
              />
              
              <Group grow>
                <TextInput 
                  label="Current Quantity"
                  placeholder="0" 
                  type="number"
                  min={0}
                  value={newItem.current}
                  onChange={(e) => setNewItem({...newItem, current: parseInt(e.target.value) || 0})}
                  radius="md"
                  size="md"
                  required
                  styles={{
                    input: {
                      border: '1px solid #e9ecef',
                      '&:focus': {
                        borderColor: '#228be6',
                      }
                    }
                  }}
                />
                
                <TextInput 
                  label="Full Capacity"
                  placeholder="0" 
                  type="number"
                  min={0}
                  value={newItem.full}
                  onChange={(e) => setNewItem({...newItem, full: parseInt(e.target.value) || 0})}
                  radius="md"
                  size="md"
                  required
                  styles={{
                    input: {
                      border: '1px solid #e9ecef',
                      '&:focus': {
                        borderColor: '#228be6',
                      }
                    }
                  }}
                />
              </Group>
              
              <Group justify="flex-end" mt="xl" gap="md">
                <Button 
                  variant="light" 
                  color="gray" 
                  onClick={handleCancelAdd}
                  radius="md"
                >
                  Cancel
                </Button>
                <Button 
                  onClick={handleAddNewItem}
                  leftSection={<IconCheck size={16} />}
                  radius="md"
                  color="green"
                >
                  Add Item
                </Button>
              </Group>
            </Stack>
          </Paper>
        </Modal>

        {/* Confirmation Modal */}
        <Modal 
          opened={confirmSave} 
          onClose={() => setConfirmSave(false)} 
          centered 
          size="sm" 
          radius="md" 
          padding="lg"
        >
          <Paper m={0} p="xl" radius="md" withBorder style={{ backgroundColor: "#f8fafc" }}>
            <Stack spacing="lg" align="center">
              <IconCheck size={48} color="#40c057" />
              <Title order={3} ta="center">Confirm Inventory Changes</Title>
              <Text size="sm" color="dimmed" ta="center">
                Are you sure you want to save all the changes made to your inventory?
              </Text>
              
              <Group justify="center" gap="md" mt="md">
                <Button 
                  variant="light" 
                  color="gray" 
                  onClick={() => setConfirmSave(false)}
                  radius="md"
                >
                  Cancel
                </Button>
                <Button 
                  onClick={handleSaveAll}
                  leftSection={<IconCheck size={16} />}
                  radius="md"
                  color="green"
                >
                  Confirm Save
                </Button>
              </Group>
            </Stack>
          </Paper>
        </Modal>
      </>
    )
  }
  const Volunteer = ()=> {

    const [volunteerInfo, setVolunteerInfo] = useState(false)
    const [inboxInfo, setInboxInfo] = useState(false)

    //const volunteers = [{name: "Big M", email: "BigM@gmail.com", phone: "9083315271", zip:"08502", dob:"3/11/2011", town: "Belle Mead", state: "NJ", shift:"Mornings", role:"Server", emergencyName: "Mike", emergencyPhone:"9179683021"}]
    
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
                  {[{
                      name: "Big M", 
                      email: "BigM@gmail.com", 
                      phone: "9083315271", 
                      zip:"08502",
                      dob:"3/11/2011", 
                      town: "Belle Mead", 
                      state: "NJ", 
                      shift:"Mornings", 
                      role:"Server",
                      emergencyName: "Mike", 
                      emergencyPhone:"9179683021"
                  }].map((volunteer, idx)=> {
                  return(
                    <Table.Tr>
                    <Modal p={0} opened={volunteerInfo} onClose={()=> setVolunteerInfo(false)} centered size="lg" radius="md" padding="lg">
                      
                        <Paper m={0} p="md" radius="md" withBorder style={{ backgroundColor: "#f8fafc" }}>
                          <Group align="center" mb="md" spacing="lg">
                            <Avatar size={64} radius="xl" color="blue">JD</Avatar>
                            <div>
                              <Title order={3} mb={2}>{volunteer.name}</Title>
                              <Text size="sm" color="dimmed">{volunteer.email}</Text>
                            </div>
                          </Group>
                          <Grid gutter="md" mb="md">
                            <Grid.Col span={6}>
                              <Text size="sm" fw={500}><b>Phone:</b> {volunteer.phone}</Text>
                              <Text size="sm" fw={500}><b>Town:</b> {volunteer.town}</Text>
                              <Text size="sm" fw={500}><b>State:</b> {volunteer.state}</Text>
                              <Text size="sm" fw={500}><b>Zip:</b> {volunteer.zip}</Text>
                            </Grid.Col>
                            <Grid.Col span={6}>
                              <Text size="sm" fw={500}><b>Shift:</b> {volunteer.shift}</Text>
                              <Text size="sm" fw={500}><b>Date of Birth:</b> {volunteer.dob}</Text>
                              <Text size="sm" fw={500}><b>Preferred Role:</b> {volunteer.role}</Text>
                            </Grid.Col>
                            
                          </Grid>
                          <Paper p="sm" radius="md" withBorder bg="gray.0">
                            <Title order={5} mb={4} color="blue">Emergency Contact</Title>
                            <Text size="sm" fw={500}><b>Name:</b> {volunteer.emergencyName}</Text>
                            <Text size="sm" fw={500}><b>Phone:</b> {volunteer.emergencyPhone}</Text>
                          </Paper>
                        </Paper>
                    </Modal>
                    <Table.Td>{volunteer.name}</Table.Td>
                    <Table.Td>{volunteer.email}</Table.Td>
                    <Table.Td><Button variant="light" color="gray" radius="xl" onClick={()=> setVolunteerInfo(true)}><IconInfoCircle size={20} /></Button></Table.Td>
                  </Table.Tr>
                  )})}
                  
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
    let [settings, setSettings] = useState(false)
    const [foodBankName, setFoodBankName] = useState("TASK Food Bank")
    const [foodBankAddress, setFoodBankAddress] = useState("123 Main St, Belle Mead, NJ 08502")
    const [foodBankPhone, setFoodBankPhone] = useState("(609) 123-4567")
    const [foodBankEmail, setFoodBankEmail] = useState("info@taskfoodbank.org")
    
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
              <NavLink label="Settings" icon={<IconSettings size={20} />} onClick={()=> {
                setSettings(true)
              }}/>
              <NavLink label="Logout" color='red' onClick={()=> {
                localStorage.removeItem('token');
                window.location.href = '/';
              }}/>
            </Box>
          </ScrollArea>
        </AppShell.Navbar>
        
        <Modal opened={settings} onClose={()=> setSettings(false)} centered size="lg" radius="md" padding="lg">
          <Paper m={0} p="md" radius="md" withBorder style={{ backgroundColor: "#f8fafc" }}>
            <Title order={3} mb="lg">Settings</Title>
            <Stack spacing="md">
              <TextInput 
                label="Food Bank Name"
                placeholder="Food Bank Name" 
                value={foodBankName}
                onChange={(e) => setFoodBankName(e.target.value)}
              />
              <TextInput 
                label="Food Bank Address"
                placeholder="Food Bank Address" 
                value={foodBankAddress}
                onChange={(e) => setFoodBankAddress(e.target.value)}
              />
              <TextInput 
                label="Food Bank Phone"
                placeholder="Food Bank Phone" 
                value={foodBankPhone}
                onChange={(e) => setFoodBankPhone(e.target.value)}
              />
              <TextInput 
                label="Food Bank Email"
                placeholder="Food Bank Email" 
                value={foodBankEmail}
                onChange={(e) => setFoodBankEmail(e.target.value)}
              />
              <Group justify="flex-end" mt="md">
                <Button variant="light" onClick={() => setSettings(false)}>
                  Cancel
                </Button>
                <Button onClick={() => {
                  // Here you would typically save the settings
                  console.log('Saving settings:', { foodBankName, foodBankAddress, foodBankPhone, foodBankEmail });
                  setSettings(false);
                }}>
                  Save Changes
                </Button>
              </Group>
            </Stack>
          </Paper>
        </Modal>
  

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
                  <Menu.Item color='red' onClick={()=> {
                    localStorage.removeItem('token');
                    window.location.href = '/';
                  }}>Log Out</Menu.Item>
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