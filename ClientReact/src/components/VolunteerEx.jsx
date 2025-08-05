import { Center, Flex, Space, Text, Container, Group, Paper, Image } from '@mantine/core'
import { motion } from 'framer-motion'
import VolunteerExImg from '../assets/VolunteerEx.png'

export default function VolunteerEx() {
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
                'linear-gradient(135deg,rgb(147, 211, 251) 0%,rgb(87, 145, 245) 100%)',
                'linear-gradient(135deg,rgb(87, 95, 245) 0%,rgb(147, 176, 251) 100%)',
                'linear-gradient(135deg,rgb(51, 55, 156) 0%, rgb(147, 211, 251) 100%)',
                'linear-gradient(135deg,rgb(147, 211, 251) 0%,rgb(87, 145, 245) 100%)'
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
                flexDirection: 'column',
                boxShadow: '0 25px 50px rgba(240, 147, 251, 0.5), 0 15px 30px rgba(245, 87, 108, 0.4)'
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
                Get more community involvement
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
                Through our all-in-one volunteer management system
              </Text>
            </motion.div>
            <Center>
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
                    <Image 
                      src={VolunteerExImg} 
                      alt="VolunteerEx" 
                      style={{ width: '40rem', height: 'auto', maxWidth: '40rem', objectFit: 'contain' }} 
                    />
                  </motion.div>
                </Flex>
              </motion.div>
            </Center>
          </Paper>
            </motion.div>
        </motion.div>   
    )
}