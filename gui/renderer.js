// This file is required by the index.html file and will
// be executed in the renderer process for that window.
// No Node.js APIs are available in this process because
// `nodeIntegration` is turned off. Use `preload.js` to
// selectively enable features needed in the rendering
// process.

function hoho() {
  alert('hoho la d d1');
}

// document.getElementById("ttt").addEventListener("click", hoho);  
// let $ = jQuery = require('jquery');
$('#ttt').on('click', hoho);