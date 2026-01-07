import { useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import { Button, Text, Container, Paper, Group, Title, Stack, List, Anchor } from "@mantine/core";
import { useMediaQuery } from "@mantine/hooks";
import { IconArrowLeft } from "@tabler/icons-react";

function Privacy() {
    const navigate = useNavigate();
    const isMobile = useMediaQuery('(max-width: 768px)');

    return (
        <div style={{ 
            minHeight: '100vh', 
            backgroundColor: '#f5f5f5',
            padding: isMobile ? '20px 10px' : '40px 20px'
        }}>
            <Container size="md" py="xl">
                <motion.div
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ duration: 0.5 }}
                >
                    <Paper
                        p={isMobile ? "md" : "xl"}
                        radius="lg"
                        shadow="md"
                        style={{
                            backgroundColor: 'white',
                            maxWidth: '900px',
                            margin: '0 auto'
                        }}
                    >
                        <Stack gap="lg">
                            {/* Header with back button */}
                            <Group>
                                <Button
                                    variant="subtle"
                                    leftSection={<IconArrowLeft size={18} />}
                                    onClick={() => navigate(-1)}
                                    style={{ paddingLeft: 0 }}
                                >
                                    Back
                                </Button>
                            </Group>

                            {/* Title */}
                            <Title order={1} size={isMobile ? "h2" : "h1"} fw={700} c="dark">
                                Privacy Policy
                            </Title>

                            <Text c="dimmed" size="sm">
                                <b>Last updated:</b> 12/28/2025
                            </Text>

                            <Text size="md" style={{ lineHeight: 1.6 }}>
                                <b>PantryLink values your privacy.</b> This Privacy Policy explains what information we collect and how we use it.
                            </Text>

                            {/* Information We Collect */}
                            <div>
                                <Title order={2} size="h3" fw={600} mb="sm" c="dark">
                                    Information We Collect
                                </Title>
                                <Text size="md" mb="xs" style={{ lineHeight: 1.6 }}>
                                    PantryLink only collects information that users voluntarily provide. This may include:
                                </Text>
                                <List spacing="xs" mb="md" size="md" withPadding>
                                    <List.Item>
                                        <Text span>
                                            Information entered on the <b>sign-up page</b> (if you choose to create an account)
                                        </Text>
                                    </List.Item>
                                    <List.Item>
                                        <Text span>
                                            Information entered on <b>volunteer forms</b>
                                        </Text>
                                    </List.Item>
                                </List>
                                <Text size="md" style={{ lineHeight: 1.6 }}>
                                    Creating an account is <b>optional</b>. You may use PantryLink as a guest without signing up.
                                </Text>
                            </div>

                            {/* How We Use Information */}
                            <div>
                                <Title order={2} size="h3" fw={600} mb="sm" c="dark">
                                    How We Use Information
                                </Title>
                                <Text size="md" mb="xs" style={{ lineHeight: 1.6 }}>
                                    We use the information you provide solely to:
                                </Text>
                                <List spacing="xs" mb="md" size="md" withPadding>
                                    <List.Item>
                                        <Text span>Operate and improve the PantryLink app</Text>
                                    </List.Item>
                                    <List.Item>
                                        <Text span>Connect volunteers with pantries when applicable</Text>
                                    </List.Item>
                                </List>
                                <Text size="md" fw={600} style={{ lineHeight: 1.6, color: '#d32f2f' }}>
                                    We do not sell, rent, or share your personal information with third parties.
                                </Text>
                            </div>

                            {/* Data Storage and Security */}
                            <div>
                                <Title order={2} size="h3" fw={600} mb="sm" c="dark">
                                    Data Storage and Security
                                </Title>
                                <Text size="md" style={{ lineHeight: 1.6 }}>
                                    All information is stored in a secure database. We take reasonable measures to protect your data from unauthorized access.
                                </Text>
                            </div>

                            {/* Guest Usage */}
                            <div>
                                <Title order={2} size="h3" fw={600} mb="sm" c="dark">
                                    Guest Usage
                                </Title>
                                <Text size="md" style={{ lineHeight: 1.6 }}>
                                    If you use PantryLink as a guest, we do not collect personal information beyond what is necessary for basic app functionality.
                                </Text>
                            </div>

                            {/* Changes to This Policy */}
                            <div>
                                <Title order={2} size="h3" fw={600} mb="sm" c="dark">
                                    Changes to This Policy
                                </Title>
                                <Text size="md" style={{ lineHeight: 1.6 }}>
                                    We may update this Privacy Policy from time to time. Any changes will be reflected in the app.
                                </Text>
                            </div>

                            {/* Contact */}
                            <div>
                                <Title order={2} size="h3" fw={600} mb="sm" c="dark">
                                    Contact
                                </Title>
                                <Text size="md" style={{ lineHeight: 1.6 }}>
                                    If you have questions about this Privacy Policy, please contact us at:
                                    <br />
                                    <Anchor 
                                        href="mailto:montgomery@thecoderschool.com" 
                                        fw={600}
                                        style={{ color: '#228be6' }}
                                    >
                                        montgomery@thecoderschool.com
                                    </Anchor>
                                </Text>
                            </div>
                        </Stack>
                    </Paper>
                </motion.div>
            </Container>
        </div>
    );
}

export default Privacy;