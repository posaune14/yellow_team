import { useEffect } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import {
  Accordion, Anchor, Box, Button, Container, Group, Image, List,
  SimpleGrid, Stack, Text, Title,
} from '@mantine/core'
import {
  IconMapPin, IconSpeakerphone, IconPackage, IconHandStop, IconCalendarEvent,
  IconBell, IconChecks, IconArrowRight, IconBrandApple,
} from '@tabler/icons-react'
import { motion } from 'framer-motion'
import { TextAnimate } from '@gfazioli/mantine-text-animate'

import heroPhoto from '../assets/web/hero-volunteer.jpg'
import logo from '../assets/web/logo.png'
import appstore from '../assets/appstore.svg'
import inventoryShot from '../assets/web/inventory-dashboard.png'
import volunteerShot from '../assets/web/volunteer-dashboard.png'
import jfcsLogo from '../assets/web/jfcs.png'
import somersetLogo from '../assets/Somerset.png'
import shotPantries from '../assets/web/app/pantries-near-you.png'
import shotAnnouncements from '../assets/web/app/announcements.png'
import shotStock from '../assets/web/app/whats-in-stock.png'
import shotDetails from '../assets/web/app/pantry-details.png'
import shotVolunteer from '../assets/web/app/volunteer-scheduling.png'
import photoConaway from '../assets/web/cac/rep-conaway.jpg'
import photoGottheimer from '../assets/web/cac/rep-gottheimer.jpg'
import photoWatsonColeman from '../assets/web/cac/rep-watson-coleman.jpg'
import './Landing.css'

const APP_STORE_URL = 'https://apps.apple.com/us/app/pantrylink/id6754800608'
const BROWN = '#7a5136'

const appFeatures = [
  { icon: IconMapPin, title: 'Find local pantries', text: 'Discover nearby food pantries with integrated maps and get directions instantly.' },
  { icon: IconSpeakerphone, title: 'Real-time news stream', text: 'Stay updated with live alerts and announcements from all registered pantries.' },
  { icon: IconPackage, title: 'Browse inventory', text: 'See exactly what food items are available at each pantry before you visit.' },
  { icon: IconHandStop, title: 'Volunteer sign up', text: 'Register as a volunteer and start making a difference in your community.' },
  { icon: IconCalendarEvent, title: 'Volunteer scheduling', text: 'View available shifts at pantries and sign up for volunteer opportunities.' },
  { icon: IconBell, title: 'Push notifications', text: 'Get instant alerts when new food becomes available or shifts open up.' },
]

const appScreens = [
  { title: 'Pantries near you', shot: shotPantries },
  { title: 'Announcements', shot: shotAnnouncements },
  { title: "What's in stock", shot: shotStock },
  { title: 'Pantry details', shot: shotDetails },
  { title: 'Volunteer scheduling', shot: shotVolunteer },
]

const awardPhotos = [
  { src: photoConaway, caption: 'PantryLink team meeting with Rep. Herb Conaway', alt: 'PantryLink student team with Representative Herb Conaway at the Congressional App Challenge', pos: '50% 35%' },
  { src: photoGottheimer, caption: 'Presenting PantryLink to Rep. Josh Gottheimer', alt: 'PantryLink team presenting their project board to Representative Josh Gottheimer', pos: '50% 45%' },
  { src: photoWatsonColeman, caption: 'Receiving the Congressional App Challenge award from Rep. Bonnie Watson Coleman', alt: 'PantryLink team receiving Congressional App Challenge certificates from Representative Bonnie Watson Coleman', pos: '50% 40%' },
]

const faqs = [
  { q: 'Is PantryLink really free?', a: 'Yes. PantryLink is free for food banks, food pantries, volunteers, and the families they serve. It was built as a community project by students on the Yellow Team at theCoderSchool Montgomery.' },
  { q: 'What can my food bank do with PantryLink?', a: 'Track donations and food inventory, publish what is in stock, post announcements to your community, and schedule volunteers and track their hours, all from one web dashboard.' },
  { q: 'Is there a mobile app?', a: 'Yes. The free PantryLink iOS app lets families find nearby pantries, see what is available before they visit, and lets volunteers sign up for shifts.' },
  { q: 'Who is already using PantryLink?', a: 'Pantries in New Jersey including Jewish Family and Community Services of Mercer County and The Food Bank Network of Somerset County.' },
]

