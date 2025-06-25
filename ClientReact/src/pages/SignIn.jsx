import SigninBox from "../components/SigninBox";
import { useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { motion } from "framer-motion"
import { Button } from "@mantine/core";
function SignIn() {
    const navigate = useNavigate();

    useEffect(() => {
        const token = localStorage.getItem('token');
        if (token) {
            navigate('/dashboard');
        }
    }, [navigate]);

    return (
        <div style={{ backgroundColor: '#917F7B', display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100vh', width: '100vw' }}>
            <motion.div
            initial={{y:-500}}
            animate={{y:0}}
            transition={{duration: 1, type: 'spring', stiffness: 200}}>
                <SigninBox />
            </motion.div>
        </div>
    );
}
export default SignIn;