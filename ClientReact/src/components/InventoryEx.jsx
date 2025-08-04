import {forwardRef, useRef} from 'react'
import { Container, Title, Text, Button, Center, Image, Flex, Paper } from '@mantine/core'
import { useNavigate } from 'react-router-dom'
import InventoryExImg from '../assets/InventoryExample.png'
import { motion } from 'framer-motion'

const InventoryEx = forwardRef((props, ref) => {
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
                'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
                'linear-gradient(135deg, #764ba2 0%, #667eea 100%)',
                'linear-gradient(135deg, #667eea 0%, #764ba2 100%)'
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
                justifyContent: 'center'
              }}
            >
            <Center ref={ref} {...props}>
              <motion.div
                initial={{ opacity: 0, y: 50 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ duration: 0.6, delay: 0.2 }}
              >
                <Flex
                  mih={50}
                  gap={"1rem"}
                  justify="center"
                  align="center"
                  direction="column"
                  wrap="wrap"
                >
                  <motion.div
                    initial={{ opacity: 0, y: 30 }}
                    whileInView={{ opacity: 1, y: 0 }}
                    viewport={{ once: true }}
                    transition={{ duration: 0.6, delay: 0.4 }}
                    whileHover={{ scale: 1.05, y: -5 }}
                    style={{ cursor: 'pointer' }}
                  >
                    <Text 
                      size="2em"
                      fw={900}
                      style={{ color: 'white' }}
                    >
                      Manage and publish your inventory
                    </Text>
                  </motion.div>
                  <motion.div
                    initial={{ opacity: 0, y: 30 }}
                    whileInView={{ opacity: 1, y: 0 }}
                    viewport={{ once: true }}
                    transition={{ duration: 0.6, delay: 0.6 }}
                    whileHover={{ scale: 1.05, y: -5 }}
                    style={{ cursor: 'pointer' }}
                  >
                    <Text 
                      size="3em"
                      fw={900}
                      style={{ color: 'white', opacity: 0.9 }}
                    >
                      Using our intuitive dashboard
                    </Text>
                  </motion.div>
                  <motion.div
                    initial={{ opacity: 0, scale: 0.8 }}
                    whileInView={{ opacity: 1, scale: 1 }}
                    viewport={{ once: true }}
                    transition={{ duration: 0.8, delay: 0.8 }}
                    whileHover={{ scale: 1.1, rotate: 2 }}
                    style={{ cursor: 'pointer' }}
                  >
                    <Image h={400} w={'auto'} alt='inventoryEx' src={InventoryExImg} />
                  </motion.div>
                </Flex>
              </motion.div>
            </Center>
          </Paper>
            </motion.div>
        </motion.div>
    )
})
export default InventoryEx;