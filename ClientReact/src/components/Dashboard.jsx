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
  } from '@mantine/core'
  import {
    IconSettings,
    IconGauge,
    IconCalendar,
    IconUser,
    IconChartBar,
  } from '@tabler/icons-react'
  
 function Dashboard() {
    return (
      <AppShell
        padding="md"
        navbar={{ width: 240 }}
        header={{ height: 70 }}
      >
        {/* Sidebar */}
        <AppShell.Navbar p="md">
          <ScrollArea>
            <Text fw={700} size="xl" mb="lg">
              Donezo
            </Text>
            <NavLink label="Dashboard" icon={<IconGauge size={20} />} />
            <NavLink label="Inventory" icon={<IconChartBar size={20} />} />
            <NavLink label="Calendar" icon={<IconCalendar size={20} />} />
            <NavLink label="Volunteers" icon={<IconChartBar size={20} />} />
            <NavLink label="Stream" icon={<IconUser size={20} />} />
            <Box mt="lg">
              <NavLink label="Settings" icon={<IconSettings size={20} />} />
              <NavLink label="Logout" color='red'/>
            </Box>
          </ScrollArea>
        </AppShell.Navbar>
  
        {/* Header */}
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
  
        {/* Main Content */}
        <AppShell.Main>
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
                  <Text size="sm" fw={500} mb="xs">Analytics</Text>
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
        </AppShell.Main>
      </AppShell>
    )
  }
export default Dashboard  