import { useState } from 'react'
import { Center, Container, Text, Title, Fieldset, TextInput, Button } from '@mantine/core'
import './App.css'

function App() {
  return (
    <>
      <Center>
        <Container style={{ borderRadius: '40px', backgroundColor: '#fff', height: '35rem', width: '30rem', margin: '1rem' }}>
          <Title order={1} style={{ padding: '2rem'}}>
            Food Bank Sign In
          </Title>
          <Center>
            <Fieldset legend="Food bank information" bg="transparent" style={{textAlign:'left', width:"20rem", height: "15rem", margin: '2rem'}}>
              <TextInput label="Food Bank" placeholder="Enter your username here"   size="xl" />
              <TextInput label="Password" placeholder="Enter your password here"   size="xl" mt="md" type='password'/>
            </Fieldset>
          </Center>

            <Button margin="xl" varient="light" color="gray" size="md" radius="xl">Sign in</Button>
        </Container>
      </Center>
    </>
  )
}

export default App
