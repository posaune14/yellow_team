import { Container, Title, Text, Button, Center, Image, Flex } from '@mantine/core'
import { useNavigate } from 'react-router-dom'
import homePageBottom from '../assets/homePageBottom.png'
import homePageTop from '../assets/homePageTop.png'
import { useEffect, useRef, forwardRef, useState } from 'react'


 
const MobileEx = forwardRef((props, ref) => {
    const navigate = useNavigate()

    return (
        <>
        <Text size="2em"
                fw={900}
                variant="gradient"
                gradient={{ from: 'gray', to: 'rgba(0, 0, 0, 1)', deg: 0 }}>Seamlessly connect to clients
            </Text>
        <Text size="3em"
            fw={900}
            variant="gradient"
            gradient={{ from: 'rgba(201, 185, 177, 1)', to: 'rgba(122, 109, 106, 1)', deg: 90 }} order={2}>
            Through our state-of-the-art mobile app
        </Text>
        <Center ref={ref} {...props}>
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
        </>
    )
})


export default MobileEx;