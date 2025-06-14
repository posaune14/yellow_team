import SigninBox from "../components/SigninBox";
import { useEffect } from "react";
import { useNavigate } from "react-router-dom";

function SignIn() {
    const navigate = useNavigate();

    useEffect(() => {
        const token = localStorage.getItem('token');
        if (token) {
            navigate('/dashboard');
        }
    }, [navigate]);

    return (
        <div style={{ backgroundColor: '#917F7B', display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100vh', backgroundColor: '#f0f0f0' }}>
            <SigninBox />
        </div>
    );
}
export default SignIn;