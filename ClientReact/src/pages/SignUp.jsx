import SignupBox from "../components/SignupBox";
import { useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { motion } from "framer-motion"

function SignUp() {
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
                <SignupBox />
            </motion.div>
        </div>
    );
}

export default SignUp;
