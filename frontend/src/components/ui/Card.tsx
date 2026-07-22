import { HTMLAttributes } from "react";

import clsx from "clsx";

interface CardProps extends HTMLAttributes<HTMLDivElement> {

    title?: string;

    subtitle?: string;

}

export default function Card({

    title,

    subtitle,

    className,

    children,

    ...props

}: CardProps) {

    return (

        <div

            className={clsx(

                "lp-card",

                className

            )}

            {...props}

        >

            {(title || subtitle) && (

                <div className="lp-card-header">

                    {title && (

                        <h3 className="lp-card-title">

                            {title}

                        </h3>

                    )}

                    {subtitle && (

                        <p className="lp-card-subtitle">

                            {subtitle}

                        </p>

                    )}

                </div>

            )}

            <div className="lp-card-body">

                {children}

            </div>

        </div>

    );

}
