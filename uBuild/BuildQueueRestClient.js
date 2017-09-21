/*
  functions to get informations about Build Queue
*/

    /* Get Build queue informations */
    function getLoadStatisitcs() {
           var xmlhttp = new XMLHttpRequest();
           var url = "http://ci.ubports.com/queue/api/json?pretty=true";

           xmlhttp.onreadystatechange=function() {
               if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                   updateUi(xmlhttp.responseText);
               }
           }
           xmlhttp.open("GET", url, true);
           xmlhttp.send();
    }

    /* Update the UI component to show the loaded json response */
    function updateUi(json) {
           var obj = JSON.parse(json);

           for(var i=0; i<obj.jobs.length; i++){
             console.log("Response:"+obj.jobs[i].name)
               textArea.text += obj.jobs[i].name + "<br/>"
           }
           // textArea.text = obj // {jsondata: obj.first +" "+ obj.last }
           //listview.model.append( {jsondata: obj.first +" "+ obj.last })
    }
