import Hero from '../components/Hero'
import MobileEx from '../components/MobileEx'
import { Center, Flex, Space } from '@mantine/core'
import Nav from '../components/Nav'
import {useMediaQuery} from '@mantine/hooks'
import Mobile from '../components/Mobile'
import { useRef } from 'react'

function Landing() {
    const MobileExRef = useRef(null);

    const scrollToMobileEx = () => {
        MobileExRef.current?.scrollIntoView({ behavior: 'smooth' });
    };
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
            <Hero onScrollClick={scrollToMobileEx}/>
            <Space h='2rem'/>
            <MobileEx ref={MobileExRef}/>
        </Flex>
        </>
    )
}

export default Landing