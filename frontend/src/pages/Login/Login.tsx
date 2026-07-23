import { useState } from "react";

import { useNavigate } from "react-router-dom";

import { login } from "../../services/auth";

import "./Login.css";


function Login(){


    const navigate = useNavigate();


    const [username,setUsername] = useState("");

    const [password,setPassword] = useState("");

    const [loading,setLoading] = useState(false);

    const [error,setError] = useState("");



    async function handleLogin(
        e:React.FormEvent
    ){

        e.preventDefault();


        setError("");

        setLoading(true);



        const result = await login(

            username,

            password

        );



        setLoading(false);



        if(result.success){


            navigate("/dashboard");


        }else{


            setError(

                result.message ||

                "Invalid username or password"

            );


        }

    }



    return (

        <div className="login-page">


            <div className="login-box">


                <div className="login-header">


                    <div className="logo">

                        L

                    </div>


                    <h1>

                        L-PANEL

                    </h1>


                    <p>

                        Enterprise VPN Management

                    </p>


                </div>




                <form onSubmit={handleLogin}>


                    <div className="field">


                        <label>

                            Username

                        </label>


                        <input

                            value={username}

                            onChange={

                                e=>

                                setUsername(
                                    e.target.value
                                )

                            }

                            placeholder="admin"

                            autoComplete="username"

                        />


                    </div>




                    <div className="field">


                        <label>

                            Password

                        </label>


                        <input

                            type="password"

                            value={password}

                            onChange={

                                e=>

                                setPassword(
                                    e.target.value
                                )

                            }

                            placeholder="••••••••"

                            autoComplete="current-password"

                        />


                    </div>




                    {

                        error &&

                        <div className="login-error">

                            {error}

                        </div>

                    }




                    <button

                        disabled={loading}

                    >

                        {

                            loading

                            ?

                            "Signing in..."

                            :

                            "Login"

                        }


                    </button>


                </form>


            </div>


        </div>

    );


}


export default Login;
