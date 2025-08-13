import { Box, Text, TextInput, Button, Center, Container, Title, Fieldset, Anchor } from '@mantine/core'
import { useNavigate } from 'react-router-dom'
import axios from 'axios'
import { useState } from 'react'
function SigninBox() {
    const [username, setUsername] = useState("")
    const [password, setPassword] = useState("")
    const navigate = useNavigate()
    
    const handleSignIn = async() => {
         axios.post("http://localhost:8080/pantry",{
            username: username,
            password: password,

         })
         .then(function(response){
            console.log(response)
            if(response.status == 200){
                navigate('/dashboard')
            }else{
                console.log("incorrect user/pass")
            }
         })
         .catch(function(error){
            console.error(error)
         }
         )
    }
    
    return (

        <Center>
            <Container style={{ borderRadius: '40px', backgroundColor: '#fff', height: '35rem', width: '30rem', margin: '1rem' }}>
            <Title order={1} style={{ padding: '2rem'}}>
                Food Bank Sign In
            </Title>
            <Center>
                <Fieldset legend="Food bank information" bg="transparent" style={{textAlign:'left', width:"20rem", height: "15rem", margin: '2rem'}}>
                    <TextInput label="Food Bank" placeholder="Enter your username here"  value={username} onChange={(e)=>{setUsername(e.target.value)}} size="xl" />
                    <TextInput label="Password" placeholder="Enter your password here"  value={password} onChange={(e)=>{setPassword(e.target.value)}} size="xl" mt="md" type='password'/>
                </Fieldset>
            </Center>

                <Button 
                    onClick={handleSignIn}
                    margin="xl" 
                    varient="light" 
                    color="gray" 
                    size="md" 
                    radius="xl"
                >
                    Sign in
                </Button>
                <button
                onClick={navigate('/dashboard')}>Dev Button</button>
                <Text style={{padding: '2rem'}}>New here? <Anchor>Register your food bank today.</Anchor> </Text>
                
            </Container>
        </Center>
    )
}

export default SigninBox