import Hero from '../components/Hero'
import Examples from '../components/Examples'
import { Center, Flex, Space } from '@mantine/core'
import Nav from '../components/Nav'
import {useMediaQuery} from '@mantine/hooks'
import Mobile from '../components/Mobile'
function Landing() {
    const isMobile = useMediaQuery('(max-width: 768px)');
    return isMobile ? (
    <Mobile />
  ) : (
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
            <Space h='2rem'/>
            <Examples />
        </Flex>
        </>
    )
}

export default Landing