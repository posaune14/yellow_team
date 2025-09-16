import { 
    Center, 
    Container, 
    Title, 
    Text, 
    Card, 
    Group, 
    Stack, 
    Badge, 
    ThemeIcon,
    Divider,
    Box,
    Grid,
    Avatar,
    Paper,
    Button
} from '@mantine/core'
import { motion } from 'framer-motion'
import { 
    IconCode, 
    IconDatabase, 
    IconServer, 
    IconBrandGithub, 
    IconBrandPython,
    IconBrandReact,
    IconBrandSwift,
    IconBrandMongodb,
    IconFlask,
    IconTrophy,
    IconHeart,
    IconUsers,
    IconArrowLeft
} from '@tabler/icons-react'

const MotionCard = motion(Card)
const MotionContainer = motion(Container)
const MotionTitle = motion(Title)
const MotionText = motion(Text)
const MotionGroup = motion(Group)
const MotionStack = motion(Stack)
const MotionBox = motion(Box)
const MotionPaper = motion(Paper)
const MotionButton = motion(Button)

const teamMembers = [
    {
        name: "Joshua Sambol",
        role: "Mostly Frontend",
        contributions: "App and Website",
        icon: IconCode,
        color: "blue"
    },
    {
        name: "Nipur Bhavsar", 
        role: "Full Stack",
        contributions: "App and DB",
        icon: IconDatabase,
        color: "green"
    },
    {
        name: "Michael Youtz",
        role: "Mostly Backend", 
        contributions: "App and Server",
        icon: IconServer,
        color: "orange"
    },
    {
        name: "Naisha Singh",
        role: "Full Stack",
        contributions: "App and DB", 
        icon: IconDatabase,
        color: "purple"
    }
]

const techStack = [
    { name: "Mantine", icon: IconBrandReact, color: "blue" },
    { name: "React", icon: IconBrandReact, color: "cyan" },
    { name: "SwiftUI", icon: IconBrandSwift, color: "orange" },
    { name: "GitHub", icon: IconBrandGithub, color: "dark" },
    { name: "MongoDB Atlas", icon: IconBrandMongodb, color: "green" },
    { name: "Flask", icon: IconFlask, color: "red" },
    { name: "Python", icon: IconBrandPython, color: "yellow" }
]

const containerVariants = {
    hidden: { opacity: 0 },
    visible: {
        opacity: 1,
        transition: {
            duration: 0.6,
            staggerChildren: 0.2
        }
    }
}

const itemVariants = {
    hidden: { y: 20, opacity: 0 },
    visible: {
        y: 0,
        opacity: 1,
        transition: {
            duration: 0.6,
            ease: "easeOut"
        }
    }
}

const cardVariants = {
    hidden: { scale: 0.8, opacity: 0 },
    visible: {
        scale: 1,
        opacity: 1,
        transition: {
            duration: 0.5,
            ease: "easeOut"
        }
    },
    hover: {
        scale: 1.05,
        transition: {
            duration: 0.2,
            ease: "easeInOut"
        }
    }
}

