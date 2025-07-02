import {forwardRef, useRef} from 'react'
import { Container, Title, Text, Button, Center, Image, Flex } from '@mantine/core'
import { useNavigate } from 'react-router-dom'

const InventoryEx = forwardRef((props, ref) => {
    const navigate = useNavigate()
    return (
        <Center ref={ref} {...props}>
            <Flex
                mih={50}
                gap={"5rem"}
                justify="center"
                align="flex-start"
                direction="row"
                wrap="wrap"
                >
                    <Image h={400} w={'auto'} alt='inventoryEx' src={} />
                </Flex>

        </Center>
    )
})
export default InventoryEx;