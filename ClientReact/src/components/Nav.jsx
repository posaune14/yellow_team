import React from "react";
import { Box, Flex, Title, Button, Text, Image } from "@mantine/core";
import logo from "../assets/PantrylinkLogo.png";
import { useNavigate } from "react-router-dom";
function Nav() {
    const navigate = useNavigate();

    return (
        <Box style={{ textAlign: 'center', backgroundColor: '#917F7B', color: '#000', width: '100vw' }}>
            <Flex
                mih={50}
                gap="xl"
                justify="space-between"
                align="center"
                direction="row"
                wrap="wrap"
            >
                <Image src={logo} alt="PantryLink Logo" h={100} w={'auto'} />
            </Flex>
        </Box>
    );
}
export default Nav;