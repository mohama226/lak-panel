document.addEventListener("DOMContentLoaded", () => {

    const form = document.getElementById("dashboard-settings-form");

    if (!form)
        return;

    form.addEventListener("submit", async (e) => {

        e.preventDefault();

        const data = {

            dashboard_auto_refresh:
                document.getElementById("dashboard_auto_refresh").checked,

            dashboard_refresh_interval:
                parseInt(
                    document.getElementById("dashboard_refresh_interval").value
                ),

        };

        try {

            const response = await fetch(

                "/settings/dashboard",

                {

                    method: "POST",

                    headers: {

                        "Content-Type": "application/json"

                    },

                    body: JSON.stringify(data)

                }

            );

            if (response.ok) {

                alert("Settings saved successfully.");

            } else {

                alert("Unable to save settings.");

            }

        } catch {

            alert("Connection error.");

        }

    });

});
