import { Box, Text, Flex, Title, Button, Image, Badge } from '@mantine/core'
import { useNavigate } from 'react-router-dom'
import { motion } from 'framer-motion'
import example from '../assets/example.jpeg'
import { useRef, useState } from 'react'
import { TextAnimate } from '@gfazioli/mantine-text-animate'

function Hero({ onScrollClick1, onScrollClick2, onScrollClick3 }) {
  const navigate = useNavigate()

  const [isTypeEnd, setIsTypeEnd] = useState(0);
  const [isTypeLoop, setIsTypeLoop] = useState(0);
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
            <TextAnimate.Typewriter
              onTypeEnd={() => {
                setIsTypeEnd((prev) => prev + 1);
              }}
              onTypeLoop={() => {
                setIsTypeLoop((prev) => prev + 1);
              }}
              fw={700}
              size="xl"
              pauseDelay={1000}
              value={[
                'Track donations',
                'Manage inventory',
                'Support your community',
                'Schedule Volunteers'
              ]}
            />

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