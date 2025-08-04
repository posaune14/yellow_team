import { Container, Title, Text, Button, Center, Image, Flex, Paper } from '@mantine/core'
import { useNavigate } from 'react-router-dom'
import homePageBottom from '../assets/homePageBottom.png'
import homePageTop from '../assets/homePageTop.png'
import { useEffect, useRef, forwardRef, useState } from 'react'
import { motion } from 'framer-motion'


 
const MobileEx = forwardRef((props, ref) => {
    const navigate = useNavigate()

    return (
        <motion.div
          initial={{ opacity: 0, scale: 0.9 }}
          whileInView={{ opacity: 1, scale: 1 }}
          viewport={{ once: true }}
          transition={{ duration: 0.8 }}
        >
          <motion.div
            animate={{
              background: [
                'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)',
                'linear-gradient(135deg, #f5576c 0%, #f093fb 100%)',
                'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)'
              ]
            }}
            transition={{ duration: 8, repeat: Infinity, ease: "easeInOut" }}
            style={{
              borderRadius: 'var(--mantine-radius-xl)',
              overflow: 'hidden'
            }}
          >
            <Paper
              p="xl"
              radius="xl"
              shadow="xl"
              style={{
                background: 'inherit',
                minHeight: '100vh',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                flexDirection: 'column'
              }}
            >
            <motion.div
              initial={{ opacity: 0, y: 30 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.6, delay: 0.2 }}
              whileHover={{ scale: 1.05, y: -5 }}
              style={{ cursor: 'pointer' }}
            >
              <Text 
                size="2em"
                fw={900}
                style={{ color: 'white', textAlign: 'center' }}
              >
                Seamlessly connect to clients
              </Text>
            </motion.div>
            <motion.div
              initial={{ opacity: 0, y: 30 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.6, delay: 0.4 }}
              whileHover={{ scale: 1.05, y: -5 }}
              style={{ cursor: 'pointer' }}
            >
              <Text 
                size="3em"
                fw={900}
                style={{ color: 'white', opacity: 0.9, textAlign: 'center' }}
              >
                Through our state-of-the-art mobile app
              </Text>
            </motion.div>
            <Center ref={ref} {...props}>
              <motion.div
                initial={{ opacity: 0, y: 50 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.8, delay: 0.6 }}
              >
                <Flex
                  mih={50}
                  gap={"5rem"}
                  justify="center"
                  align="flex-start"
                  direction="row"
                  wrap="wrap"
                >
                  <motion.div
                    initial={{ opacity: 0, x: -50 }}
                    whileInView={{ opacity: 1, x: 0 }}
                    viewport={{ once: true }}
                    transition={{ duration: 0.6, delay: 0.8 }}
                    whileHover={{ scale: 1.1, y: -15, rotate: -2 }}
                    style={{ cursor: 'pointer' }}
                  >
                    <Image h={400} w={'auto'} src={homePageTop} />
                  </motion.div>
                  <motion.div
                    initial={{ opacity: 0, x: 50 }}
                    whileInView={{ opacity: 1, x: 0 }}
                    viewport={{ once: true }}
                    transition={{ duration: 0.6, delay: 1.0 }}
                    whileHover={{ scale: 1.1, y: -15, rotate: 2 }}
                    style={{ cursor: 'pointer' }}
                  >
                    <Image h={400} w={'auto'} src={homePageBottom} />
                  </motion.div>
                </Flex>
              </motion.div>
            </Center>
          </Paper>
            </motion.div>
        </motion.div>
    )
})


export default MobileEx;