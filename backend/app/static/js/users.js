let selectedUsers = [];

document.addEventListener("DOMContentLoaded",()=>{

    const toolbar=document.getElementById("bulk-toolbar");
    const counter=document.getElementById("selected-count");
    const selectAll=document.getElementById("select-all-users");

    function refreshSelection(){

        selectedUsers=[];

        document.querySelectorAll(".user-check:checked").forEach(c=>{
            selectedUsers.push(c.value);
        });

        counter.innerText=selectedUsers.length;

        toolbar.style.display=
            selectedUsers.length ? "flex" : "none";

        if(selectAll){

            const total=document.querySelectorAll(".user-check").length;

            selectAll.checked=
                total>0 &&
                selectedUsers.length===total;

        }

    }

    if(selectAll){

        selectAll.onchange=function(){

            document.querySelectorAll(".user-check").forEach(c=>{
                c.checked=this.checked;
            });

            refreshSelection();

        };

    }

    document.querySelectorAll(".user-check").forEach(c=>{

        c.onchange=refreshSelection;

    });

    refreshSelection();

});

function getSelectedUsers(){
    return selectedUsers;
}
