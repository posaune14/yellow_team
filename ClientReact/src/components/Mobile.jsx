import { Box, Button, Title, Text, Image, Paper, Flex, Group, Badge, Stack, Container } from "@mantine/core";
import { motion } from "framer-motion"
import appstore from "../assets/appstore.svg"

function Mobile() {
    return (
        <Box style={{ 
            background: 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)', 
            padding: '2rem', 
            textAlign: 'center', 
            minHeight: '100vh', 
            minWidth: '100vw',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center'
        }}>
            <Container size="sm">
                <motion.div
                    initial={{ opacity: 0, y: 30 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ duration: 0.8 }}
                >
                    <Paper
                        p="xl"
                        radius="lg"
                        shadow="xl"
                        style={{
                            background: 'rgba(255, 255, 255, 0.15)',
                            backdropFilter: 'blur(20px)',
                            border: '1px solid rgba(255, 255, 255, 0.2)',
                            color: 'white'
                        }}
                    >
                        <Stack spacing="xl" align="center">
                            {/* Header */}
                            <motion.div
                                initial={{ opacity: 0, scale: 0.9 }}
                                animate={{ opacity: 1, scale: 1 }}
                                transition={{ duration: 0.6, delay: 0.2 }}
                            >
                                <Title order={1} size="2.5rem" fw={800} style={{ color: 'white', marginBottom: '0.5rem' }}>
                                    PantryLink Mobile
                                </Title>
                                <Text size="lg" style={{ color: 'white', opacity: 0.9 }}>
                                    Connect with your community on the go
                                </Text>
                            </motion.div>

                            {/* App Store Download Section */}
                            <motion.div
                                initial={{ opacity: 0, y: 20 }}
                                animate={{ opacity: 1, y: 0 }}
                                transition={{ duration: 0.6, delay: 0.4 }}
                            >
                                <Text size="xl" fw={700} style={{ color: 'white', marginBottom: '1rem' }}>
                                    Download Our Mobile App
                                </Text>
                                <Text size="md" style={{ color: 'white', opacity: 0.9, marginBottom: '2rem' }}>
                                    Available on iOS devices only.
                                </Text>

                                <Group justify="center" gap="lg" wrap="wrap">
                                    {/* App Store Badge */}
                                    <motion.div
                                        whileHover={{ scale: 1.05, y: -5 }}
                                        whileTap={{ scale: 0.95 }}
                                        transition={{ duration: 0.2 }}
                                        style={{ cursor: 'pointer' }}
                                    >
                                        <Paper
                                            p="md"
                                            radius="md"
                                            style={{
                                                background: 'rgba(255, 255, 255, 0.1)',
                                                border: '1px solid rgba(255, 255, 255, 0.2)',
                                                backdropFilter: 'blur(10px)',
                                                transition: 'all 0.3s ease'
                                            }}
                                        >
                                            <Flex align="center" gap="md">
                                                <Image 
                                                    src={appstore} 
                                                    alt="Download on App Store" 
                                                    width={100} 
                                                    height="auto"
                                                    style={{ filter: 'brightness(1) invert(1)' }}
                                                />
                                            </Flex>
                                        </Paper>
                                    </motion.div>

                                    
                                </Group>
                            </motion.div>

                            {/* App Features */}
                            <motion.div
                                initial={{ opacity: 0, y: 20 }}
                                animate={{ opacity: 1, y: 0 }}
                                transition={{ duration: 0.6, delay: 0.6 }}
                            >
                                <Text size="lg" fw={600} style={{ color: 'white', marginBottom: '1rem' }}>
                                    Key Features
                                </Text>
                                <Group justify="center" gap="md" wrap="wrap">
                                    <Badge 
                                        size="lg" 
                                        variant="light" 
                                        style={{ 
                                            background: 'rgba(255, 255, 255, 0.2)', 
                                            color: 'white',
                                            border: '1px solid rgba(255, 255, 255, 0.3)'
                                        }}
                                    >
                                        📱 Real-time Updates
                                    </Badge>
                                    <Badge 
                                        size="lg" 
                                        variant="light" 
                                        style={{ 
                                            background: 'rgba(255, 255, 255, 0.2)', 
                                            color: 'white',
                                            border: '1px solid rgba(255, 255, 255, 0.3)'
                                        }}
                                    >
                                        🔔 Push Notifications
                                    </Badge>
                                    <Badge 
                                        size="lg" 
                                        variant="light" 
                                        style={{ 
                                            background: 'rgba(255, 255, 255, 0.2)', 
                                            color: 'white',
                                            border: '1px solid rgba(255, 255, 255, 0.3)'
                                        }}
                                    >
                                        📊 Live Analytics
                                    </Badge>
                                </Group>
                            </motion.div>

                            {/* Download Stats */}
                            <motion.div
                                initial={{ opacity: 0, y: 20 }}
                                animate={{ opacity: 1, y: 0 }}
                                transition={{ duration: 0.6, delay: 0.8 }}
                            >
                            </motion.div>
                        </Stack>
                    </Paper>
                </motion.div>
            </Container>
        </Box>
    )
}

export default Mobile