import {Box, Button, Title, Text, Image} from "@mantine/core";
import { motion } from "framer-motion"
import appstore from "../assets/appstore.svg"
function Mobile() {
    return (
        <Box style={{ background: 'linear-gradient(120deg, #d3bdb3, #917f7b)', padding: '1rem', textAlign: 'center', minHeight: '100vh', minWidth: '100vw'}}>
            <Title order={2}>PantryLink</Title>
            <Text>Welcome to the mobile experience!</Text>
            <Image src="appstore"/>
        </Box>
    )
}
export default Mobile