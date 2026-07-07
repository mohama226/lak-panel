// ---------- Dropdown ----------

document.addEventListener("click", function (e) {

    const btn = e.target.closest(".menu-btn");

    if (btn) {

        e.stopPropagation();

        const menu = btn.closest(".actions-menu").querySelector(".dropdown");

        document.querySelectorAll(".dropdown").forEach(d => {
            if (d !== menu)
                d.classList.remove("show");
        });

        menu.classList.toggle("show");

        return;
    }

    document.querySelectorAll(".dropdown").forEach(d => d.classList.remove("show"));

});

// ---------- helper ----------

async function post(url) {

    const r = await fetch(url, {
        method: "POST"
    });

    const j = await r.json();

    alert(j.detail);

    location.reload();

}

// ---------- Delete ----------

document.querySelectorAll(".delete-user").forEach(btn => {

    btn.onclick = async () => {

        if (!confirm("Delete user?"))
            return;

        const r = await fetch("/users/" + btn.dataset.user, {
            method: "DELETE"
        });

        const j = await r.json();

        alert(j.detail);

        location.reload();

    };

});

// ---------- Enable ----------

document.querySelectorAll(".enable-user").forEach(btn => {

    btn.onclick = () => post("/users/" + btn.dataset.user + "/enable");

});

// ---------- Disable ----------

document.querySelectorAll(".disable-user").forEach(btn => {

    btn.onclick = () => post("/users/" + btn.dataset.user + "/disable");

});

// ---------- Block ----------

document.querySelectorAll(".block-user").forEach(btn => {

    btn.onclick = () => post("/users/" + btn.dataset.user + "/block");

});

// ---------- Unblock ----------

document.querySelectorAll(".unblock-user").forEach(btn => {

    btn.onclick = () => post("/users/" + btn.dataset.user + "/unblock");

});

// ---------- Reset Traffic ----------

document.querySelectorAll(".reset-traffic").forEach(btn => {

    btn.onclick = () => post("/users/" + btn.dataset.user + "/traffic/reset");

});


// ---------- Change Password ----------

document.querySelectorAll(".change-password").forEach(btn => {

    btn.onclick = async () => {

        let password = prompt("New Password");

        if (!password)
            return;

        const r = await fetch("/users/" + btn.dataset.user + "/password", {

            method: "POST",

            headers: {
                "Content-Type": "application/json"
            },

            body: JSON.stringify({
                password: password
            })

        });

        const j = await r.json();

        alert(j.detail);

    };

});
