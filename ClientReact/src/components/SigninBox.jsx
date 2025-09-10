import { Box, Text, TextInput, Button, Center, Container, Title, Fieldset, Anchor } from '@mantine/core'
import { useNavigate } from 'react-router-dom'
import axios from 'axios'
import { useState } from 'react'
import { notifications } from '@mantine/notifications'
import { IconCheck, IconX } from '@tabler/icons-react'

function SigninBox() {
    const [username, setUsername] = useState("")
    const [password, setPassword] = useState("")
    const [loading, setLoading] = useState(false)
    const navigate = useNavigate()
    
    // API Base URL - corrected to match server port
    const API_BASE_URL = 'http://localhost:3000';
    
    const handleSignIn = async() => {
        if (!username.trim() || !password.trim()) {
            notifications.show({
                title: 'Error',
                message: 'Please enter both username and password',
                color: 'red',
                icon: <IconX size={16} />,
                autoClose: 3000,
            });
            return;
        }

        try {
            setLoading(true);
            const response = await axios.post(`${API_BASE_URL}/pantry_login/log_in/`, {
                username: username,
                password: password,
            });

            if (response.status === 200) {
                // Store the access token
                localStorage.setItem('token', response.data.access_token);
                localStorage.setItem('refresh_token', response.data.refresh_token);
                localStorage.setItem('user_data', JSON.stringify(response.data.user_database));
                
                notifications.show({
                    title: 'Welcome!',
                    message: `Welcome back, ${response.data.user_database.username}!`,
                    color: 'green',
                    icon: <IconCheck size={16} />,
                    autoClose: 3000,
                });
                
                navigate('/dashboard');
            }
        } catch (error) {
            console.error('Sign in error:', error);
            notifications.show({
                title: 'Sign In Failed',
                message: error.response?.data?.error || 'Invalid username or password',
                color: 'red',
                icon: <IconX size={16} />,
                autoClose: 3000,
            });
        } finally {
            setLoading(false);
        }
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
                    variant="light" 
                    color="gray" 
                    size="md" 
                    radius="xl"
                    loading={loading}
                    disabled={loading}
                >
                    {loading ? 'Signing in...' : 'Sign in'}
                </Button>
                <Text style={{padding: '2rem'}}>New here? <Anchor onClick={() => navigate('/signup')}>Register your food bank today.</Anchor> </Text>
                
            </Container>
        </Center>
    )
}

export default SigninBox