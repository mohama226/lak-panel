import { useState } from "react";

import Card from "@components/ui/Card";
import Input from "@components/ui/Input";
import Button from "@components/ui/Button";

import Logo from "@components/layout/Logo";

import "./Login.css";

export default function Login() {

    const [username, setUsername] = useState("");

    const [password, setPassword] = useState("");

    const [loading, setLoading] = useState(false);

    async function login(e: React.FormEvent) {

        e.preventDefault();

        setLoading(true);

        // TODO:
        // Backend Login API

        setTimeout(() => {

            setLoading(false);

        },1000);

    }

    return (

        <div className="login-page">

            <div className="login-background"/>

            <Card
                className="login-container"
            >

                <div className="login-logo">

                    <Logo/>

                </div>

                <div className="login-title">

                    <h2>

                        Welcome Back

                    </h2>

                    <p>

                        Login to your L-PANEL account

                    </p>

                </div>

                <form
                    onSubmit={login}
                >

                    <Input

                        label="Username"

                        placeholder="Enter username"

                        value={username}

                        onChange={(e)=>setUsername(e.target.value)}

                    />

                    <Input

                        type="password"

                        label="Password"

                        placeholder="Enter password"

                        value={password}

                        onChange={(e)=>setPassword(e.target.value)}

                    />

                    <Button

                        type="submit"

                        loading={loading}

                    >

                        Sign In

                    </Button>

                </form>

                <div className="login-footer">

                    L-PANEL Enterprise Edition

                </div>

            </Card>

        </div>

    );

}
