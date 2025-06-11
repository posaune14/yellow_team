import { Container, Title, Text, Button, Center, Image, Flex } from '@mantine/core'
import { useNavigate } from 'react-router-dom'
import homePageBottom from '../assets/homePageBottom.png'
import homePageTop from '../assets/homePageTop.png'
import { useEffect } from 'react'
function Examples() {
    const navigate = useNavigate()

    return (
        <Center>
            <Flex
                mih={50}
                gap={"5rem"}
                justify="center"
                align="flex-start"
                direction="row"
                wrap="wrap"
                >
                    <Image h={400} w={'auto'} src={homePageTop}></Image>
                    <Image h={400} w={'auto'} src={homePageBottom}></Image>
                </Flex>
                
        </Center>
    )
}

export default Examples 