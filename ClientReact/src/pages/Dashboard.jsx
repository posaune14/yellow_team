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
  import { useState, useEffect } from 'react'
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
    const [loading, setLoading] = useState(false)
    const [newItem, setNewItem] = useState({
      name: '',
      current: 0,
      full: 0,
      type: 'Vegetables'
    })
    const [items, setItems] = useState([])
    
    // API Base URL
    const API_BASE_URL = 'http://localhost:3000';
    
    // Get pantry ID from user data
    const getPantryId = () => {
      const userData = JSON.parse(localStorage.getItem('user_data') || '{}');
      return userData._id;
    };
    
    // Fetch inventory from API
    const fetchInventory = async () => {
      try {
        setLoading(true);
        const pantryId = getPantryId();
        if (!pantryId) {
          notifications.show({
            title: 'Error',
            message: 'Pantry ID not found. Please sign in again.',
            color: 'red',
            icon: <IconInfoCircle size={16} />,
            autoClose: 3000,
          });
          return;
        }
        
        const response = await axios.get(`${API_BASE_URL}/pantry/${pantryId}/inventory`);
        setItems(response.data.inventory || []);
      } catch (error) {
        console.error('Error fetching inventory:', error);
        notifications.show({
          title: 'Error',
          message: 'Failed to fetch inventory. Using default data.',
          color: 'orange',
          icon: <IconInfoCircle size={16} />,
          autoClose: 3000,
        });
        // Fallback to default data if API fails
        setItems([
          { name: 'Tomatoe', current: 44, full: 50, type: 'Vegetables' },
          { name: 'Brocoli', current: 5, full: 50, type: 'Nonperishable' },
          { name: 'Carrots', current: 30, full: 50, type: 'Vegetables' },
          { name: 'Apples', current: 50, full: 50, type: 'Fruits' },
          { name: 'Tuna Can', current: 12, full: 40, type: 'Nonperishable' },
          { name: 'Chicken Breast', current: 22, full: 50, type: 'Proteins' },
          { name: 'Bananas', current: 18, full: 50, type: 'Fruits' },
          { name: 'Spinach', current: 35, full: 50, type: 'Vegetables' },
          { name: 'Beans (Dry)', current: 44, full: 50, type: 'Nonperishable' },
          { name: 'Eggs', current: 10, full: 30, type: 'Proteins' }
        ]);
      } finally {
        setLoading(false);
      }
    };
    
    // Fetch inventory on component mount
    useEffect(() => {
      fetchInventory();
    }, []);

    const handleSaveItem = async (itemName, current, full) => {
      try {
        const pantryId = getPantryId();
        if (!pantryId) {
          notifications.show({
            title: 'Error',
            message: 'Pantry ID not found. Please sign in again.',
            color: 'red',
            icon: <IconInfoCircle size={16} />,
            autoClose: 3000,
          });
          return;
        }
        
        // Update via API
        await axios.put(`${API_BASE_URL}/pantry/${pantryId}/inventory/${encodeURIComponent(itemName)}`, {
          current,
          full
        });
        
        // Update local state
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
      } catch (error) {
        console.error('Error updating inventory item:', error);
        notifications.show({
          title: 'Error',
          message: 'Failed to update inventory item. Please try again.',
          color: 'red',
          icon: <IconInfoCircle size={16} />,
          autoClose: 3000,
          withCloseButton: true,
        });
      }
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

    const handleAddNewItem = async () => {
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

      try {
        const pantryId = getPantryId();
        if (!pantryId) {
          notifications.show({
            title: 'Error',
            message: 'Pantry ID not found. Please sign in again.',
            color: 'red',
            icon: <IconInfoCircle size={16} />,
            autoClose: 3000,
          });
          return;
        }

        // Add via API
        const itemToAdd = { ...newItem, name: newItem.name.trim() };
        await axios.post(`${API_BASE_URL}/pantry/${pantryId}/inventory`, itemToAdd);
        
        // Update local state
        setItems(prevItems => [...prevItems, itemToAdd])
        
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
          message: `${itemToAdd.name} has been added to your inventory.`,
          color: 'green',
          icon: <IconCheck size={16} />,
          autoClose: 3000,
          withCloseButton: true,
        })
      } catch (error) {
        console.error('Error adding inventory item:', error);
        notifications.show({
          title: 'Error!',
          message: 'Failed to add inventory item. Please try again.',
          color: 'red',
          icon: <IconInfoCircle size={16} />,
          autoClose: 3000,
          withCloseButton: true,
        });
      }
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
        
        {loading ? (
          <Center p="xl">
            <Loader size="md" />
            <Text ml="md">Loading inventory...</Text>
          </Center>
        ) : (
          <Grid p={'xl'}>
            {filteredItems.length === 0 ? (
              <Grid.Col span={12}>
                <Center p="xl">
                  <Text color="dimmed">No inventory items found. Add some items to get started!</Text>
                </Center>
              </Grid.Col>
            ) : (
              filteredItems.map((item, index) => (
                <InvItems 
                  key={`${item.name}-${index}`} 
                  item={item} 
                  editing={editing} 
                  onSave={handleSaveItem}
                />
              ))
            )}
          </Grid>
        )}

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
    const [volunteers, setVolunteers] = useState([])
    const [inboxVolunteers, setInboxVolunteers] = useState([])
    const [loading, setLoading] = useState(true)
    
    // Volunteer Schedule State
    const [volunteerSchedule, setVolunteerSchedule] = useState([
      {
        id: 1,
        time: "8:00 AM - 12:00 PM",
        shift: "Morning Shift",
        volunteers: [
          { name: " ", role: " " }
        ]
      },
      {
        id: 2,
        time: "12:00 PM - 4:00 PM",
        shift: "Afternoon Shift",
        volunteers: [
          { name: " ", role: " " }
        ]
      },
      {
        id: 3,
        time: "4:00 PM - 8:00 PM",
        shift: "Evening Shift",
        volunteers: [
          { name: " ", role: " " }
        ]
      },
      {
        id: 4,
        time: "On Call",
        shift: "Backup Volunteers",
        volunteers: [
          { name: " ", role: " " }
        ]
      }
    ]);

    const [isEditing, setIsEditing] = useState(false);
    const [editingSchedule, setEditingSchedule] = useState([]);

    // API Base URL - corrected to match server port
    const API_BASE_URL = 'http://localhost:3000';

    // Fetch volunteers from backend
    const fetchVolunteers = async () => {
      try {
        setLoading(true);
        const response = await axios.get(`${API_BASE_URL}/volunteer/get`);
        const allVolunteers = response.data;
        
        // Separate verified and unverified volunteers
        const verifiedVolunteers = allVolunteers.filter(vol => vol.verified === true || vol.verified === "True");
        const unverifiedVolunteers = allVolunteers.filter(vol => vol.verified === false || vol.verified === "False");
        
        setVolunteers(verifiedVolunteers);
        setInboxVolunteers(unverifiedVolunteers);
      } catch (error) {
        console.error('Error fetching volunteers:', error);
        notifications.show({
          title: 'Error',
          message: 'Failed to fetch volunteers',
          color: 'red',
          icon: <IconInfoCircle size={16} />,
          autoClose: 3000,
        });
      } finally {
        setLoading(false);
      }
    };

    const handleAcceptVolunteer = async (volunteerId) => {
      try {
        const volunteer = inboxVolunteers.find(v => v._id === volunteerId);
        if (!volunteer) return;

        const updateData = {
          ...volunteer,
          verified: true
        };

        await axios.put(`${API_BASE_URL}/volunteer/update/${volunteerId}`, updateData);
        
        // Refresh the volunteer lists
        await fetchVolunteers();
        
        notifications.show({
          title: 'Volunteer Accepted!',
          message: `${volunteer.first_name} ${volunteer.last_name} has been verified`,
          color: 'green',
          icon: <IconCheck size={16} />,
          autoClose: 3000,
        });
      } catch (error) {
        console.error('Error accepting volunteer:', error);
        notifications.show({
          title: 'Error',
          message: 'Failed to accept volunteer',
          color: 'red',
          icon: <IconInfoCircle size={16} />,
          autoClose: 3000,
        });
      }
    };

    // Handle volunteer rejection (decline)
    const handleDeclineVolunteer = async (volunteerId) => {
      try {
        const volunteer = inboxVolunteers.find(v => v._id === volunteerId);
        if (!volunteer) return;

        await axios.delete(`${API_BASE_URL}/volunteer/delete/${volunteerId}`);
        
        // Refresh the volunteer lists
        await fetchVolunteers();
        
        notifications.show({
          title: 'Volunteer Declined',
          message: `${volunteer.first_name} ${volunteer.last_name} has been removed`,
          color: 'orange',
          icon: <IconInfoCircle size={16} />,
          autoClose: 3000,
        });
      } catch (error) {
        console.error('Error declining volunteer:', error);
        notifications.show({
          title: 'Error',
          message: 'Failed to decline volunteer',
          color: 'red',
          icon: <IconInfoCircle size={16} />,
          autoClose: 3000,
        });
      }
    };


    const handleDeleteVolunteer = async (volunteerId) => {
      try {
        const volunteer = volunteers.find(v => v._id === volunteerId);
        if (!volunteer) return;

        await axios.delete(`${API_BASE_URL}/volunteer/delete/${volunteerId}`);
 
        await fetchVolunteers();
        
        notifications.show({
          title: 'Volunteer Deleted',
          message: `${volunteer.first_name} ${volunteer.last_name} has been removed`,
          color: 'red',
          icon: <IconInfoCircle size={16} />,
          autoClose: 3000,
        });
      } catch (error) {
        console.error('Error deleting volunteer:', error);
        notifications.show({
          title: 'Error',
          message: 'Failed to delete volunteer',
          color: 'red',
          icon: <IconInfoCircle size={16} />,
          autoClose: 3000,
        });
      }
    };

    // Fetch volunteers on component mount
    useEffect(() => {
      fetchVolunteers();
    }, []);

    const handleEdit = () => {
      setEditingSchedule(JSON.parse(JSON.stringify(volunteerSchedule)));
      setIsEditing(true);
    };

    const handleSave = () => {
      setVolunteerSchedule(editingSchedule);
      setIsEditing(false);
    };

    const handleCancel = () => {
      setIsEditing(false);
    };

    const updateVolunteer = (shiftId, volunteerIndex, field, value) => {
      setEditingSchedule(prev => 
        prev.map(shift => 
          shift.id === shiftId 
            ? {
                ...shift,
                volunteers: shift.volunteers.map((vol, idx) => 
                  idx === volunteerIndex 
                    ? { ...vol, [field]: value }
                    : vol
                )
              }
            : shift
        )
      );
    };

    const addVolunteer = (shiftId) => {
      setEditingSchedule(prev => 
        prev.map(shift => 
          shift.id === shiftId 
            ? {
                ...shift,
                volunteers: [...shift.volunteers, { name: "", role: "" }]
              }
            : shift
        )
      );
    };

    const removeVolunteer = (shiftId, volunteerIndex) => {
      setEditingSchedule(prev => 
        prev.map(shift => 
          shift.id === shiftId 
            ? {
                ...shift,
                volunteers: shift.volunteers.filter((_, idx) => idx !== volunteerIndex)
              }
            : shift
        )
      );
    };

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
              {loading ? (
                <Center p="xl">
                  <Loader size="md" />
                  <Text ml="md">Loading volunteers...</Text>
                </Center>
              ) : (
                <Table>
                  <Table.Thead>
                    <Table.Tr>
                      <Table.Th>Name</Table.Th>
                      <Table.Th>Email</Table.Th>
                      <Table.Th>Actions</Table.Th>
                    </Table.Tr>
                  </Table.Thead>
                  <Table.Tbody>
                    {volunteers.length === 0 ? (
                      <Table.Tr>
                        <Table.Td colSpan={3}>
                          <Center p="md">
                            <Text color="dimmed">No verified volunteers found</Text>
                          </Center>
                        </Table.Td>
                      </Table.Tr>
                    ) : (
                      volunteers.map((volunteer, idx)=> (
                    <Table.Tr key={volunteer._id}>
                    <Modal p={0} opened={volunteerInfo} onClose={()=> setVolunteerInfo(false)} centered size="lg" radius="md" padding="lg">
                      
                        <Paper m={0} p="md" radius="md" withBorder style={{ backgroundColor: "#f8fafc" }}>
                          <Group align="center" mb="md" spacing="lg">
                            <Avatar size={64} radius="xl" color="blue">
                              {volunteer.first_name?.[0]}{volunteer.last_name?.[0]}
                            </Avatar>
                            <div>
                              <Title order={3} mb={2}>{volunteer.first_name} {volunteer.last_name}</Title>
                              <Text size="sm" color="dimmed">{volunteer.email}</Text>
                            </div>
                          </Group>
                          <Grid gutter="md" mb="md">
                            <Grid.Col span={6}>
                              <Text size="sm" fw={500}><b>Phone:</b> {volunteer.phone_number}</Text>
                              <Text size="sm" fw={500}><b>Zip:</b> {volunteer.zipcode}</Text>
                              <Text size="sm" fw={500}><b>Date of Birth:</b> {volunteer.date_of_birth}</Text>
                            </Grid.Col>
                            <Grid.Col span={6}>
                              <Text size="sm" fw={500}><b>Availability:</b> {volunteer.availability}</Text>
                              <Text size="sm" fw={500}><b>Roles:</b> {volunteer.roles}</Text>
                              <Text size="sm" fw={500}><b>Verified:</b> {volunteer.verified ? 'Yes' : 'No'}</Text>
                            </Grid.Col>
                            
                          </Grid>
                          <Paper p="sm" radius="md" withBorder bg="gray.0">
                            <Title order={5} mb={4} color="blue">Emergency Contact</Title>
                            <Text size="sm" fw={500}><b>Name:</b> {volunteer.emergency_name}</Text>
                            <Text size="sm" fw={500}><b>Phone:</b> {volunteer.emergency_number}</Text>
                          </Paper>
                          <Group mt="md">
                            <Button color='blue' onClick={(e) => window.location.href = `mailto:${volunteer.email}`}>Email</Button>
                            <Button color='red' onClick={() => handleDeleteVolunteer(volunteer._id)}>DELETE</Button>
                          </Group>
                        </Paper>
                    </Modal>
                    <Table.Td>{volunteer.first_name} {volunteer.last_name}</Table.Td>
                    <Table.Td>{volunteer.email}</Table.Td>
                    <Table.Td><Button variant="light" color="gray" radius="xl" onClick={()=> setVolunteerInfo(true)}><IconInfoCircle size={20} /></Button></Table.Td>
                  </Table.Tr>
                  ))
                  )}
                  </Table.Tbody>
                </Table>
              )}
            </Paper>
            
            {/* Inbox Section under Volunteers List */}
            <Paper mt={'xl'} p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#f1f3f5' }}>
              <Title order={3} mb="md">Inbox</Title>
              <Button variant="gradient" gradient={{ from: 'teal', to: 'green' }} radius="xl" onClick={()=> setInboxInfo(true)}>
                Open Inbox
                {inboxVolunteers.length > 0 && <Badge p={5} m={5} color="red">{inboxVolunteers.length}</Badge>}
              </Button>
              <Modal p={0} opened={inboxInfo} onClose={()=> setInboxInfo(false)} centered size="lg" radius="md" padding="lg">
                <Paper m={0} p="md" radius="md" withBorder style={{ backgroundColor: "#f8fafc" }}>
                  <Title order={3}>Inbox</Title>
                  {inboxVolunteers.length === 0 ? (
                    <Center p="xl">
                      <Text color="dimmed">No pending volunteer applications</Text>
                    </Center>
                  ) : (
                    <Table>
                      <Table.Thead>
                        <Table.Tr>
                          <Table.Th>Name</Table.Th>
                          <Table.Th>Email</Table.Th>
                        </Table.Tr>
                      </Table.Thead>
                      <Table.Tbody>
                        {inboxVolunteers.map((applicant, idx) => {
                          // Create a component for each row to manage its own state
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
                                  {applicant.first_name} {applicant.last_name}
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
                                          <Text size="sm" fw={500}><b>Phone:</b> {applicant.phone_number}</Text>
                                          <Text size="sm" fw={500}><b>Zip:</b> {applicant.zipcode}</Text>
                                          <Text size="sm" fw={500}><b>Date of Birth:</b> {applicant.date_of_birth}</Text>
                                        </Grid.Col>
                                        <Grid.Col span={6}>
                                          <Text size="sm" fw={500}><b>Availability:</b> {applicant.availability}</Text>
                                          <Text size="sm" fw={500}><b>Roles:</b> {applicant.roles}</Text>
                                          <Text size="sm" fw={500}><b>Emergency Contact:</b> {applicant.emergency_name} - {applicant.emergency_number}</Text>
                                        </Grid.Col>
                                      </Grid>
                
                                      <Group mt="md">
                                        <Button color="green" variant="light" radius="xl" onClick={() => handleAcceptVolunteer(applicant._id)}>Accept</Button>
                                        <Button color="red" variant="light" radius="xl" onClick={() => handleDeclineVolunteer(applicant._id)}>Decline</Button>
                                      </Group>
                                    </Paper>
                                  </div>
                                </td>
                              </tr>
                            </>
                            );
                          }
                          return <ApplicantRow key={applicant._id} />;
                        })}
                      </Table.Tbody>
                    </Table>
                  )}
                </Paper>
              </Modal>
            </Paper>
          </Grid.Col>
          <Grid.Col mt={'xl'} span={6}>
            <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#f1f3f5' }}>
              <Title order={3} mb="md">Today's Volunteer Schedule</Title>

                             <Stack spacing="md">
                 {(isEditing ? editingSchedule : volunteerSchedule).map((shift) => (
                   <Paper key={shift.id} p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#fff' }}>
                     <Text fw={700} size="lg" mb="xs">{shift.time}</Text>
                     <Text size="sm" color="dimmed">{shift.shift}</Text>
                     <Stack mt="sm" spacing="xs">
                       {shift.volunteers.map((volunteer, volIndex) => (
                         <div key={volIndex} style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                           {isEditing ? (
                             <>
                               <Select
                                 size="xs"
                                 placeholder="Select volunteer"
                                 value={volunteer.name}
                                 onChange={(value) => updateVolunteer(shift.id, volIndex, 'name', value)}
                                 style={{ flex: 1 }}
                                 data={volunteers.map(vol => ({
                                   value: `${vol.first_name} ${vol.last_name}`,
                                   label: `${vol.first_name} ${vol.last_name}`
                                 }))}
                                 searchable
                                 clearable
                               />
                               <TextInput
                                 size="xs"
                                 placeholder="Role"
                                 value={volunteer.role}
                                 onChange={(e) => updateVolunteer(shift.id, volIndex, 'role', e.target.value)}
                                 style={{ flex: 1 }}
                               />
                               <Button
                                 size="xs"
                                 color="red"
                                 variant="light"
                                 onClick={() => removeVolunteer(shift.id, volIndex)}
                               >
                                 Remove
                               </Button>
                             </>
                           ) : (
                             <Text size="sm"><b>{volunteer.name}</b> - {volunteer.role}</Text>
                           )}
                         </div>
                       ))}
                       {isEditing && (
                         <Button
                           size="xs"
                           variant="light"
                           onClick={() => addVolunteer(shift.id)}
                           style={{ alignSelf: 'flex-start' }}
                         >
                           + Add Volunteer
                         </Button>
                       )}
                     </Stack>
                   </Paper>
                 ))}
                 
                 <Group>
                   {isEditing ? (
                     <>
                       <Button variant="light" onClick={handleSave} color="green">
                         Save
                       </Button>
                       <Button variant="light" onClick={handleCancel} color="gray">
                         Cancel
                       </Button>
                     </>
                   ) : (
                     <Button variant="light" onClick={handleEdit}>
                       Edit
                     </Button>
                   )}
                 </Group>
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
    let [helpModal, setHelpModal] = useState(false)
    const [foodBankName, setFoodBankName] = useState("TASK Food Bank")
    const [foodBankAddress, setFoodBankAddress] = useState("123 Main St, Belle Mead, NJ 08502")
    const [foodBankPhone, setFoodBankPhone] = useState("(609) 123-4567")
    const [foodBankEmail, setFoodBankEmail] = useState("info@taskfoodbank.org")
    const [settingsLoading, setSettingsLoading] = useState(false)
    
    // API Base URL
    const API_BASE_URL = 'http://localhost:3000';
    
    // Save settings function
    const handleSaveSettings = async () => {
        try {
            setSettingsLoading(true);
            
            // Get current user data
            const userData = JSON.parse(localStorage.getItem('user_data') || '{}');
            const userId = userData._id;
            
            if (!userId) {
                notifications.show({
                    title: 'Error',
                    message: 'User not found. Please sign in again.',
                    color: 'red',
                    icon: <IconInfoCircle size={16} />,
                    autoClose: 3000,
                });
                return;
            }
            
            // Update pantry information
            const pantryData = {
                name: foodBankName,
                address: foodBankAddress,
                phone_number: foodBankPhone,
                email: foodBankEmail
            };
            
            // For now, we'll store settings in localStorage since we don't have a pantry update endpoint
            // In a real app, you'd call an API to update pantry settings
            localStorage.setItem('pantry_settings', JSON.stringify(pantryData));
            
            notifications.show({
                title: 'Settings Saved!',
                message: 'Your food bank settings have been updated successfully.',
                color: 'green',
                icon: <IconCheck size={16} />,
                autoClose: 3000,
            });
            
            setSettings(false);
            
        } catch (error) {
            console.error('Error saving settings:', error);
            notifications.show({
                title: 'Error',
                message: 'Failed to save settings. Please try again.',
                color: 'red',
                icon: <IconInfoCircle size={16} />,
                autoClose: 3000,
            });
        } finally {
            setSettingsLoading(false);
        }
    };
    
    // Load settings on component mount
    useEffect(() => {
        const savedSettings = localStorage.getItem('pantry_settings');
        if (savedSettings) {
            const settings = JSON.parse(savedSettings);
            setFoodBankName(settings.name || "TASK Food Bank");
            setFoodBankAddress(settings.address || "123 Main St, Belle Mead, NJ 08502");
            setFoodBankPhone(settings.phone_number || "(609) 123-4567");
            setFoodBankEmail(settings.email || "info@taskfoodbank.org");
        }
    }, []);
    
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
                <Button variant="light" onClick={() => setSettings(false)} disabled={settingsLoading}>
                  Cancel
                </Button>
                <Button onClick={handleSaveSettings} loading={settingsLoading} disabled={settingsLoading}>
                  {settingsLoading ? 'Saving...' : 'Save Changes'}
                </Button>
              </Group>
            </Stack>
          </Paper>
        </Modal>

        {/* Help Modal */}
        <Modal opened={helpModal} onClose={() => setHelpModal(false)} centered size="lg" radius="md" padding="lg">
          <Paper m={0} p="md" radius="md" withBorder style={{ backgroundColor: "#f8fafc" }}>
            <Title order={3} mb="lg">Dashboard Help</Title>
            <Stack spacing="md">
              <div>
                <Text fw={600} size="md" mb="xs">Welcome to PantryLink Dashboard!</Text>
                <Text size="sm" color="dimmed">
                  This dashboard helps you manage your food bank operations efficiently. Here's how to use each section:
                </Text>
              </div>
              
              <div>
                <Text fw={600} size="sm" mb="xs">📊 Dashboard Overview</Text>
                <Text size="sm" color="dimmed">
                  View key metrics like total volunteers, stock levels, and upcoming events. 
                  The schedule shows today's volunteer shifts and important reminders.
                </Text>
              </div>
              
              <div>
                <Text fw={600} size="sm" mb="xs">📦 Inventory Management</Text>
                <Text size="sm" color="dimmed">
                  Track your food inventory by category (Fruits, Vegetables, Proteins, Nonperishable). 
                  Edit quantities, add new items, and filter by type. Items turn red when stock is low.
                </Text>
              </div>
              
              <div>
                <Text fw={600} size="sm" mb="xs">👥 Volunteer Management</Text>
                <Text size="sm" color="dimmed">
                  <strong>Volunteers List:</strong> View all verified volunteers with their contact information.<br/>
                  <strong>Inbox:</strong> Review and approve new volunteer applications. Accept to verify them or decline to remove them.<br/>
                  <strong>Schedule:</strong> Assign verified volunteers to different shifts throughout the day.
                </Text>
              </div>
              
              <div>
                <Text fw={600} size="sm" mb="xs">📢 Stream Posts</Text>
                <Text size="sm" color="dimmed">
                  Share announcements and updates with your community. Post about special events, 
                  new arrivals, or important notices.
                </Text>
              </div>
              
              <div>
                <Text fw={600} size="sm" mb="xs">⚙️ Settings</Text>
                <Text size="sm" color="dimmed">
                  Update your food bank's contact information, name, and address. 
                  Changes are saved automatically and will be used throughout the system.
                </Text>
              </div>
              
              <div>
                <Text fw={600} size="sm" mb="xs">💡 Tips</Text>
                <Text size="sm" color="dimmed">
                  • Use the navigation menu on the left to switch between sections<br/>
                  • Click the info button next to volunteers to see full details<br/>
                  • Edit mode in inventory and schedule allows bulk changes<br/>
                  • Notifications will appear for successful actions and errors
                </Text>
              </div>
              
              <Group justify="center" mt="md">
                <Button onClick={() => setHelpModal(false)} color="blue">
                  Got it!
                </Button>
              </Group>
            </Stack>
          </Paper>
        </Modal>

        <AppShell.Header px="md" style={{ backgroundColor: '#f8f9fa', borderBottom: '1px solid #eee' }}>
          <Group h="100%" position="apart">
            <Text fw={700} size="lg">Dashboard</Text>
            <Group>
              <Button variant="light" color="gray" onClick={() => setHelpModal(true)}>
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