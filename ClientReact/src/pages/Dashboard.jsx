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
    Modal,
    Switch,
    Radio,
    Checkbox,
    Alert
  } from '@mantine/core'
  import { ActionIcon } from '@mantine/core'
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
    IconDeviceFloppy,
    IconTrash
  } from '@tabler/icons-react'
  import { useState, useEffect } from 'react'
  import { notifications } from '@mantine/notifications'
  import axios from 'axios'
  import { API_BASE_URL } from '../config'
  const getPantryId = () => {
    const userData = JSON.parse(localStorage.getItem('user_data') || '{}');
    return userData._id;
  };
  const DashboardComp = ({ volunteers = [], inventory = [] })=>{
    // Calculate real metrics
    const totalVolunteers = volunteers.length;
    
    // Calculate stock percentage
    const stockPercentage = inventory.length > 0 
      ? Math.round((inventory.reduce((sum, item) => sum + (item.current / item.full), 0) / inventory.length) * 100)
      : 0;
    
    // Calculate low stock items (less than 35% full)
    const lowStockItems = inventory.filter(item => (item.current / item.full) < 0.35).length;

    // State for schedule settings and today's schedule
    const [scheduleSettings, setScheduleSettings] = useState(null);
    const [todaysSchedule, setTodaysSchedule] = useState({ shifts: [], general_volunteers: [] });
    const [scheduleLoading, setScheduleLoading] = useState(true);
    const [latestPost, setLatestPost] = useState(null);
    const [latestLoading, setLatestLoading] = useState(true);

    useEffect(() => {
      const fetchData = async () => {
        try {
          const pantryId = getPantryId();
          if (!pantryId) return;
          
          // Fetch schedule settings
          const settingsRes = await axios.get(`${API_BASE_URL}/pantry/${pantryId}/schedule-settings`);
          setScheduleSettings(settingsRes.data.settings || null);
          
          // Fetch today's schedule
          const todayKey = new Date().toISOString().slice(0, 10);
          const scheduleRes = await axios.get(`${API_BASE_URL}/pantry/${pantryId}/schedule`, { params: { date: todayKey } });
          let schedule = scheduleRes.data?.schedule;
          if (Array.isArray(schedule)) {
            schedule = { shifts: schedule, general_volunteers: [] };
          } else if (!schedule || typeof schedule !== 'object') {
            schedule = { shifts: [], general_volunteers: [] };
          }
          setTodaysSchedule(schedule);
          
          // Fetch latest stream
          const infoRes = await axios.get(`${API_BASE_URL}/pantry/info/${pantryId}`);
          const stream = infoRes.data.stream || [];
          setLatestPost(stream.length > 0 ? stream[stream.length - 1] : null);
        } catch (e) {
          console.error('Error fetching dashboard data:', e);
        } finally {
          setScheduleLoading(false);
          setLatestLoading(false);
        }
      };
      fetchData();
    }, []);

    // Calculate total scheduled volunteers for today
    const totalScheduledVolunteers = 
      todaysSchedule.shifts.reduce((sum, shift) => sum + (shift.volunteers?.filter(v => v.name?.trim()).length || 0), 0) +
      (todaysSchedule.general_volunteers?.filter(v => v.name?.trim()).length || 0);

    // Check if default schedule is configured
    const hasDefaultSchedule = scheduleSettings?.useDefaultSchedule && scheduleSettings?.defaultSchedule?.length > 0;

    return(
      <Stack spacing="md">
        <Grid>
          <Grid.Col span={3}>
            <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#f1f3f5' }}>
              <Text size="sm" color="dimmed">Total Volunteers</Text>
              <Text size="xl" fw={700}>{totalVolunteers}</Text>
            </Paper>
          </Grid.Col>
          <Grid.Col span={3}>
            <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#f1f3f5' }}>
              <Text size="sm" color="dimmed">Stock(%)</Text>
              <Text size="xl" fw={700}>{stockPercentage}%</Text>
            </Paper>
          </Grid.Col>
          <Grid.Col span={3}>
            <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#f1f3f5' }}>
              <Text size="sm" color="dimmed">Low Stock Items</Text>
              <Text size="xl" fw={700} style={{ color: lowStockItems > 0 ? 'red' : 'green' }}>{lowStockItems}</Text>
            </Paper>
          </Grid.Col>
          <Grid.Col span={3}>
            <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#f1f3f5' }}>
              <Text size="sm" color="dimmed">Scheduled Today</Text>
              <Text size="xl" fw={700}>{totalScheduledVolunteers}</Text>
            </Paper>
          </Grid.Col>
        </Grid>

        <Grid>
          <Grid.Col span={12}>
            <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#f1f3f5' }}>
              <Text size="sm" fw={900} mb="xs">Your Default Schedule</Text>
              {scheduleLoading ? (
                <Center p="md"><Loader size="sm" /></Center>
              ) : !hasDefaultSchedule ? (
                <Alert color="orange" icon={<IconInfoCircle size={16} />} mb="md">
                  <Text fw={500}>No default schedule configured!</Text>
                  <Text size="sm">Go to the Volunteers page to set up your default shifts, open days, and excluded dates. This helps volunteers know when they can sign up.</Text>
                </Alert>
              ) : (
                <Stack spacing="xs">
                  {scheduleSettings.defaultSchedule.map((shift) => (
                    <Paper key={shift.id} p="sm" radius="md" withBorder style={{ backgroundColor: '#fff' }}>
                      <Flex justify="space-between" align="center">
                        <Text fw={600}>{shift.shift}</Text>
                        <Text size="sm" color="dimmed">{shift.time}</Text>
                      </Flex>
                    </Paper>
                  ))}
                  <Text size="xs" color="dimmed" mt="xs">
                    Open days: {scheduleSettings.openDays?.map(d => ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'][d]).join(', ') || 'Not set'}
                    {scheduleSettings.excludedDates?.length > 0 && ` | ${scheduleSettings.excludedDates.length} excluded date(s)`}
                  </Text>
                </Stack>
              )}
            </Paper>
          </Grid.Col>
          
          <Grid.Col span={12}>
            <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#f1f3f5' }}>
              <Text size="sm" fw={900} mb="xs">Today's Schedule</Text>
              {scheduleLoading ? (
                <Center p="md"><Loader size="sm" /></Center>
              ) : todaysSchedule.shifts.length === 0 && todaysSchedule.general_volunteers?.length === 0 ? (
                <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#fff' }}>
                  <Text color="dimmed" ta="center">No volunteers scheduled for today</Text>
                </Paper>
              ) : (
                <>
                  {todaysSchedule.shifts.map((shift) => (
                    <Paper key={shift.id} p="md" radius="lg" shadow="xs" withBorder style={{ margin: '0.5rem 0', backgroundColor: '#fff' }}>
                      <Flex justify="space-between" align="center">
                        <Text fw={700}>{shift.shift}</Text>
                        <Text size="sm" color="dimmed">{shift.time}</Text>
                        <Text size="sm" color="dimmed">
                          {shift.volunteers?.filter(v => v.name?.trim()).length || 0} volunteer(s)
                        </Text>
                      </Flex>
                      {shift.volunteers?.filter(v => v.name?.trim()).length > 0 && (
                        <Stack spacing="xs" mt="sm">
                          {shift.volunteers.filter(v => v.name?.trim()).map((volunteer, index) => (
                            <Text key={index} size="sm" color="dimmed" ml="md">• {volunteer.name}</Text>
                          ))}
                        </Stack>
                      )}
                    </Paper>
                  ))}
                  {todaysSchedule.general_volunteers?.filter(v => v.name?.trim()).length > 0 && (
                    <Paper p="md" radius="lg" shadow="xs" withBorder style={{ margin: '0.5rem 0', backgroundColor: '#f8f9fa' }}>
                      <Text fw={700} mb="xs">General Volunteers</Text>
                      <Stack spacing="xs">
                        {todaysSchedule.general_volunteers.filter(v => v.name?.trim()).map((volunteer, index) => (
                          <Text key={index} size="sm" color="dimmed">• {volunteer.name}</Text>
                        ))}
                      </Stack>
                    </Paper>
                  )}
                </>
              )}
              <Text size="sm" color="dimmed" mt="sm">Manage on the Volunteers page</Text>
            </Paper>
          </Grid.Col>
          
          <Grid.Col span={12}>
            <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#f1f3f5' }}>
              <Text fw={700} size="md" mb="xs">Current Stream Post</Text>
              {latestLoading ? (
                <Center><Loader size="sm" /></Center>
              ) : latestPost ? (
                <Blockquote color="blue" p="md">
                  <Flex align="center" style={{ width: '100%' }}>
                    <Text size="xs" color="dimmed" style={{ minWidth: 140 }}>
                      {typeof latestPost === 'string' ? '' : latestPost.date}
                    </Text>
                    <Flex justify="center" align="center" style={{ flex: 1 }}>
                      <Text ta="center">{typeof latestPost === 'string' ? latestPost : latestPost.message}</Text>
                    </Flex>
                    <div style={{ minWidth: 140 }} />
                  </Flex>
                </Blockquote>
              ) : (
                <Text size="sm" color="dimmed">No stream posts yet</Text>
              )}
            </Paper>
          </Grid.Col>
        </Grid>
      </Stack>
    )
  }

 

 function InvItems({ item, editing, onSave, onDelete }){
    const [currentValue, setCurrentValue] = useState(item.current)
    const [fullValue, setFullValue] = useState(item.full)
    const [isEditing, setIsEditing] = useState(false)
    const [nameValue, setNameValue] = useState(item.name)
    
    useEffect(() => {
      setNameValue(item.name)
      setCurrentValue(item.current)
      setFullValue(item.full)
    }, [item.name, item.current, item.full])
    
    const handleSave = () => {
      onSave(item.name, nameValue, currentValue, fullValue, item.type)
      setIsEditing(false)
    }
    
    const handleCancel = () => {
      setCurrentValue(item.current)
      setFullValue(item.full)
      setNameValue(item.name)
      setIsEditing(false)
    }
    
    return(
      <Grid.Col span={2} key={`${item.name}-${item.type}`}>
        <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: item.current / item.full >= .35 ? '#f4fbf6' : '#fff5f5' }} >
          {!isEditing ? (
            <Text size="lg" color="darks">{nameValue}</Text>
          ) : (
            <TextInput
              variant="filled"
              size="xs"
              placeholder={item.name}
              value={nameValue}
              onChange={(e) => setNameValue(e.target.value)}
              styles={{
                input: {
                  textAlign: 'center',
                  fontSize: '14px',
                  fontWeight: 600
                }
              }}
            />
          )}
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
            <Group gap="xs" mt="xs">
              <Button 
                size="xs" 
                variant="light" 
                color="blue" 
                onClick={() => setIsEditing(true)}
                radius="sm"
              >
                Edit
              </Button>
              <Button 
                size="xs" 
                variant="light" 
                color="red" 
                onClick={() => onDelete(item.name)}
                radius="sm"
              >
                Delete
              </Button>
            </Group>
          )}
        </Paper>
      </Grid.Col>
    )
  }
  const Inventory = ({ foodBankName })=> {
    
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
      type: 'Produce'
    })
    const [items, setItems] = useState([])
    
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
          { name: 'Tomatoe', current: 44, full: 50, type: 'Produce' },
          { name: 'Brocoli', current: 5, full: 50, type: 'Produce' },
          { name: 'Carrots', current: 30, full: 50, type: 'Produce' },
          { name: 'Apples', current: 50, full: 50, type: 'Produce' },
          { name: 'Tuna Can', current: 12, full: 40, type: 'Cans' },
          { name: 'Chicken Breast', current: 22, full: 50, type: 'Protein' },
          { name: 'Bananas', current: 18, full: 50, type: 'Produce' },
          { name: 'Spinach', current: 35, full: 50, type: 'Produce' },
          { name: 'Beans (Dry)', current: 44, full: 50, type: 'Dry Goods' },
          { name: 'Eggs', current: 10, full: 30, type: 'Protein' }
        ]);
      } finally {
        setLoading(false);
      }
    };
    
    // Fetch inventory on component mount
    useEffect(() => {
      fetchInventory();
    }, []);

    const handleSaveItem = async (originalName, newName, current, full, type) => {
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
        const trimmedName = (newName || '').trim();
        if (!trimmedName) {
          notifications.show({
            title: 'Error',
            message: 'Item name cannot be empty.',
            color: 'red',
            icon: <IconInfoCircle size={16} />,
            autoClose: 3000,
          });
          return;
        }

        if (current > full) {
          notifications.show({
            title: 'Error',
            message: 'Current quantity cannot be greater than full capacity.',
            color: 'red',
            icon: <IconInfoCircle size={16} />,
            autoClose: 3000,
          });
          return;
        }

        const isRenaming = originalName !== trimmedName;
        if (isRenaming) {
          const nameExists = items.some(i => i.name.toLowerCase() === trimmedName.toLowerCase() && i.name.toLowerCase() !== originalName.toLowerCase());
          if (nameExists) {
            notifications.show({
              title: 'Error!',
              message: 'An item with this name already exists.',
              color: 'red',
              icon: <IconInfoCircle size={16} />,
              autoClose: 3000,
              withCloseButton: true,
            });
            return;
          }

          // Create new item with new name
          await axios.post(`${API_BASE_URL}/pantry/${pantryId}/inventory`, {
            name: trimmedName,
            current,
            full,
            type
          });

          // Delete old item
          await axios.delete(`${API_BASE_URL}/pantry/${pantryId}/inventory/${encodeURIComponent(originalName)}`);

          // Update local state
          setItems(prevItems => 
            prevItems.map(item => 
              item.name === originalName 
                ? { ...item, name: trimmedName, current, full }
                : item
            )
          )

          notifications.show({
            title: 'Item Renamed',
            message: `Updated to ${trimmedName} — ${current}/${full}`,
            color: 'green',
            icon: <IconCheck size={16} />,
            autoClose: 3000,
            withCloseButton: true,
          })
        } else {
          // Update quantities via API
          await axios.put(`${API_BASE_URL}/pantry/${pantryId}/inventory/${encodeURIComponent(originalName)}`, {
            current,
            full
          });
          
          // Update local state
          setItems(prevItems => 
            prevItems.map(item => 
              item.name === originalName 
                ? { ...item, current, full }
                : item
            )
          )
          
          notifications.show({
            title: 'Inventory Updated!',
            message: `${originalName} quantity has been updated to ${current}/${full}`,
            color: 'green',
            icon: <IconCheck size={16} />,
            autoClose: 3000,
            withCloseButton: true,
          })
        }
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

    const handleDeleteItem = async (itemName) => {
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

        await axios.delete(`${API_BASE_URL}/pantry/${pantryId}/inventory/${encodeURIComponent(itemName)}`);

        setItems(prev => prev.filter(i => i.name !== itemName));

        notifications.show({
          title: 'Item Deleted',
          message: `${itemName} has been removed from your inventory`,
          color: 'green',
          icon: <IconCheck size={16} />,
          autoClose: 3000,
          withCloseButton: true,
        });
      } catch (error) {
        console.error('Error deleting inventory item:', error);
        notifications.show({
          title: 'Error',
          message: 'Failed to delete inventory item. Please try again.',
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
          type: 'Produce'
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
        type: 'Produce'
      })
      setAddNewModal(false)
    }

  let filteredItems;
  switch (sort) {
    case 'Produce':
      filteredItems = items.filter((item) => item.type === 'Produce');
      break;
    case 'Dry Goods':
      filteredItems = items.filter((item) => item.type === 'Dry Goods');
      break;
    case 'Protein':
      filteredItems = items.filter((item) => item.type === 'Protein');
      break;
    case 'Nonperishable':
      filteredItems = items.filter((item) => item.type === 'Nonperishable');
      break;
    case 'Cans':
      filteredItems = items.filter((item) => item.type === 'Cans');
      break;
    case 'Other':
      filteredItems = items.filter((item) => item.type === 'Other');
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
          <Text>{`${foodBankName}'s Inventory`}</Text>
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
          data={['Produce', 'Dry Goods', 'Protein', 'Nonperishable', 'Cans', 'Other']}
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
                  onDelete={handleDeleteItem}
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
                data={['Produce', 'Dry Goods', 'Protein', 'Nonperishable', 'Cans', 'Other']}
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
  const Volunteer = ({ foodBankName })=> {

    const [selectedVolunteer, setSelectedVolunteer] = useState(null)
    const [inboxInfo, setInboxInfo] = useState(false)
    const [volunteers, setVolunteers] = useState([])
    const [inboxVolunteers, setInboxVolunteers] = useState([])
    const [loading, setLoading] = useState(true)
    
    // Schedule state - new format with shifts and general_volunteers
    const [scheduleData, setScheduleData] = useState({ shifts: [], general_volunteers: [] });
    const [editingScheduleData, setEditingScheduleData] = useState({ shifts: [], general_volunteers: [] });

    const [isEditing, setIsEditing] = useState(false);
    const [selectedDate, setSelectedDate] = useState(() => new Date().toISOString().slice(0, 10));
    
    // Schedule Settings State
    const [scheduleSettings, setScheduleSettings] = useState({
      schedulingEnabled: true,
      openDays: [1, 2, 3, 4, 5],
      excludedDates: [],
      useDefaultSchedule: false,
      defaultSchedule: []
    });
    const [editingDefaultSchedule, setEditingDefaultSchedule] = useState([]);
    const [isEditingDefaults, setIsEditingDefaults] = useState(false);

    // Backend: fetch schedule for a date (new format)
    const fetchScheduleForDate = async (dateKey) => {
      try {
        const pantryId = getPantryId();
        if (!pantryId) {
          setScheduleData({ shifts: [], general_volunteers: [] });
          return;
        }
        const res = await axios.get(`${API_BASE_URL}/pantry/${pantryId}/schedule`, { params: { date: dateKey } });
        
        let schedule = res.data?.schedule;
        // Handle new format (object) or legacy format (array)
        if (Array.isArray(schedule)) {
          schedule = { shifts: schedule, general_volunteers: [] };
        } else if (!schedule || typeof schedule !== 'object') {
          schedule = { shifts: [], general_volunteers: [] };
        }
        
        // Ensure shifts have valid IDs
        schedule.shifts = (schedule.shifts || []).map((shift, index) => ({
          ...shift,
          id: typeof shift.id === 'number' ? shift.id : index + 1,
          volunteers: (shift.volunteers || []).map(v => ({ name: v.name || '', email: v.email || '', username: v.username || '' }))
        }));
        schedule.general_volunteers = (schedule.general_volunteers || []).map(v => ({ 
          name: v.name || '', email: v.email || '', username: v.username || '' 
        }));
        
        setScheduleData(schedule);
      } catch (e) {
        console.error('Error fetching schedule:', e);
        setScheduleData({ shifts: [], general_volunteers: [] });
      } finally {
        setIsEditing(false);
      }
    };

    useEffect(() => {
      fetchScheduleForDate(selectedDate);
    }, [selectedDate]);

    // Fetch volunteers from backend
    const fetchVolunteers = async () => {
      try {
        setLoading(true);
        const response = await axios.get(`${API_BASE_URL}/volunteer/get`);
        const allVolunteers = response.data;
        const verifiedVolunteers = allVolunteers.filter(vol => vol.verified === true || vol.verified === "True");
        const unverifiedVolunteers = allVolunteers.filter(vol => vol.verified === false || vol.verified === "False");
        setVolunteers(verifiedVolunteers);
        setInboxVolunteers(unverifiedVolunteers);
      } catch (error) {
        console.error('Error fetching volunteers:', error);
      } finally {
        setLoading(false);
      }
    };

    const handleAcceptVolunteer = async (volunteerId) => {
      try {
        const volunteer = inboxVolunteers.find(v => v._id === volunteerId);
        if (!volunteer) return;
        await axios.put(`${API_BASE_URL}/volunteer/update/${volunteerId}`, { ...volunteer, verified: true });
        await fetchVolunteers();
        notifications.show({ title: 'Volunteer Accepted!', message: `${volunteer.first_name} ${volunteer.last_name} has been verified`, color: 'green', icon: <IconCheck size={16} />, autoClose: 3000 });
      } catch (error) {
        notifications.show({ title: 'Error', message: 'Failed to accept volunteer', color: 'red', autoClose: 3000 });
      }
    };

    const handleDeclineVolunteer = async (volunteerId) => {
      try {
        const volunteer = inboxVolunteers.find(v => v._id === volunteerId);
        if (!volunteer) return;
        await axios.delete(`${API_BASE_URL}/volunteer/delete/${volunteerId}`);
        await fetchVolunteers();
        notifications.show({ title: 'Volunteer Declined', message: `${volunteer.first_name} ${volunteer.last_name} has been removed`, color: 'orange', autoClose: 3000 });
      } catch (error) {
        notifications.show({ title: 'Error', message: 'Failed to decline volunteer', color: 'red', autoClose: 3000 });
      }
    };

    const handleDeleteVolunteer = async (volunteerId) => {
      try {
        const volunteer = volunteers.find(v => v._id === volunteerId);
        if (!volunteer) return;
        await axios.delete(`${API_BASE_URL}/volunteer/delete/${volunteerId}`);
        await fetchVolunteers();
        notifications.show({ title: 'Volunteer Deleted', message: `${volunteer.first_name} ${volunteer.last_name} has been removed`, color: 'red', autoClose: 3000 });
      } catch (error) {
        notifications.show({ title: 'Error', message: 'Failed to delete volunteer', color: 'red', autoClose: 3000 });
      }
    };

    useEffect(() => { fetchVolunteers(); }, []);

    const handleEdit = () => {
      setEditingScheduleData(JSON.parse(JSON.stringify(scheduleData)));
      setIsEditing(true);
    };

    // Check if volunteer is already scheduled at another pantry
    const checkVolunteerConflict = async (username, dateKey) => {
      try {
        const pantryId = getPantryId();
        const res = await axios.get(`${API_BASE_URL}/pantry/check-user-conflict`, {
          params: { username, date: dateKey, exclude_pantry_id: pantryId }
        });
        return res.data;
      } catch (e) {
        return { scheduled: false };
      }
    };

    const handleSave = async () => {
      try {
        const pantryId = getPantryId();
        if (!pantryId) return;

        // Enrich volunteers with email/username and check for conflicts
        const enrichShifts = async (shifts) => {
          const result = [];
          for (const shift of shifts) {
            const enrichedVolunteers = [];
            for (const v of (shift.volunteers || [])) {
              if (!v.name || !v.name.trim()) continue;
              const match = volunteers.find(m => `${m.first_name} ${m.last_name}` === v.name);
              const username = match?.username || v.username || '';
              
              // Check for conflicts
              if (username) {
                const conflict = await checkVolunteerConflict(username, selectedDate);
                if (conflict.scheduled) {
                  notifications.show({
                    title: 'Scheduling Conflict',
                    message: `${v.name} is already scheduled at ${conflict.pantry_name} on this day`,
                    color: 'red',
                    autoClose: 5000
                  });
                  return null; // Signal conflict
                }
              }
              
              enrichedVolunteers.push({
                name: v.name,
                email: match?.email || v.email || '',
                username: username
              });
            }
            result.push({
              id: shift.id,
              time: shift.time,
              shift: shift.shift,
              volunteers: enrichedVolunteers
            });
          }
          return result;
        };

        const enrichGeneralVolunteers = async (generalVols) => {
          const result = [];
          for (const v of generalVols) {
            if (!v.name || !v.name.trim()) continue;
            const match = volunteers.find(m => `${m.first_name} ${m.last_name}` === v.name);
            const username = match?.username || v.username || '';
            
            if (username) {
              const conflict = await checkVolunteerConflict(username, selectedDate);
              if (conflict.scheduled) {
                notifications.show({
                  title: 'Scheduling Conflict',
                  message: `${v.name} is already scheduled at ${conflict.pantry_name} on this day`,
                  color: 'red',
                  autoClose: 5000
                });
                return null;
              }
            }
            
            result.push({
              name: v.name,
              email: match?.email || v.email || '',
              username: username
            });
          }
          return result;
        };

        const enrichedShifts = await enrichShifts(editingScheduleData.shifts || []);
        if (enrichedShifts === null) return; // Conflict detected
        
        const enrichedGeneral = await enrichGeneralVolunteers(editingScheduleData.general_volunteers || []);
        if (enrichedGeneral === null) return; // Conflict detected

        const finalSchedule = {
          shifts: enrichedShifts,
          general_volunteers: enrichedGeneral
        };

        await axios.put(`${API_BASE_URL}/pantry/${pantryId}/schedule/${selectedDate}`, { schedule: finalSchedule });

        setScheduleData(finalSchedule);
        setIsEditing(false);

        notifications.show({ title: 'Schedule Saved', message: `Saved schedule for ${new Date(selectedDate).toLocaleDateString()}`, color: 'green', icon: <IconCheck size={16} />, autoClose: 3000 });
      } catch (e) {
        notifications.show({ title: 'Save Error', message: 'Failed to save schedule.', color: 'red', autoClose: 4000 });
      }
    };

    const handleCancel = () => { setIsEditing(false); };

    // Shift volunteer management (no roles)
    const updateShiftVolunteer = (shiftId, volunteerIndex, value) => {
      setEditingScheduleData(prev => ({
        ...prev,
        shifts: prev.shifts.map(shift => 
          shift.id === shiftId 
            ? { ...shift, volunteers: shift.volunteers.map((vol, idx) => idx === volunteerIndex ? { ...vol, name: value } : vol) }
            : shift
        )
      }));
    };

    const addShiftVolunteer = (shiftId) => {
      setEditingScheduleData(prev => ({
        ...prev,
        shifts: prev.shifts.map(shift => 
          shift.id === shiftId 
            ? { ...shift, volunteers: [...shift.volunteers, { name: "", email: "", username: "" }] }
            : shift
        )
      }));
    };

    const removeShiftVolunteer = (shiftId, volunteerIndex) => {
      setEditingScheduleData(prev => ({
        ...prev,
        shifts: prev.shifts.map(shift => 
          shift.id === shiftId 
            ? { ...shift, volunteers: shift.volunteers.filter((_, idx) => idx !== volunteerIndex) }
            : shift
        )
      }));
    };

    // General volunteer management
    const addGeneralVolunteer = () => {
      setEditingScheduleData(prev => ({
        ...prev,
        general_volunteers: [...prev.general_volunteers, { name: "", email: "", username: "" }]
      }));
    };

    const updateGeneralVolunteer = (index, value) => {
      setEditingScheduleData(prev => ({
        ...prev,
        general_volunteers: prev.general_volunteers.map((vol, idx) => idx === index ? { ...vol, name: value } : vol)
      }));
    };

    const removeGeneralVolunteer = (index) => {
      setEditingScheduleData(prev => ({
        ...prev,
        general_volunteers: prev.general_volunteers.filter((_, idx) => idx !== index)
      }));
    };

    // Shift management
    const updateShift = (shiftId, field, value) => {
      setEditingScheduleData(prev => ({
        ...prev,
        shifts: prev.shifts.map(shift => shift.id === shiftId ? { ...shift, [field]: value } : shift)
      }));
    };

    const addNewShift = () => {
      const maxId = Math.max(0, ...editingScheduleData.shifts.map(s => s.id || 0));
      setEditingScheduleData(prev => ({
        ...prev,
        shifts: [...prev.shifts, { id: maxId + 1, time: "New Shift Time", shift: "New Shift Name", volunteers: [] }]
      }));
    };

    const removeShift = (shiftId) => {
      setEditingScheduleData(prev => ({
        ...prev,
        shifts: prev.shifts.filter(shift => shift.id !== shiftId)
      }));
    };
    
    // Fetch and save schedule settings
    const fetchScheduleSettings = async () => {
      try {
        const pantryId = getPantryId();
        if (!pantryId) return;
        const response = await axios.get(`${API_BASE_URL}/pantry/${pantryId}/schedule-settings`);
        if (response.data.settings) {
          setScheduleSettings(response.data.settings);
        }
      } catch (error) {
        console.error('Error fetching schedule settings:', error);
      }
    };
    
    const saveScheduleSettings = async (newSettings) => {
      try {
        const pantryId = getPantryId();
        if (!pantryId) return;
        await axios.put(`${API_BASE_URL}/pantry/${pantryId}/schedule-settings`, { settings: newSettings });
        setScheduleSettings(newSettings);
        notifications.show({ title: 'Settings Saved', message: 'Schedule settings updated', color: 'green', icon: <IconCheck size={16} />, autoClose: 3000 });
      } catch (error) {
        notifications.show({ title: 'Error', message: 'Failed to save settings', color: 'red', autoClose: 3000 });
      }
    };
    
    const isDateAvailable = (dateString) => {
      const date = new Date(dateString);
      const dayOfWeek = date.getDay();
      if (!scheduleSettings.schedulingEnabled) return false;
      if (!scheduleSettings.openDays.includes(dayOfWeek)) return false;
      if (scheduleSettings.excludedDates.includes(dateString)) return false;
      return true;
    };
    
    useEffect(() => { fetchScheduleSettings(); }, []);

    // Default schedule editing
    const startEditingDefaults = () => {
      setEditingDefaultSchedule(JSON.parse(JSON.stringify(scheduleSettings.defaultSchedule || [])));
      setIsEditingDefaults(true);
    };

    const saveDefaultSchedule = async () => {
      const newSettings = { ...scheduleSettings, defaultSchedule: editingDefaultSchedule, useDefaultSchedule: true };
      await saveScheduleSettings(newSettings);
      setIsEditingDefaults(false);
    };

    const addDefaultShift = () => {
      const maxId = Math.max(0, ...editingDefaultSchedule.map(s => s.id || 0));
      setEditingDefaultSchedule(prev => [...prev, { id: maxId + 1, time: "New Shift Time", shift: "New Shift Name", volunteers: [] }]);
    };

    const updateDefaultShift = (shiftId, field, value) => {
      setEditingDefaultSchedule(prev => prev.map(shift => shift.id === shiftId ? { ...shift, [field]: value } : shift));
    };

    const removeDefaultShift = (shiftId) => {
      setEditingDefaultSchedule(prev => prev.filter(shift => shift.id !== shiftId));
    };
    
    return(
      <>
        <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#f1f3f5' }}>
          <Title order={1}>{`${foodBankName}'s Volunteer Page`}</Title>
        </Paper>
        
        {/* PROMINENT: Default Schedule Setup Section */}
        <Paper mt="xl" p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: scheduleSettings.useDefaultSchedule && scheduleSettings.defaultSchedule?.length > 0 ? '#e8f5e9' : '#fff3e0' }}>
          <Group position="apart" mb="md">
            <div>
              <Title order={3}>Default Shifts & Schedule Setup</Title>
              <Text size="sm" color="dimmed">
                {scheduleSettings.useDefaultSchedule && scheduleSettings.defaultSchedule?.length > 0 
                  ? '✓ Default shifts are configured. New days will use this template.'
                  : '⚠ Set up your default shifts so volunteers know when to sign up!'}
              </Text>
            </div>
            {!isEditingDefaults ? (
              <Button onClick={startEditingDefaults} color={scheduleSettings.defaultSchedule?.length > 0 ? 'blue' : 'orange'}>
                {scheduleSettings.defaultSchedule?.length > 0 ? 'Edit Default Shifts' : 'Create Default Shifts'}
              </Button>
            ) : (
              <Group>
                <Button onClick={saveDefaultSchedule} color="green">Save Defaults</Button>
                <Button variant="light" onClick={() => setIsEditingDefaults(false)}>Cancel</Button>
              </Group>
            )}
          </Group>
          
          {isEditingDefaults ? (
            <Stack spacing="sm">
              {editingDefaultSchedule.map((shift) => (
                <Paper key={shift.id} p="sm" withBorder>
                  <Group>
                    <TextInput
                      size="sm"
                      placeholder="Shift Name (e.g., Morning Shift)"
                      value={shift.shift}
                      onChange={(e) => updateDefaultShift(shift.id, 'shift', e.target.value)}
                      style={{ flex: 1 }}
                    />
                    <TextInput
                      size="sm"
                      placeholder="Time (e.g., 8:00 AM - 12:00 PM)"
                      value={shift.time}
                      onChange={(e) => updateDefaultShift(shift.id, 'time', e.target.value)}
                      style={{ flex: 1 }}
                    />
                    <Button size="xs" color="red" variant="light" onClick={() => removeDefaultShift(shift.id)}>Remove</Button>
                  </Group>
                </Paper>
              ))}
              <Button variant="light" onClick={addDefaultShift} style={{ alignSelf: 'flex-start' }}>+ Add Shift</Button>
              
              {/* Open Days */}
              <Paper p="sm" withBorder mt="md">
                <Text fw={500} mb="xs">Days Open for Volunteers</Text>
                <Checkbox.Group
                  value={scheduleSettings.openDays.map(String)}
                  onChange={(values) => setScheduleSettings({ ...scheduleSettings, openDays: values.map(Number) })}
                >
                  <Group>
                    <Checkbox value="0" label="Sun" />
                    <Checkbox value="1" label="Mon" />
                    <Checkbox value="2" label="Tue" />
                    <Checkbox value="3" label="Wed" />
                    <Checkbox value="4" label="Thu" />
                    <Checkbox value="5" label="Fri" />
                    <Checkbox value="6" label="Sat" />
                  </Group>
                </Checkbox.Group>
              </Paper>
              
              {/* Excluded Dates */}
              <Paper p="sm" withBorder>
                <Text fw={500} mb="xs">Excluded Dates (Holidays/Closures)</Text>
                <Stack spacing="xs">
                  {scheduleSettings.excludedDates.map((date, index) => (
                    <Group key={index} position="apart">
                      <Text size="sm">{new Date(date + 'T12:00:00').toLocaleDateString()}</Text>
                      <Button size="xs" color="red" variant="light" onClick={() => {
                        setScheduleSettings({ ...scheduleSettings, excludedDates: scheduleSettings.excludedDates.filter((_, i) => i !== index) });
                      }}>Remove</Button>
                    </Group>
                  ))}
                  <TextInput
                    type="date"
                    placeholder="Add excluded date"
                    onChange={(e) => {
                      const newDate = e.currentTarget.value;
                      if (newDate && !scheduleSettings.excludedDates.includes(newDate)) {
                        setScheduleSettings({ ...scheduleSettings, excludedDates: [...scheduleSettings.excludedDates, newDate] });
                        e.currentTarget.value = '';
                      }
                    }}
                  />
                </Stack>
              </Paper>
            </Stack>
          ) : (
            <>
              {scheduleSettings.defaultSchedule?.length > 0 ? (
                <Stack spacing="xs">
                  {scheduleSettings.defaultSchedule.map((shift) => (
                    <Paper key={shift.id} p="xs" withBorder style={{ backgroundColor: '#fff' }}>
                      <Group>
                        <Text fw={500}>{shift.shift}</Text>
                        <Text size="sm" color="dimmed">{shift.time}</Text>
                      </Group>
                    </Paper>
                  ))}
                  <Text size="sm" color="dimmed" mt="xs">
                    Open days: {scheduleSettings.openDays.map(d => ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'][d]).join(', ') || 'None'}
                  </Text>
                  {scheduleSettings.excludedDates.length > 0 && (
                    <Text size="sm" color="dimmed">
                      Excluded: {scheduleSettings.excludedDates.length} date(s)
                    </Text>
                  )}
                </Stack>
              ) : (
                <Alert color="orange" icon={<IconInfoCircle size={16} />}>
                  No default shifts configured. Click "Create Default Shifts" to set up your volunteer schedule template.
                </Alert>
              )}
            </>
          )}
        </Paper>

        <Grid mt="xl">
          <Grid.Col span={6}>
            <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#f1f3f5' }}>
              <Title order={3}>Volunteers</Title>
              {loading ? (
                <Center p="xl"><Loader size="md" /><Text ml="md">Loading volunteers...</Text></Center>
              ) : (
                <>
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
                        <Table.Tr><Table.Td colSpan={3}><Center p="md"><Text color="dimmed">No verified volunteers found</Text></Center></Table.Td></Table.Tr>
                      ) : (
                        volunteers.map((volunteer)=> (
                          <Table.Tr key={volunteer._id}>
                            <Table.Td>{volunteer.first_name} {volunteer.last_name}</Table.Td>
                            <Table.Td>{volunteer.email}</Table.Td>
                            <Table.Td><Button variant="light" color="gray" radius="xl" onClick={()=> setSelectedVolunteer(volunteer)}><IconInfoCircle size={20} /></Button></Table.Td>
                          </Table.Tr>
                        ))
                      )}
                    </Table.Tbody>
                  </Table>
                  
                  <Modal opened={selectedVolunteer !== null} onClose={()=> setSelectedVolunteer(null)} centered size="lg">
                    {selectedVolunteer && (
                      <Paper p="md" radius="md" withBorder style={{ backgroundColor: "#f8fafc" }}>
                        <Group align="center" mb="md">
                          <Avatar size={64} radius="xl" color="blue">{selectedVolunteer.first_name?.[0]}{selectedVolunteer.last_name?.[0]}</Avatar>
                          <div>
                            <Title order={3}>{selectedVolunteer.first_name} {selectedVolunteer.last_name}</Title>
                            <Text size="sm" color="dimmed">{selectedVolunteer.email}</Text>
                          </div>
                        </Group>
                        <Grid gutter="md" mb="md">
                          <Grid.Col span={6}>
                            <Text size="sm"><b>Phone:</b> {selectedVolunteer.phone_number}</Text>
                            <Text size="sm"><b>Zip:</b> {selectedVolunteer.zipcode}</Text>
                            <Text size="sm"><b>Date of Birth:</b> {selectedVolunteer.date_of_birth}</Text>
                          </Grid.Col>
                          <Grid.Col span={6}>
                            <Text size="sm"><b>Availability:</b> {selectedVolunteer.availability}</Text>
                          </Grid.Col>
                        </Grid>
                        <Paper p="sm" radius="md" withBorder bg="gray.0">
                          <Title order={5} mb={4} color="blue">Emergency Contact</Title>
                          <Text size="sm"><b>Name:</b> {selectedVolunteer.emergency_name}</Text>
                          <Text size="sm"><b>Phone:</b> {selectedVolunteer.emergency_number}</Text>
                        </Paper>
                        <Group mt="md">
                          <Button color='blue' onClick={() => window.location.href = `mailto:${selectedVolunteer.email}`}>Email</Button>
                          <Button color='red' onClick={() => { handleDeleteVolunteer(selectedVolunteer._id); setSelectedVolunteer(null); }}>DELETE</Button>
                        </Group>
                      </Paper>
                    )}
                  </Modal>
                </>
              )}
            </Paper>
            
            <Paper mt="xl" p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#f1f3f5' }}>
              <Title order={3} mb="md">Inbox</Title>
              <Button variant="gradient" gradient={{ from: 'teal', to: 'green' }} radius="xl" onClick={()=> setInboxInfo(true)}>
                Open Inbox {inboxVolunteers.length > 0 && <Badge p={5} m={5} color="red">{inboxVolunteers.length}</Badge>}
              </Button>
              <Modal opened={inboxInfo} onClose={()=> setInboxInfo(false)} centered size="lg">
                <Paper p="md" radius="md" withBorder style={{ backgroundColor: "#f8fafc" }}>
                  <Title order={3}>Inbox</Title>
                  {inboxVolunteers.length === 0 ? (
                    <Center p="xl"><Text color="dimmed">No pending volunteer applications</Text></Center>
                  ) : (
                    <Table>
                      <Table.Thead><Table.Tr><Table.Th>Name</Table.Th><Table.Th>Email</Table.Th></Table.Tr></Table.Thead>
                      <Table.Tbody>
                        {inboxVolunteers.map((applicant) => {
                          function ApplicantRow() {
                            const [expanded, setExpanded] = useState(false);
                            return (
                              <>
                                <Table.Tr style={{ cursor: "pointer" }} onClick={() => setExpanded(e => !e)}>
                                  <Table.Td>
                                    <Button variant="subtle" size="xs" onClick={e => { e.stopPropagation(); setExpanded(exp => !exp); }} style={{ marginRight: 8 }}>{expanded ? "▼" : "▶"}</Button>
                                    {applicant.first_name} {applicant.last_name}
                                  </Table.Td>
                                  <Table.Td>{applicant.email}</Table.Td>
                                </Table.Tr>
                                <tr>
                                  <td colSpan={2} style={{ background: "#f8fafc", padding: 0, border: 0 }}>
                                    <div style={{ maxHeight: expanded ? 500 : 0, overflow: "hidden", transition: "max-height 0.3s", opacity: expanded ? 1 : 0 }}>
                                      <Paper p="md" style={{ background: "#f8fafc" }}>
                                        <Grid gutter="md" mb="md">
                                          <Grid.Col span={6}>
                                            <Text size="sm"><b>Phone:</b> {applicant.phone_number}</Text>
                                            <Text size="sm"><b>Zip:</b> {applicant.zipcode}</Text>
                                            <Text size="sm"><b>DOB:</b> {applicant.date_of_birth}</Text>
                                          </Grid.Col>
                                          <Grid.Col span={6}>
                                            <Text size="sm"><b>Availability:</b> {applicant.availability}</Text>
                                            <Text size="sm"><b>Emergency:</b> {applicant.emergency_name} - {applicant.emergency_number}</Text>
                                          </Grid.Col>
                                        </Grid>
                                        <Group mt="md">
                                          <Button color="green" variant="light" onClick={() => handleAcceptVolunteer(applicant._id)}>Accept</Button>
                                          <Button color="red" variant="light" onClick={() => handleDeclineVolunteer(applicant._id)}>Decline</Button>
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
          
          <Grid.Col span={6}>
            <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#f1f3f5' }}>
              <Group position="apart" mb="md">
                <Title order={3}>Daily Schedule</Title>
                <Group spacing="xs">
                  {!isEditing ? (
                    <Button variant="light" onClick={handleEdit} size="sm">Edit Schedule</Button>
                  ) : (
                    <>
                      <Button variant="light" onClick={handleSave} color="green" size="sm">Save</Button>
                      <Button variant="light" onClick={handleCancel} color="gray" size="sm">Cancel</Button>
                    </>
                  )}
                </Group>
              </Group>

              <Group mb="md">
                <Select
                  size="sm"
                  label="Select day"
                  value={selectedDate}
                  onChange={(val) => val && setSelectedDate(val)}
                  data={Array.from({ length: 8 }, (_, i) => {
                    const d = new Date(); d.setDate(d.getDate() + i);
                    const key = d.toISOString().slice(0, 10);
                    return { value: key, label: i === 0 ? 'Today' : d.toLocaleDateString(undefined, { weekday: 'short', month: 'short', day: 'numeric' }) };
                  })}
                  leftSection={<IconCalendar size={16} />}
                  style={{ maxWidth: 240 }}
                />
              </Group>

              {!scheduleSettings.schedulingEnabled && (
                <Alert color="yellow" mb="md">Volunteer scheduling is disabled.</Alert>
              )}
              
              {scheduleSettings.schedulingEnabled && !isDateAvailable(selectedDate) && (
                <Alert color="yellow" mb="md">
                  {scheduleSettings.excludedDates.includes(selectedDate) ? 'This date is excluded.' : 'This day is not open for volunteers.'}
                </Alert>
              )}

              {isEditing && (
                <Button variant="light" color="blue" onClick={addNewShift} size="sm" mb="md">+ Add Shift</Button>
              )}

              <Stack spacing="md">
                {(isEditing ? editingScheduleData.shifts : scheduleData.shifts).map((shift) => (
                  <Paper key={shift.id} p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#fff' }}>
                    {isEditing ? (
                      <Group mb="xs">
                        <TextInput size="sm" placeholder="Shift Time" value={shift.time} onChange={(e) => updateShift(shift.id, 'time', e.target.value)} style={{ flex: 1 }} />
                        <TextInput size="sm" placeholder="Shift Name" value={shift.shift} onChange={(e) => updateShift(shift.id, 'shift', e.target.value)} style={{ flex: 1 }} />
                        <Button size="xs" color="red" variant="light" onClick={() => removeShift(shift.id)}>Remove</Button>
                      </Group>
                    ) : (
                      <>
                        <Text fw={700} size="lg">{shift.time}</Text>
                        <Text size="sm" color="dimmed" mb="xs">{shift.shift}</Text>
                      </>
                    )}
                    <Stack spacing="xs">
                      {shift.volunteers.filter(v => v.name?.trim()).map((volunteer, idx) => (
                        <div key={idx} style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                          {isEditing ? (
                            <>
                              <Select
                                size="xs"
                                placeholder="Select volunteer"
                                value={volunteer.name}
                                onChange={(value) => updateShiftVolunteer(shift.id, idx, value)}
                                style={{ flex: 1 }}
                                data={volunteers.map(vol => ({ value: `${vol.first_name} ${vol.last_name}`, label: `${vol.first_name} ${vol.last_name}` }))}
                                searchable clearable
                              />
                              <Button size="xs" color="red" variant="light" onClick={() => removeShiftVolunteer(shift.id, idx)}>Remove</Button>
                            </>
                          ) : (
                            <Text size="sm">• {volunteer.name}</Text>
                          )}
                        </div>
                      ))}
                      {isEditing && <Button size="xs" variant="light" onClick={() => addShiftVolunteer(shift.id)}>+ Add Volunteer</Button>}
                    </Stack>
                  </Paper>
                ))}
                
                {/* General Volunteers Section */}
                <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#f8f9fa' }}>
                  <Text fw={700} size="lg" mb="xs">General Volunteers</Text>
                  <Text size="sm" color="dimmed" mb="md">Volunteers available for the day (no specific shift)</Text>
                  <Stack spacing="xs">
                    {(isEditing ? editingScheduleData.general_volunteers : scheduleData.general_volunteers).filter(v => v.name?.trim()).map((volunteer, idx) => (
                      <div key={idx} style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                        {isEditing ? (
                          <>
                            <Select
                              size="xs"
                              placeholder="Select volunteer"
                              value={volunteer.name}
                              onChange={(value) => updateGeneralVolunteer(idx, value)}
                              style={{ flex: 1 }}
                              data={volunteers.map(vol => ({ value: `${vol.first_name} ${vol.last_name}`, label: `${vol.first_name} ${vol.last_name}` }))}
                              searchable clearable
                            />
                            <Button size="xs" color="red" variant="light" onClick={() => removeGeneralVolunteer(idx)}>Remove</Button>
                          </>
                        ) : (
                          <Text size="sm">• {volunteer.name}</Text>
                        )}
                      </div>
                    ))}
                    {isEditing && <Button size="xs" variant="light" onClick={addGeneralVolunteer}>+ Add General Volunteer</Button>}
                    {!isEditing && scheduleData.general_volunteers.filter(v => v.name?.trim()).length === 0 && (
                      <Text size="sm" color="dimmed">No general volunteers signed up</Text>
                    )}
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
    const [stream, setStream] = useState([])
    const [loading, setLoading] = useState(true)
    const [foodBankName, setFoodBankName] = useState("");
    useEffect(()=> {
      const fetchStream = async () => {
        try {
          setLoading(true)
          const pantryId = getPantryId();
          if (!pantryId) return;
          const response = await axios.get(`${API_BASE_URL}/pantry/info/${pantryId}`);
          setFoodBankName(response.data.name || "Food Pantry");
          setStream(response.data.stream || []);
        } catch (e) {
          setStream([])
        } finally {
          setLoading(false)
        }
      }
      fetchStream();
    }, []);
    const [message, setMessage] = useState("");
    const handleSendMessage = async () => {
      try {
        setLoading(true)
        const pantryId = getPantryId();
        if (!pantryId) return;
        const response = await axios.post(`${API_BASE_URL}/pantry/${pantryId}/stream`, { message });
        setStream(response.data.stream || []);
        setMessage("")
      } catch (e) {
        console.error('Error sending message:', e);
      } finally {
        setLoading(false)
      }
    }
    return(
      <>
        <Stack spacing="md">
          <Title order={1}>{foodBankName}'s Stream</Title>
          <Grid>
              <Paper p="md" radius="lg" shadow="xs" withBorder style={{ backgroundColor: '#f1f3f5', width: '100%' }}>
                {loading ? (
                  <>
                    <Loader />
                    <Text size="sm" color="dimmed">Stream Loading...</Text>
                  </>
                ) : (
                  stream.length === 0 ? (
                    <>
                      <Text size="sm" color="dimmed">No stream posts yet</Text>
                    </>
                  ) : null
                )}
                <ScrollArea style={{ height: '30rem' }}>
                <Stack spacing="xs" mt="md">
                    {stream.map((item, i) => (
                      <Blockquote key={i} p={'sm'} color='blue'>
                        <Flex align="center" style={{ width: '100%' }}>
                          <Text size="xs" color="dimmed" style={{ minWidth: 140 }}>
                            {typeof item === 'string' ? '' : item.date}
                          </Text>
                          <Flex justify="center" align="center" style={{ flex: 1 }}>
                            {typeof item === 'string' ? (
                              <Text ta="center">{item}</Text>
                            ) : (
                              <Text ta="center">{item.message}</Text>
                            )}
                          </Flex>
                          <div style={{ minWidth: 140, display: 'flex', justifyContent: 'flex-end' }}>
                            <ActionIcon
                              variant="subtle"
                              color="red"
                              aria-label="Delete message"
                              onClick={async () => {
                                try {
                                  setLoading(true)
                                  const pantryId = getPantryId();
                                  if (!pantryId) return;
                                  const res = await axios.delete(`${API_BASE_URL}/pantry/${pantryId}/stream/${i}`);
                                  setStream(res.data.stream || [])
                                } catch (e) {
                                  console.error('Error deleting message:', e)
                                } finally {
                                  setLoading(false)
                                }
                              }}
                            >
                              <IconTrash size={16} />
                            </ActionIcon>
                          </div>
                        </Flex>
                      </Blockquote>
                    ))}
                    </Stack>
                    </ScrollArea>
                    <TextInput 
                      p={'sm'} 
                      radius={'xl'} 
                      placeholder="Type your message..." 
                      value={message}
                      onChange={(e) => setMessage(e.target.value)}
                      leftSection={<IconMessage size={16} />}
                      rightSection={
                        <Button 
                          p={0} 
                          variant="light" 
                          size="xs" 
                          radius="xl" 
                          onClick={() => handleSendMessage()}
                          disabled={loading || !message.trim()}
                        >
                          <IconSend />
                        </Button>
                      }
                    />
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
    const [foodBankName, setFoodBankName] = useState("Food Pantry")
    const [foodBankAddress, setFoodBankAddress] = useState("123 Main St, Belle Mead, NJ 08502")
    const [foodBankPhone, setFoodBankPhone] = useState("(609) 123-4567")
    const [foodBankEmail, setFoodBankEmail] = useState("info@taskfoodbank.org")
    const [settingsLoading, setSettingsLoading] = useState(false)
    
    // Shared data state for dashboard
    const [volunteers, setVolunteers] = useState([])
    const [inventory, setInventory] = useState([])
    
    // Fetch volunteers from backend
    const fetchVolunteers = async () => {
      try {
        const response = await axios.get(`${API_BASE_URL}/volunteer/get`);
        const allVolunteers = response.data;
        
        // Separate verified and unverified volunteers
        const verifiedVolunteers = allVolunteers.filter(vol => vol.verified === true || vol.verified === "True");
        setVolunteers(verifiedVolunteers);
      } catch (error) {
        console.error('Error fetching volunteers:', error);
      }
    };
    
    // Fetch inventory from backend
    const fetchInventory = async () => {
      try {
        const pantryId = getPantryId();
        if (!pantryId) return;
        
        const response = await axios.get(`${API_BASE_URL}/pantry/${pantryId}/inventory`);
        setInventory(response.data.inventory || []);
      } catch (error) {
        console.error('Error fetching inventory:', error);
        // Fallback to default data if API fails
        setInventory([
          { name: 'Tomatoes', current: 44, full: 50, type: 'Produce' },
          { name: 'Broccoli', current: 5, full: 50, type: 'Produce' },
          { name: 'Carrots', current: 30, full: 50, type: 'Produce' },
          { name: 'Apples', current: 50, full: 50, type: 'Produce' },
          { name: 'Tuna Can', current: 12, full: 40, type: 'Cans' }
        ]);
      }
    };
    
    // Fetch pantry data from backend
    const fetchPantryData = async () => {
      try {
        const pantryId = getPantryId();
        if (!pantryId) return;
        
        const response = await axios.get(`${API_BASE_URL}/pantry/info/${pantryId}`);
        const pantryData = response.data;
        
        // Update the form fields with real data
        setFoodBankName(pantryData.name || "Food Pantry");
        setFoodBankAddress(pantryData.address || "123 Main St, Belle Mead, NJ 08502");
        setFoodBankPhone(pantryData.phone_number || "(609) 123-4567");
        setFoodBankEmail(pantryData.email || "info@taskfoodbank.org");
      } catch (error) {
        console.error('Error fetching pantry data:', error);
        // Fallback to localStorage or default values
        const savedSettings = localStorage.getItem('pantry_settings');
        if (savedSettings) {
          const settings = JSON.parse(savedSettings);
          setFoodBankName(settings.name || "Food Pantry");
          setFoodBankAddress(settings.address || "123 Main St, Belle Mead, NJ 08502");
          setFoodBankPhone(settings.phone_number || "(609) 123-4567");
          setFoodBankEmail(settings.email || "info@taskfoodbank.org");
        }
      }
    };
    
    // Load data on component mount
    useEffect(() => {
      fetchVolunteers();
      fetchInventory();
    }, []);
    
    
    // Save settings function
    const handleSaveSettings = async () => {
        try {
            setSettingsLoading(true);
            
            // Get current user data
            const userData = JSON.parse(localStorage.getItem('user_data') || '{}');
            const pantryId = userData._id;
            
            if (!pantryId) {
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
                email: foodBankEmail,
            };
            
            // Call the pantry update API
            await axios.put(`${API_BASE_URL}/pantry/update/${pantryId}`, pantryData);
            
            // Also store in localStorage as backup
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
    
    // Load pantry data on component mount
    useEffect(() => {
        fetchPantryData();
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
              <NavLink label="Settings" icon={<IconSettings size={20} />} onClick={async ()=> {
                await fetchPantryData();
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
                return <DashboardComp volunteers={volunteers} inventory={inventory} />;
              case 'inv':
                return <Inventory foodBankName={foodBankName} />;
              case 'vol':
                return <Volunteer foodBankName={foodBankName} />;
              case 'stream':
                return <Stream />
              default:
                return <DashboardComp volunteers={volunteers} inventory={inventory} />;
            }
          })()}
        </AppShell.Main>
      </AppShell>
    )
  }
export default Dashboard  