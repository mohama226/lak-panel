let actionMenu = null;

document.addEventListener("DOMContentLoaded", () => {

    actionMenu = document.getElementById("action-menu");

    document.addEventListener("click", (e) => {

        if (
            actionMenu &&
            !actionMenu.contains(e.target) &&
            !e.target.closest(".action-menu-button")
        ) {
            actionMenu.classList.remove("open");
        }

    });

});

function openUserMenu(button, username) {

    if (!actionMenu)
        return;

    document.getElementById("am-profile").href =
        "/users/" + username;

    document.getElementById("am-edit").href =
        "/users/" + username + "/edit";

    document.getElementById("am-password").href =
        "/users/" + username + "/password";

    document.getElementById("am-enable").href =
        "/users/" + username + "/enable";

    document.getElementById("am-block").href =
        "/users/" + username + "/block";

    document.getElementById("am-disconnect").href =
        "/users/" + username + "/disconnect";

    document.getElementById("am-logs").href =
        "/users/" + username + "/logs";

    document.getElementById("am-traffic").href =
        "/users/" + username + "/traffic";

    document.getElementById("am-reset").href =
        "/users/" + username + "/reset-traffic";

    document.getElementById("am-delete").href =
        "/users/" + username + "/delete";

    actionMenu.classList.add("open");

    const rect = button.getBoundingClientRect();

    const menuWidth = 260;
    const menuHeight = actionMenu.offsetHeight || 500;

    let left = rect.right - menuWidth;
    let top = rect.bottom + 8;

    if (left < 10)
        left = 10;

    if (left + menuWidth > window.innerWidth - 10)
        left = window.innerWidth - menuWidth - 10;

    if (top + menuHeight > window.innerHeight - 10) {

        top = rect.top - menuHeight - 8;

        if (top < 10)
            top = 10;

    }

    actionMenu.style.left = left + "px";
    actionMenu.style.top = top + "px";

}