const Reveal = ({ children, delay = 0 }) => (
  <motion.div
    initial={{ y: 14 }}
    whileInView={{ y: 0 }}
    viewport={{ once: true, margin: '-60px' }}
    transition={{ duration: 0.5, delay, ease: 'easeOut' }}
  >
    {children}
  </motion.div>
)

function Landing() {
  const navigate = useNavigate()

  useEffect(() => {
    document.title = 'PantryLink | Free Food Bank & Food Pantry Management Software'
  }, [])

  return (
    <div className="pl-landing">
      <aside className="pl-ribbon" aria-label="Award">
        🏆 2025 Congressional App Challenge winner<span className="pl-desk"> for NJ-12, selected by{' '}
        <a href="https://watsoncoleman.house.gov/" target="_blank" rel="noopener noreferrer">
          Rep. Bonnie Watson Coleman
        </a></span>
      </aside>

      <header className="pl-nav">
        <Container size="lg" py="sm">
          <Group justify="space-between" wrap="nowrap">
            <Group gap={10} component={Link} to="/" style={{ textDecoration: 'none' }} aria-label="PantryLink home">
              <Image src={logo} alt="" w={36} h={36} radius="md" />
              <Text fw={700} fz="xl" ff="var(--pl-serif)" c="var(--pl-espresso)">PantryLink</Text>
            </Group>
            <Group gap="xl" className="pl-nav-links" visibleFrom="sm" component="nav" aria-label="Main">
              <a href="#features">Features</a>
              <a href="#app">iOS app</a>
              <a href="#partners">Partners</a>
              <a href="#faq">FAQ</a>
            </Group>
            <Group gap="xs" wrap="nowrap">
              <Button variant="subtle" color={BROWN} radius="xl" onClick={() => navigate('/signin')} visibleFrom="xs">
                Sign in
              </Button>
              <Button color={BROWN} radius="xl" onClick={() => navigate('/signup')}>
                Get started
              </Button>
            </Group>
          </Group>
        </Container>
      </header>

      <main>
        {/* Hero */}
        <Box component="section" aria-labelledby="hero-title" py={{ base: 28, md: 88 }}>
          <Container size="lg">
            <SimpleGrid cols={{ base: 1, md: 2 }} spacing={{ base: 48, md: 64 }} style={{ alignItems: 'center' }}>
              <Stack gap="md">
                <Text className="pl-eyebrow" visibleFrom="sm">Free food bank management software</Text>
                <Title id="hero-title" order={1} fz={{ base: 32, sm: 48, md: 56 }} lh={1.08}>
                  One platform. Every tool your food bank needs.
                </Title>
                <p className="pl-sr-only">
                  PantryLink is free food bank management software that helps food banks and pantries
                  track donations, manage inventory, schedule volunteers, and support their community,
                  with a free iOS app for the families and volunteers they serve.
                </p>
                <div className="pl-typewriter" aria-hidden="true">
                  <TextAnimate.Typewriter
                    value={['Track donations', 'Manage inventory', 'Schedule volunteers', 'Support your community']}
                    loop
                    pauseDelay={1200}
                    ff="var(--pl-serif)"
                    fz={{ base: 22, md: 28 }}
                    fw={500}
                    c="var(--pl-terracotta)"
                  />
                </div>
                <Group gap="sm" mt="xs" grow className="pl-hero-ctas">
                  <Button size="md" radius="xl" color={BROWN} rightSection={<IconArrowRight size={18} />} onClick={() => navigate('/signup')}>
                    Get started free
                  </Button>
                  <Button size="md" radius="xl" variant="outline" color={BROWN} leftSection={<IconBrandApple size={18} />}
                    component="a" href={APP_STORE_URL} target="_blank" rel="noopener noreferrer">
                    Get the iOS app
                  </Button>
                </Group>
              </Stack>

              <Reveal delay={0.1}>
                <div className="pl-hero-photo">
                  <Image
                    src={heroPhoto}
                    alt="Food pantry volunteer holding a basket of fresh tomatoes next to shelves of canned goods"
                    w="100%"
                    fetchPriority="high"
                  />
                  <div className="pl-note pl-desk-block">
                    <Text fz="xs" fw={800} c="var(--pl-terracotta)" tt="uppercase" style={{ letterSpacing: '0.08em' }}>Just posted</Text>
                    <Text fz="sm" fw={600} c="var(--pl-espresso)">Extra tomatoes today. Stop by before 5pm!</Text>
                  </div>
                </div>
              </Reveal>
            </SimpleGrid>
          </Container>
        </Box>

        {/* Why PantryLink */}
        <Box component="section" id="features" aria-labelledby="why-title" className="pl-section-sand" py={{ base: 36, md: 96 }}>
          <Container size="lg">
            <Reveal>
              <Title id="why-title" order={2} fz={{ base: 24, md: 40 }} maw={640}>
                Why food banks choose PantryLink
              </Title>
            </Reveal>
            <SimpleGrid cols={{ base: 2, md: 4 }} spacing={{ base: 'md', md: 'xl' }} mt={{ base: 20, md: 40 }}>
              {[
                { t: 'Mobile-first food bank app', d: 'Deliver real-time updates to your clients and volunteers instantly through our free, all-in-one iOS app for food pantries.' },
                { t: 'Real-time inventory', d: 'Track food inventory levels, volunteer hours, and client statistics in real time through an intuitive dashboard.' },
                { t: 'Built for your community', d: 'Made specifically for food banks, food pantries, and community organizations to better serve families in need.' },
                { t: 'Award-winning and free', d: 'Winner of the 2025 Congressional App Challenge for NJ-12. Free nonprofit software by the Yellow Team at theCoderSchool Montgomery.' },
              ].map((f, i) => (
                <Reveal key={f.t} delay={i * 0.06}>
                  <Stack gap={8}>
                    <Text ff="var(--pl-serif)" fz={{ base: 20, md: 28 }} c="var(--pl-tan)" fw={600}>0{i + 1}</Text>
                    <Title order={3} fz={{ base: 'sm', md: 'lg' }}>{f.t}</Title>
                    <Text fz="sm" c="var(--pl-muted)" lh={1.65} visibleFrom="sm">{f.d}</Text>
                  </Stack>
                </Reveal>
              ))}
            </SimpleGrid>
          </Container>
        </Box>

        {/* Inventory */}
        <Box component="section" aria-labelledby="inventory-title" py={{ base: 36, md: 104 }}>
          <Container size="lg">
            <SimpleGrid cols={{ base: 1, md: 2 }} spacing={{ base: 16, md: 64 }} style={{ alignItems: 'center' }}>
              <Stack gap="md">
                <Text className="pl-eyebrow" visibleFrom="sm">For pantry staff</Text>
                <Title id="inventory-title" order={2} fz={{ base: 24, md: 38 }}>
                  Food bank inventory management made easy
                </Title>
                <Text c="var(--pl-muted)" lh={1.7} visibleFrom="sm">
                  Track and publish your food inventory from one simple dashboard. Low stock is
                  flagged at a glance, and families can see what's on your shelves before they visit.
                </Text>
                <List visibleFrom="sm" spacing={8} c="var(--pl-text)" icon={<IconChecks size={18} color={BROWN} />}>
                  <List.Item>Log donations as they come in</List.Item>
                  <List.Item>See stock levels in real time</List.Item>
                  <List.Item>Share what's available with your community</List.Item>
                </List>
              </Stack>
              <Reveal>
                <div className="pl-screenshot">
                  <Image src={inventoryShot} loading="lazy" alt="PantryLink inventory dashboard showing food stock levels with low-stock items highlighted" />
                </div>
              </Reveal>
            </SimpleGrid>
          </Container>
        </Box>

        {/* Volunteers */}
        <Box component="section" aria-labelledby="volunteer-title" pb={{ base: 36, md: 104 }}>
          <Container size="lg">
            <SimpleGrid cols={{ base: 1, md: 2 }} spacing={{ base: 16, md: 64 }} style={{ alignItems: 'center' }}>
              <Reveal>
                <div className="pl-screenshot">
                  <Image src={volunteerShot} loading="lazy" alt="PantryLink volunteer scheduling dashboard showing shifts and volunteer hours" />
                </div>
              </Reveal>
              <Stack gap="md" style={{ order: -1 }} className="pl-volunteer-copy">
                <Text className="pl-eyebrow" visibleFrom="sm">For volunteer coordinators</Text>
                <Title id="volunteer-title" order={2} fz={{ base: 24, md: 38 }}>
                  Volunteer scheduling and management
                </Title>
                <Text c="var(--pl-muted)" lh={1.7} visibleFrom="sm">
                  Boost community involvement with an all-in-one volunteer management system. Post
                  shifts, let volunteers sign up from their phones, and keep track of every hour given.
                </Text>
              </Stack>
            </SimpleGrid>
          </Container>
        </Box>

        {/* iOS app */}
        <Box component="section" id="app" aria-labelledby="app-title" className="pl-section-dark" py={{ base: 36, md: 104 }}>
          <Container size="lg">
            <SimpleGrid cols={{ base: 1, md: 2 }} spacing={{ base: 16, md: 64 }}>
              <Stack gap="md">
                <Text className="pl-eyebrow" c="#f0a877">Free on iOS</Text>
                <Title id="app-title" order={2} fz={{ base: 24, md: 40 }}>
                  The PantryLink app, for families and volunteers
                </Title>
                <Text c="#d6c3ae" lh={1.7} visibleFrom="sm">
                  Everything your community needs in their pocket: find a pantry, see what's in stock,
                  and sign up to help.
                </Text>
                <a href={APP_STORE_URL} target="_blank" rel="noopener noreferrer" aria-label="Download PantryLink on the App Store" style={{ alignSelf: 'flex-start', marginTop: 8 }}>
                  <img src={appstore} alt="Download on the App Store" style={{ width: 160, height: 50, objectFit: 'cover', display: 'block' }} />
                </a>
              </Stack>
              <SimpleGrid cols={{ base: 1, xs: 2 }} spacing="lg" verticalSpacing="lg" visibleFrom="md">
                {appFeatures.map(({ icon: Icon, title, text }) => (
                  <Group key={title} align="flex-start" wrap="nowrap" gap="sm">
                    <Box mt={2} c="#f0a877"><Icon size={22} stroke={1.6} /></Box>
                    <div>
                      <Title order={3} fz="md" ff="var(--pl-sans)" fw={700}>{title}</Title>
                      <Text fz="sm" c="#cdb8a2" lh={1.6}>{text}</Text>
                    </div>
                  </Group>
                ))}
              </SimpleGrid>
            </SimpleGrid>

            <div className="pl-phones">
              {appScreens.map(({ title, shot }) => (
                <figure key={title}>
                  <img src={shot} alt={`PantryLink iOS app: ${title.toLowerCase()} screen`} loading="lazy" style={{ width: '100%', height: 'auto' }} />
                  <figcaption>{title}</figcaption>
                </figure>
              ))}
            </div>
          </Container>
        </Box>

        {/* Partners */}
        <Box component="section" id="partners" aria-labelledby="partners-title" py={{ base: 36, md: 96 }}>
          <Container size="lg">
            <Reveal>
              <Title id="partners-title" order={2} fz={{ base: 24, md: 38 }} ta="center">
                Food banks and pantries using PantryLink
              </Title>
            </Reveal>
            <SimpleGrid cols={{ base: 2, sm: 3 }} spacing={{ base: 'sm', md: 'lg' }} mt={{ base: 20, md: 40 }}>
              <a className="pl-partner" href="https://www.jfcsonline.org/" target="_blank" rel="noopener noreferrer">
                <Image src={jfcsLogo} alt="Jewish Family and Community Services of Mercer County logo" h={64} w="auto" fit="contain" loading="lazy" />
                <Text fz="sm" c="var(--pl-muted)">Jewish Family and Community Services, Mercer County</Text>
              </a>
              <a className="pl-partner" href="https://www.somersetfoodbank.org/" target="_blank" rel="noopener noreferrer">
                <Image src={somersetLogo} alt="The Food Bank Network of Somerset County logo" h={64} w="auto" fit="contain" loading="lazy" />
                <Text fz="sm" c="var(--pl-muted)">The Food Bank Network of Somerset County</Text>
              </a>
              <Link className="pl-partner pl-partner-invite pl-span-mobile" to="/signup">
                <Text ff="var(--pl-serif)" fz="xl" fw={600} c="var(--pl-espresso)">Your pantry here</Text>
                <Text fz="sm" c="var(--pl-muted)">Get your food bank on PantryLink today →</Text>
              </Link>
            </SimpleGrid>
          </Container>
        </Box>

        {/* FAQ */}
        <Box component="section" id="faq" aria-labelledby="faq-title" className="pl-section-sand" py={{ base: 36, md: 96 }}>
          <Container size="sm">
            <Title id="faq-title" order={2} fz={{ base: 24, md: 38 }} ta="center" mb={{ base: 16, md: 32 }}>
              Questions, answered
            </Title>
            <Accordion variant="separated" radius="md"
              styles={{
                item: { background: '#fffaf3', borderColor: 'var(--pl-oat)' },
                label: { fontWeight: 700, color: 'var(--pl-espresso)' },
                content: { color: 'var(--pl-muted)', lineHeight: 1.7 },
              }}>
              {faqs.map((f) => (
                <Accordion.Item key={f.q} value={f.q}>
                  <Accordion.Control><h3 style={{ all: 'inherit' }}>{f.q}</h3></Accordion.Control>
                  <Accordion.Panel>{f.a}</Accordion.Panel>
                </Accordion.Item>
              ))}
            </Accordion>
          </Container>
        </Box>

        {/* Congressional App Challenge (desktop only) */}
        <Box component="section" id="award" aria-labelledby="award-title" py={96} visibleFrom="sm">
          <Container size="lg">
            <Stack gap={8} maw={640}>
              <Text className="pl-eyebrow">2025 Congressional App Challenge</Text>
              <Title id="award-title" order={2} fz={38}>From a student project to Capitol Hill</Title>
              <Text c="var(--pl-muted)" lh={1.7}>
                PantryLink was selected by Rep. Bonnie Watson Coleman as the Congressional App Challenge
                winner for New Jersey's 12th District.
              </Text>
            </Stack>
            <SimpleGrid cols={3} spacing="lg" mt={40}>
              {awardPhotos.map((p) => (
                <Reveal key={p.caption}>
                  <figure className="pl-award-photo">
                    <img src={p.src} alt={p.alt} loading="lazy" style={{ objectPosition: p.pos }} />
                    <figcaption>{p.caption}</figcaption>
                  </figure>
                </Reveal>
              ))}
            </SimpleGrid>
          </Container>
        </Box>

        {/* CTA */}
        <Box component="section" aria-labelledby="cta-title" py={{ base: 40, md: 112 }}>
          <Container size="sm" ta="center">
            <Title id="cta-title" order={2} fz={{ base: 24, md: 44 }}>
              Ready to make your food bank run smoother?
            </Title>
            <Box h={20} hiddenFrom="sm" />
            <Text c="var(--pl-muted)" mt="md" mb="xl" fz="lg" lh={1.6} visibleFrom="sm">
              Free inventory management, volunteer scheduling, and client communication tools for your food pantry.
            </Text>
            <Group justify="center" gap="sm">
              <Button size="lg" radius="xl" color={BROWN} onClick={() => navigate('/signup')}>
                Get started free
              </Button>
              <Button size="lg" radius="xl" variant="subtle" color={BROWN} onClick={() => navigate('/signin')}>
                Sign in
              </Button>
            </Group>
          </Container>
        </Box>
      </main>

      <footer className="pl-footer">
        <Container size="lg" py={40}>
          <Group justify="space-between" align="flex-start" gap="lg">
            <Stack gap={6}>
              <Text ff="var(--pl-serif)" fz="lg" fw={600} c="#fbf1e4">PantryLink</Text>
              <Text fz="sm">Made with care by the Yellow Team. <Anchor component={Link} to="/credits" c="#f1e4d3" fz="sm">Meet the team</Anchor></Text>
            </Stack>
            <Group gap="lg" fz="sm">
              <Anchor component={Link} to="/privacy" c="#f1e4d3" fz="sm">Privacy Policy</Anchor>
              <Anchor href="https://congressionalappchallenge.us/" target="_blank" rel="noopener noreferrer" c="#f1e4d3" fz="sm">Congressional App Challenge</Anchor>
            </Group>
          </Group>
          <Text fz="xs" mt="xl" c="#a8927d">
            © {new Date().getFullYear()}{' '}
            <Anchor href="https://thecoderschool.com/montgomery" target="_blank" rel="noopener noreferrer" c="#cdb8a2" fz="xs">theCoderSchool Montgomery</Anchor>. All rights reserved.
          </Text>
        </Container>
      </footer>
    </div>
  )
}

export default Landing
