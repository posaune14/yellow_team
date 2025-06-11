import { Box, Text, Flex, Title, Button, Image } from '@mantine/core'
import { useNavigate } from 'react-router-dom'
import example from "../assets/example.jpeg"
import logo from "../assets/PantrylinkLogo.png"

function Hero() {
    const Navigate = useNavigate()
    return (
        <Box style={{ textAlign: 'right', backgroundColor: '#ad9b97', color: '#000', padding: '2rem', width: '100vw', height: '100vh'}}>
            <Flex
            mih={50}
            gap="xl"
            justify="center"
            align="flex-start"
            direction="row"
            wrap="wrap"
            >
                <Image h={500} w={"auto"} src={example} style={{borderBottomRightRadius: '500px', borderTopRightRadius: '500px'}}></Image>
                <Flex
                mih={50}
                gap="xl"
                justify="center"
                align="flex-end"
                direction="column"
                wrap="wrap"
                >   
                    <Title order={1} color={"dark"}>A One stop, Food Bank Management System</Title>
                    <Title order={2}>Manage your food bank with ease</Title>
                </Flex>
            </Flex>
            <Button padding={"10rem"} margin={"20rem"} size='xl' color={"dark"} onClick={() => Navigate('/signin')}>Get Started</Button>
        </Box>
    )
}

export default Hero