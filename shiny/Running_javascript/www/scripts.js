Shiny.addCustomMessageHandler("testMSG",
  function (message){
    alert(message);
  }
);


function sayhello(my_message){
  // alert(my_message);
  
  el = document.getElementById("myDiv");
  
  el.innerHTML = my_message;
}


Shiny.addCustomMessageHandler("handler1", toggleBackground);


function toggleBackground(message1){
  
  COLORS = ["blue", "red", "yellow", "green", "purple", "gray", "lightblue"];
  
  el = document.getElementById('myDiv');
  
  n = message1 % COLORS.length;
  
  /*if (message1 % 2 == 0){
    el.style.background = 'yellow';
  } else {
    el.style.background = 'blue';
  }*/
  
  el.style.background = COLORS[n];
  
  el.innerHTML = "This color: " + COLORS[n];
  el.innerHTML += "<br>";
  el.innerHTML += "Next color: " + COLORS[(n+1) % COLORS.length]; 
  
}



