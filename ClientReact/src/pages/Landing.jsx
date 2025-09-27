import Hero from '../components/Hero'
import MobileEx from '../components/MobileEx'
import { Center, Flex, Space, Text, Container, Group, Paper, Grid, Button, Image } from '@mantine/core'
import {useMediaQuery} from '@mantine/hooks'
import Mobile from '../components/Mobile'
import { useRef } from 'react'
import InventoryEx from '../components/InventoryEx'
import { motion } from 'framer-motion'
import { Link, useNavigate } from 'react-router-dom'
import VolunteerEx from '../components/VolunteerEx'
import JFCS from '../assets/JFCS.png'
import Somerset from '../assets/Somerset.png'
function Landing() {
    const MobileExRef = useRef(null);
    const navigate = useNavigate();
    const scrollToMobileEx = () => {
        MobileExRef.current?.scrollIntoView({ behavior: 'smooth' });
    };
    const isMobile = useMediaQuery('(max-width: 768px)');
    return isMobile ? (
    <Mobile />
  ) : (
        <>
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ duration: 0.8 }}
        >
          <Flex   
              mih={50}
              gap="xl"
              justify="center"
              align="center"
              direction="column"
              wrap="wrap">
              {/* <Nav /> */}
              <motion.div
                initial={{ opacity: 0, y: 30 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6 }}
                whileHover={{ scale: 1.02 }}
                style={{ cursor: 'pointer' }}
              >
                <Hero onScrollClick={scrollToMobileEx}/>
              </motion.div>
              <Space h='2rem'/>
              <motion.div
                initial={{ opacity: 0, y: 30 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: 0.3 }}
                whileHover={{ scale: 1.02 }}
                style={{ cursor: 'pointer' }}
              >
                <MobileEx ref={MobileExRef}/>
              </motion.div>
              <Space h='2rem'/>
              <motion.div
                initial={{ opacity: 0, y: 30 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: 0.6 }}
                whileHover={{ scale: 1.02 }}
                style={{ cursor: 'pointer' }}
              >
                <InventoryEx />
              </motion.div>
              <Space h='2rem'/>
              <motion.div
                initial={{ opacity: 0, y: 30 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: 0.6 }}
                whileHover={{ scale: 1.02 }}
                style={{ cursor: 'pointer' }}
              >
                <VolunteerEx />
              </motion.div>
              {/* Features Section */}
              <motion.div
                initial={{ opacity: 0, y: 30 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: 0.75 }}
              >
                <Container size="lg" py="xl">
                  <Paper
                    p="xl"
                    radius="lg"
                    shadow="md"
                    style={{
                      background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
                      color: 'white',
                      boxShadow: '0 20px 40px rgba(102, 126, 234, 0.4), 0 10px 20px rgba(118, 75, 162, 0.3)'
                    }}
                  >
                    <Text size="2xl" fw={700} ta="center" mb="xl">
                      Why Choose PantryLink?
                    </Text>
                    <Grid>
                      <Grid.Col span={3}>
                        <motion.div
                          whileHover={{ scale: 1.05, y: -5 }}
                          transition={{ duration: 0.2 }}
                        >
                          <Paper p="md" radius="md" style={{ background: 'rgba(255,255,255,0.1)', backdropFilter: 'blur(10px)' }}>
                            <Text size="lg" fw={600} mb="xs">📱 Mobile-First</Text>
                            <Text size="sm" style={{ opacity: 0.9 }}>
                              Deliver real-time updates to your clients and volunteers instantly, through our free, all-in-one mobile app.
                            </Text>
                          </Paper>
                        </motion.div>
                      </Grid.Col>
                      <Grid.Col span={3}>
                        <motion.div
                          whileHover={{ scale: 1.05, y: -5 }}
                          transition={{ duration: 0.2, delay: 0.1 }}
                        >
                          <Paper p="md" radius="md" style={{ background: 'rgba(255,255,255,0.1)', backdropFilter: 'blur(10px)' }}>
                            <Text size="lg" fw={600} mb="xs">📊 Real-Time Analytics</Text>
                            <Text size="sm" style={{ opacity: 0.9 }}>
                              Track inventory levels, volunteer hours, and client statistics in real-time, through our intuitive dashboard.
                            </Text>
                          </Paper>
                        </motion.div>
                      </Grid.Col>
                      <Grid.Col span={3}>
                        <motion.div
                          whileHover={{ scale: 1.05, y: -5 }}
                          transition={{ duration: 0.2, delay: 0.2 }}
                        >
                          <Paper p="md" radius="md" style={{ background: 'rgba(255,255,255,0.1)', backdropFilter: 'blur(10px)' }}>
                            <Text size="lg" fw={600} mb="xs">🤝 Community Focused</Text>
                            <Text size="sm" style={{ opacity: 0.9 }}>
                              Built specifically for food banks and community organizations to serve their communities better.
                            </Text>
                          </Paper>
                        </motion.div>
                      </Grid.Col>
                      <Grid.Col span={3}>
                        <motion.div
                          whileHover={{ scale: 1.05, y: -5 }}
                          transition={{ duration: 0.2, delay: 0.2 }}
                        >
                          <Paper p="md" radius="md" style={{ background: 'rgba(255,255,255,0.1)', backdropFilter: 'blur(10px)' }}>
                            <Text size="lg" fw={600} mb="xs">💸 It's Free!</Text>
                            <Text size="sm" style={{ opacity: 0.9 }}>
                              PantryLink was developed as a non-profit project by the Yellow Team, a group of students from theCoderSchool Montgomery, to help food banks and community organizations serve their communities better. It will be submitted to the <a href="https://congressionalappchallenge.us/" target="_blank" rel="noopener noreferrer">Congressional App Challenge</a>.
                            </Text>
                          </Paper>
                        </motion.div>
                      </Grid.Col>
                    </Grid>
                  </Paper>
                </Container>
              </motion.div>
              
              {/* Stats Section */}
              <motion.div
                initial={{ opacity: 0, y: 30 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: 0.9 }}
              >
                <Container size="lg" py="xl">
                  <Paper
                    p="xl"
                    radius="lg"
                    shadow="md"
                    style={{
                      background: 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)',
                      color: 'white',
                      boxShadow: '0 20px 40px rgba(240, 147, 251, 0.4), 0 10px 20px rgba(245, 87, 108, 0.3)'
                    }}
                  >
                    <Text size="2xl" fw={700} ta="center" mb="xl">
                      Our Partners
                    </Text>
                    <Grid>
                      <Grid.Col span={5}>
                        <motion.div
                          whileHover={{ scale: 1.05 }}
                          transition={{ duration: 0.2 }}
                        >
                          <a href="https://www.jfcsonline.org/" target="_blank" rel="noopener noreferrer" style={{textDecoration: 'none', color: 'white'}}>
                            <Image src={JFCS} alt="JFCS" width={100} height={'auto'} />
                            <Text size="sm" ta="center" style={{ opacity: 0.9 }}>Jewish Family and Community Services - Mercer County</Text>
                          </a>
                        </motion.div>
                      </Grid.Col>
                      <Grid.Col span={5}>
                        <motion.div
                          whileHover={{ scale: 1.05 }}
                          transition={{ duration: 0.2, delay: 0.1 }}
                        >
                          <a href="https://www.somersetfoodbank.org/" target="_blank" rel="noopener noreferrer" style={{textDecoration: 'none', color: 'white'}}>
                            <Image src={Somerset} alt="Somerset" width={100} height={'auto'} />
                            <Text size="sm" ta="center" style={{ opacity: 0.9 }}>The Food Bank Network of Somerset County</Text>
                          </a>
                        </motion.div>
                      </Grid.Col>
                      
                      <Grid.Col span={2}>
                        <motion.div
                          whileHover={{ scale: 1.05 }}
                          transition={{ duration: 0.2, delay: 0.3 }}
                        >
                          <Link to="/signup" style={{textDecoration: 'none', color: 'white'}}>
                            <Text size="3em" fw={700} ta="center">🫵</Text>
                            <Text size="sm" ta="center" style={{ opacity: 0.9 }}>Get your food bank on PantryLink today</Text>
                          </Link>
                        </motion.div>
                      </Grid.Col>
                    </Grid>
                  </Paper>
                </Container>
              </motion.div>
              
              {/* CTA Section */}
              <motion.div
                initial={{ opacity: 0, y: 30 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: 1.05 }}
              >
                <Container size="lg" py="xl">
                  <Paper
                    p="xl"
                    radius="lg"
                    shadow="md"
                    style={{
                      background: 'linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)',
                      color: 'white',
                      boxShadow: '0 20px 40px rgba(67, 233, 123, 0.4), 0 10px 20px rgba(56, 249, 215, 0.3)'
                    }}
                  >
                    <Text size="2xl" fw={700} ta="center" mb="md">
                      Ready to Transform Your Food Bank?
                    </Text>
                    <Text size="lg" ta="center" mb="xl" style={{ opacity: 0.9 }}>
                      Join PantryLink today to serve your community better.
                    </Text>
                    <Center>
                      <motion.div
                        whileHover={{ scale: 1.05 }}
                        whileTap={{ scale: 0.95 }}
                      >
                        <Button 
                          size="lg" 
                          variant="white" 
                          color="dark"
                          radius="xl"
                          fw={600}
                          onClick={() => navigate('/signin')}
                        >
                          Get Started Today
                        </Button>
                      </motion.div>
                    </Center>
                  </Paper>
                </Container>
              </motion.div>
              
              <motion.div
                initial={{ opacity: 0, y: 30 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.6, delay: 0.9 }}
              >
                <Container size="lg" py="xl">
                  <Paper
                    p="xl"
                    radius="lg"
                    shadow="md"
                    style={{
                      background: 'linear-gradient(135deg, #2c3e50 0%, #34495e 100%)',
                      color: 'white',
                      boxShadow: '0 20px 40px rgba(44, 62, 80, 0.4), 0 10px 20px rgba(52, 73, 94, 0.3)'
                    }}
                  >
                    <Group justify="center" align="center">
                      <div>
                        <Text size="lg" fw={600} mb="xs">
                          Made with ❤️ by the Yellow Team
                        </Text>
                        <Text size="sm" style={{ opacity: 0.8 }}>
                          Read more about us <Link to="/credits" style={{color: 'white'}}>here</Link>
                        </Text>
                      </div>
                      
                    </Group>
                    <Text size="xs" style={{ opacity: 0.6 }} mt="md" ta="center">
                      Copyright 2025 <a href="https://thecoderschool.com/montgomery" target="_blank" rel="noopener noreferrer" style={{color: 'white'}}>theCoderSchool Montgomery</a>. All Rights Reserved.
                    </Text>
                  </Paper>
                </Container>
              </motion.div>
          </Flex>
        </motion.div>
        </>
    )
}

export default Landing