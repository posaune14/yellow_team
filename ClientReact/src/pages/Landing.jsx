import Hero from '../components/Hero'
import Examples from '../components/Examples'
import { Center, Flex } from '@mantine/core'
import Nav from '../components/Nav'
function Landing() {
    return (
        <>
        <Flex   
            mih={50}
            gap="xl"
            justify="center"
            align="center"
            direction="column"
            wrap="wrap">
            {/* <Nav /> */}
            <Hero />
            <Examples />
        </Flex>
        </>
    )
}

export default Landing