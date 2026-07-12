let selectedUsers = [];

document.addEventListener("DOMContentLoaded", () => {

    const toolbar = document.getElementById("bulk-toolbar");
    const counter = document.getElementById("selected-count");
    const selectAll = document.getElementById("select-all-users");

    function refreshSelection() {

        selectedUsers = [];

        document.querySelectorAll(".user-check:checked").forEach(c => {
            selectedUsers.push(c.value);
        });

        if (counter)
            counter.innerText = selectedUsers.length;

        if (toolbar)
            toolbar.style.display =
                selectedUsers.length ? "flex" : "none";

        if (selectAll) {

            const total = document.querySelectorAll(".user-check").length;

            selectAll.checked =
                total > 0 &&
                selectedUsers.length === total;

        }

    }

    if (selectAll) {

        selectAll.onchange = function () {

            document.querySelectorAll(".user-check").forEach(c => {
                c.checked = this.checked;
            });

            refreshSelection();

        };

    }

    document.querySelectorAll(".user-check").forEach(c => {

        c.onchange = refreshSelection;

    });

    refreshSelection();

    // ============================
    // Bulk Buttons
    // ============================

    bindBulkButtons();

});

function getSelectedUsers() {
    return selectedUsers;
}

async function bulk(action) {

    if (selectedUsers.length === 0) {

        alert("No users selected");

        return;

    }

    let body = {

        users: selectedUsers,
        action: action

    };

    if (action === "extend") {

        let days = prompt("How many days?");

        if (days === null)
            return;

        body.days = parseInt(days);

    }

    try {

        const response = await fetch("/users/bulk", {

            method: "POST",

            headers: {
                "Content-Type": "application/json"
            },

            body: JSON.stringify(body)

        });

        const json = await response.json();

        alert(json.detail || "Done");

        location.reload();

    }
    catch (e) {

        alert("Bulk operation failed");

        console.error(e);

    }

}

function bindBulkButtons() {

    const enable = document.getElementById("bulk-enable");
    const disable = document.getElementById("bulk-disable");
    const block = document.getElementById("bulk-block");
    const addDays = document.getElementById("bulk-add-days");
    const removeDays = document.getElementById("bulk-remove-days");
    const deleteBtn = document.getElementById("bulk-delete");

    if (enable)
        enable.onclick = () => bulk("enable");

    if (disable)
        disable.onclick = () => bulk("disable");

    if (block)
        block.onclick = () => bulk("block");

    if (addDays)
        addDays.onclick = () => bulk("extend");

    if (removeDays)
        removeDays.onclick = () => {

            alert("Coming Soon");

        };

    if (deleteBtn)
        deleteBtn.onclick = () => {

            if (!confirm("Delete selected users?"))
                return;

            bulk("delete");

        };

}
