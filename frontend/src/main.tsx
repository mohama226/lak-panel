import React from "react";
import ReactDOM from "react-dom/client";
import { BrowserRouter } from "react-router-dom";

import { QueryClient } from "@tanstack/react-query";
import { QueryClientProvider } from "@tanstack/react-query";

import App from "./App";

import "./styles/globals.css";

const queryClient = new QueryClient({
    defaultOptions: {
        queries: {
            retry: 1,
            refetchOnWindowFocus: false,
            staleTime: 60000
        },
        mutations: {
            retry: 0
        }
    }
});

ReactDOM.createRoot(
    document.getElementById("root") as HTMLElement
).render(
    <React.StrictMode>

        <BrowserRouter>

            <QueryClientProvider client={queryClient}>

                <App />

            </QueryClientProvider>

        </BrowserRouter>

    </React.StrictMode>
);
