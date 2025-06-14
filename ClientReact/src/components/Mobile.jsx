import {Box, Button, Title, Text} from "@mantine/core";

function Mobile() {
    return (
        <Box style={{ backgroundColor: '#fff', padding: '1rem', textAlign: 'center', minHeight: '100vh', minWidth: '100vw'}}>
            <Title order={2}>Mobile View</Title>
            <Text>Welcome to the mobile experience!</Text>
            <Button>Get Started</Button>
        </Box>
    )
}
export default Mobile