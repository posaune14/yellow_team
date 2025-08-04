import Hero from '../components/Hero'
import MobileEx from '../components/MobileEx'
import { Center, Flex, Space, Text, Container, Group, Paper } from '@mantine/core'
import {useMediaQuery} from '@mantine/hooks'
import Mobile from '../components/Mobile'
import { useRef } from 'react'
import InventoryEx from '../components/InventoryEx'
import { motion } from 'framer-motion'
import { Link } from 'react-router-dom'
function Landing() {
    const MobileExRef = useRef(null);

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
                      color: 'white'
                    }}
                  >
                    <Group justify="space-between" align="center">
                      <div>
                        <Text size="lg" fw={600} mb="xs">
                          Made with ❤️ by the Yellow Team
                        </Text>
                        <Text size="sm" style={{ opacity: 0.8 }}>
                          Read more about us <Link to="/credits">here</Link>
                        </Text>
                      </div>
                      
                    </Group>
                    <Text size="xs" style={{ opacity: 0.6 }} mt="md" ta="center">
                      Copyright 2025 <a href="https://thecoderschool.com/montgomery" target="_blank" rel="noopener noreferrer">theCoderSchool Montgomery</a>. All Rights Reserved.
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