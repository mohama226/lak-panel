async function loadAnalytics(){


let res =
await fetch(
"/users/{{user.username}}/analytics"
);


let data =
await res.json();



document.getElementById(
"connection-count"
).innerHTML =
data.summary.connections;



document.getElementById(
"last-connection"
).innerHTML =
data.summary.last_connection;



}



loadAnalytics();