export default function Credits() {
    const handleGoHome = () => {
        window.location.href = '/';
    };

    return (
        <MotionContainer
            size="lg"
            py="xl"
            variants={containerVariants}
            initial="hidden"
            animate="visible"
        >
            <Stack spacing="xl">
                {/* Back to Home Button */}
                <MotionBox variants={itemVariants}>
                    <Center>
                        <MotionButton
                            leftSection={<IconArrowLeft size={16} />}
                            variant="light"
                            color="blue"
                            size="md"
                            onClick={handleGoHome}
                            whileHover={{ scale: 1.05 }}
                            whileTap={{ scale: 0.95 }}
                        >
                            Back to Home
                        </MotionButton>
                    </Center>
                </MotionBox>
                {/* Header */}
                <MotionBox variants={itemVariants}>
                    <Center>
                        <Stack align="center" spacing="md">
                            <MotionTitle 
                                order={1} 
                                size="3rem"
                                gradient={{ from: 'yellow', to: 'orange', deg: 45 }}
                                variant="gradient"
                                variants={itemVariants}
                            >
                                Yellow Team
                            </MotionTitle>
                            <MotionText 
                                size="lg" 
                                color="dimmed" 
                                align="center"
                                variants={itemVariants}
                            >
                                Congressional App Challenge 2025 Submission
                            </MotionText>
                        </Stack>
                    </Center>
                </MotionBox>

                {/* Team Members */}
                <MotionBox variants={itemVariants}>
                    <MotionTitle order={2} align="center" mb="xl" variants={itemVariants}>
                        <Group justify="center" spacing="sm">
                            <ThemeIcon size="lg" color="blue" variant="light">
                                <IconUsers size={24} />
                            </ThemeIcon>
                            Meet the Team
                        </Group>
                    </MotionTitle>
                    
                    <Grid gutter="lg">
                        {teamMembers.map((member, index) => (
                            <Grid.Col key={member.name} span={{ base: 12, sm: 6, md: 3 }}>
                                <MotionCard
                                    shadow="md"
                                    padding="lg"
                                    radius="md"
                                    withBorder
                                    variants={cardVariants}
                                    whileHover="hover"
                                    style={{ height: '100%' }}
                                >
                                    <Stack align="center" spacing="md">
                                        <Avatar
                                            size="xl"
                                            radius="xl"
                                            color={member.color}
                                            variant="light"
                                        >
                                            <member.icon size={32} />
                                        </Avatar>
                                        <Stack align="center" spacing="xs">
                                            <Text weight={600} size="lg" align="center">
                                                {member.name}
                                            </Text>
                                            <Badge color={member.color} variant="light">
                                                {member.role}
                                            </Badge>
                                            <Text size="sm" color="dimmed" align="center">
                                                {member.contributions}
                                            </Text>
                                        </Stack>
                                    </Stack>
                                </MotionCard>
                            </Grid.Col>
                        ))}
                    </Grid>
                </MotionBox>

                <Divider />

                {/* Tech Stack */}
                <MotionBox variants={itemVariants}>
                    <MotionTitle order={2} align="center" mb="xl" variants={itemVariants}>
                        <Group justify="center" spacing="sm">
                            <ThemeIcon size="lg" color="green" variant="light">
                                <IconCode size={24} />
                            </ThemeIcon>
                            Tech Stack
                        </Group>
                    </MotionTitle>
                    
                    <MotionGroup 
                        position="center" 
                        spacing="md"
                        variants={itemVariants}
                    >
                        {techStack.map((tech, index) => (
                            <MotionBox
                                key={tech.name}
                                variants={itemVariants}
                                whileHover={{ scale: 1.1 }}
                                whileTap={{ scale: 0.95 }}
                            >
                                <Paper
                                    p="md"
                                    radius="md"
                                    withBorder
                                    style={{ 
                                        minWidth: '120px',
                                        textAlign: 'center'
                                    }}
                                >
                                    <Stack align="center" spacing="xs">
                                        <ThemeIcon 
                                            size="lg" 
                                            color={tech.color} 
                                            variant="light"
                                        >
                                            <tech.icon size={24} />
                                        </ThemeIcon>
                                        <Text size="sm" weight={500}>
                                            {tech.name}
                                        </Text>
                                    </Stack>
                                </Paper>
                            </MotionBox>
                        ))}
                    </MotionGroup>
                </MotionBox>

                <Divider />

                {/* Acknowledgments */}
                <MotionBox variants={itemVariants}>
                    <MotionTitle order={2} align="center" mb="xl" variants={itemVariants}>
                        <Group justify="center" spacing="sm">
                            <ThemeIcon size="lg" color="red" variant="light">
                                <IconHeart size={24} />
                            </ThemeIcon>
                            Special Thanks
                        </Group>
                    </MotionTitle>
                    
                    <MotionCard
                        shadow="md"
                        padding="xl"
                        radius="md"
                        withBorder
                        variants={itemVariants}
                        style={{ maxWidth: '600px', margin: '0 auto' }}
                    >
                        <Stack align="center" spacing="lg">
                            <ThemeIcon size="xl" color="red" variant="light">
                                <IconHeart size={32} />
                            </ThemeIcon>
                            <Text size="lg" weight={600} align="center">
                                Sina Hernandez
                            </Text>
                            <Text size="md" color="dimmed" align="center">
                                Our amazing teacher who played a big role in the development of this project
                            </Text>
                        </Stack>
                    </MotionCard>
                </MotionBox>

                {/* Congressional App Challenge */}
                <MotionBox variants={itemVariants}>
                    <MotionCard
                        shadow="lg"
                        padding="xl"
                        radius="md"
                        withBorder
                        variants={itemVariants}
                        style={{ 
                            background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
                            color: 'white',
                            maxWidth: '600px',
                            margin: '0 auto'
                        }}
                    >
                        <Stack align="center" spacing="lg">
                            <ThemeIcon size="xl" color="white" variant="filled">
                                <IconTrophy size={32} />
                            </ThemeIcon>
                            <Text size="lg" weight={600} align="center" color="white">
                                Congressional App Challenge 2025
                            </Text>
                            <Text size="md" align="center" color="white" opacity={0.9}>
                                This project is proudly submitted to the Congressional App Challenge 2025
                            </Text>
                        </Stack>
                    </MotionCard>
                </MotionBox>
            </Stack>
        </MotionContainer>
    )
}