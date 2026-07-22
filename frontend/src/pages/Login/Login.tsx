import { useState } from "react";
import { Eye, EyeOff, ShieldCheck } from "lucide-react";

import AuthLayout from "@layouts/AuthLayout";

import "./Login.css";

export default function Login() {

    const [showPassword, setShowPassword] = useState(false);

    return (

        <AuthLayout>

            <div className="login-card">

                <div className="login-header">

                    <ShieldCheck
                        size={42}
                        className="login-icon"
                    />

                    <h2>L-PANEL</h2>

                    <p>
                        Enterprise VPN Management
                    </p>

                </div>

                <form>

                    <div className="form-group">

                        <label>

                            Username

                        </label>

                        <input
                            type="text"
                            placeholder="Enter username"
                        />

                    </div>

                    <div className="form-group">

                        <label>

                            Password

                        </label>

                        <div className="password-box">

                            <input
                                type={
                                    showPassword
                                        ? "text"
                                        : "password"
                                }
                                placeholder="Enter password"
                            />

                            <button
                                type="button"
                                className="eye-button"
                                onClick={() =>
                                    setShowPassword(!showPassword)
                                }
                            >

                                {

                                    showPassword
                                        ? <EyeOff size={18}/>
                                        : <Eye size={18}/>

                                }

                            </button>

                        </div>

                    </div>

                    <div className="remember-row">

                        <label>

                            <input type="checkbox"/>

                            <span>

                                Remember Me

                            </span>

                        </label>

                    </div>

                    <button
                        className="login-button"
                        type="submit"
                    >

                        Sign In

                    </button>

                </form>

                <div className="server-status">

                    <span className="dot"/>

                    Server Online

                </div>

                <div className="login-footer">

                    Version 1.0.0

                </div>

            </div>

        </AuthLayout>

    );

}
