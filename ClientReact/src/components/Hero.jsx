import { Box, Text, Flex, Title, Button, Image, Badge } from '@mantine/core'
import { useNavigate } from 'react-router-dom'
import { motion } from 'framer-motion'
import example from '../assets/example.jpeg'
import { useRef } from 'react'

function Hero({ onScrollClick1, onScrollClick2, onScrollClick3 }) {
  const navigate = useNavigate()

  return (
    <Box
      style={{
        position: 'relative',
        overflow: 'hidden',
        minHeight: '100vh',
        width: '100vw', 
        padding: '3rem 0', 
        margin: '0',
        background: 'linear-gradient(120deg, #d3bdb3, #917f7b)',
      }}
    >
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 0.2 }}
        transition={{ duration: 2 }}
        style={{
          position: 'absolute',
          top: '30%',
          left: '50%',
          transform: 'translate(-50%, -50%)',
          width: 600,
          height: 600,
          background: 'radial-gradient(circle, white 0%, transparent 80%)',
          filter: 'blur(150px)',
          zIndex: 0,
        }}
      />

      <Flex
        direction="row"
        justify="space-between"
        align="center"
        style={{ position: 'relative', zIndex: 2, flexWrap: 'wrap', width: '100%', maxWidth: '100vw', margin: '0 auto' }}
      >
        <Flex
          direction="column"
          gap="md"
          style={{
            maxWidth: '600px',
            padding: '2rem',
            flex: '1 1 50%',
          }}
        >
          <motion.div
            initial={{ y: 30, opacity: 0 }}
            animate={{ y: 0, opacity: 1 }}
            transition={{ duration: 1 }}
          >
            <Title order={1} size="3rem" style={{ fontWeight: 800 }}>
              One Platform. Every Tool Your Food Bank Needs.
            </Title>

            <Text size="lg" mt="sm">
              Track donations, manage inventory, and support your community - effortlessly.
            </Text>

            <Flex gap="sm" mt="md">
              <Button onClick={onScrollClick1} variant="transparent"  padding='-1rem'>
                <Badge color="dark" variant="filled">Mobile App</Badge>
              </Button>
              <Button onClick={onScrollClick2} variant="transparent" padding='-1rem'>
                <Badge color="dark" variant="light">Volunteer Scheduling</Badge>
             </Button>
              <Button onClick={onScrollClick3} variant="transparent" padding='-1rem'>
                <Badge color="dark" variant="light">Inventory Tracking</Badge>
              </Button>
            </Flex>

            <motion.div
              whileHover={{ scale: 1.05 }}
              transition={{ type: 'spring', stiffness: 300 }}
              style={{ marginTop: '2rem' }}
            >
              <Button size="lg" color="dark" onClick={() => navigate('/signin')}>
                Get Started
              </Button>
            </motion.div>
          </motion.div>
        </Flex>

        <motion.div
          initial={{ scale: 0.9, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          transition={{ duration: 1.2 }}
          style={{ flex: '1 1 40%', display: 'flex', justifyContent: 'center' }}
        >
          <Image
            src={example}
            style={{
              width: 'auto',
              height: 'auto',
              maxWidth: '100%', 
              borderRadius: '1rem',
              objectFit: 'contain',
              boxShadow: '0 8px 24px rgba(0, 0, 0, 0.2)',
            }}
            alt="Example"
          />
        </motion.div>
      </Flex>

      <motion.div
        animate={{ y: [0, 10, 0] }}
        transition={{ repeat: Infinity, duration: 2 }}
        style={{
          position: 'absolute',
          bottom: '2rem',
          left: '50%',
          transform: 'translateX(-50%)',
          zIndex: 2,
        }}
      >
        <Text size="xl" color="white">↓</Text>
      </motion.div>
    </Box>
  )
}

export default Hero



{/*import { Box, Text, Flex, Title, Button, Image, Container } from '@mantine/core'
import { useNavigate } from 'react-router-dom'
import example from "../assets/example.jpeg"
import logo from "../assets/PantrylinkLogo.png"
import { motion } from 'framer-motion';
function Hero() {
    const Navigate = useNavigate()
    return (
        <Box style={{ padding: '2rem 2rem 2rem 0', marginTop: '-2rem',shrinkToFit: 'true', textAlign: 'center', minHeight: '100vh',minWidth: '100vw', backgroundImage: 'linear-gradient(to right, #D3BDB3, #917F7B)', backgroundRepeat: 'no-repeat',}}>
            <Flex
            style={{ height: '100%' }}
            gap="xl"
            justify="flex-start"
            align="flex-start"
            direction="row"
            wrap="nowrap"
            >
            
            <Box style={{ flexShrink: 0 }}>
                <Image
                h="25rem"
                w="auto"
                src={example}
                style={{
                    marginLeft: '-10rem',
                    margin: 0,
                    borderBottomRightRadius: '500px',
                    borderTopRightRadius: '500px',
                    display: 'block',
                }}
                />
            </Box>

            <Flex
                mih={50}
                gap="xl"
                justify="center"
                align="flex-start"
                direction="column"
                style={{ flexGrow: 1 }}
            >
                <motion.div
                    initial={{ opacity: 0, x: 100 }} 
                    animate={{ opacity: 1, x: 0 }}
                    transition={{ duration: 1, delay: 0.2, easing: 'ease-in-out' }}
                >
                    <Title order={1} color="dark">
                    A One stop, Food Bank Management System
                    </Title>
                    <Title order={2}>Manage your food bank with ease</Title>
                </motion.div>
            </Flex>
            </Flex>

            <Box mt="xl">
                <motion.div 
                    whileHover={{ scale: 1.1, rotate: 2 }}
                    transition={{ type: 'spring', stiffness: 300 }}>
                        <Button size="xl" color="dark" onClick={() => Navigate('/signin')}>
                            Get Started
                        </Button>
                    </motion.div>
                
            </Box>     
            </Box>
        );

}

export default Hero*/}