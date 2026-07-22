import "./Logo.css";

interface LogoProps {

    size?: number;

    showText?: boolean;

}

export default function Logo({

    size = 64,

    showText = true

}: LogoProps) {

    return (

        <div className="lp-logo">

            <div
                className="lp-logo-icon"
                style={{
                    width: size,
                    height: size
                }}
            >

                <span>L</span>

            </div>

            {

                showText && (

                    <div className="lp-logo-text">

                        <h1>L-PANEL</h1>

                        <p>Enterprise VPN Management</p>

                    </div>

                )

            }

        </div>

    );

}
