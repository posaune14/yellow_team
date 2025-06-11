import React from "react";
import { Box, Flex, Title, Button, Text } from "@mantine/core";
import { useNavigate } from "react-router-dom";
function Nav() {
    const navigate = useNavigate();

    return (
        <Box style={{ backgroundColor: '#917F7B', color: '#000', width: '100vw' }}>
            <Flex
                mih={50}
                gap="xl"
                justify="space-between"
                align="center"
                direction="row"
                wrap="wrap"
            >
                <Text>Navbar goes here</Text>
            </Flex>
        </Box>
    );
}
export default Nav;