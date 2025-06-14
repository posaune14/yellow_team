import { Box, Text, Flex, Title, Button, Image, Container } from '@mantine/core'
import { useNavigate } from 'react-router-dom'
import example from "../assets/example.jpeg"
import logo from "../assets/PantrylinkLogo.png"

function Hero() {
    const Navigate = useNavigate()
    return (
        <Box style={{ marginTop: '-2rem',shrinkToFit: 'true', textAlign: 'center', minHeight: '88vh',minWidth: '100vw', backgroundImage: 'linear-gradient(to right, #D3BDB3, #917F7B)', backgroundRepeat: 'no-repeat',}}>
            <Flex
            style={{ height: '100%' }}
            gap="xl"
            justify="flex-start"
            align="flex-start"
            direction="row"
            wrap="nowrap"
            >
            {/* Left-aligned image */}
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

            {/* Text content */}
            <Flex
                mih={50}
                gap="xl"
                justify="center"
                align="flex-start"
                direction="column"
                style={{ flexGrow: 1 }}
            >
                <Title order={1} color="dark">
                A One stop, Food Bank Management System
                </Title>
                <Title order={2}>Manage your food bank with ease</Title>
            </Flex>
            </Flex>

            <Box mt="xl">
                <Button size="xl" color="dark" onClick={() => Navigate('/signin')}>
                    Get Started
                </Button>
            </Box>     
            </Box>
        );

}

export default Hero