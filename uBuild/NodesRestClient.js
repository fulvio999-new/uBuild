/* API to get info about Jenkins NODES
Url are like: http://<BASE_URL>/computer/api/json
*/


/*
    Get all Job name with some info about them (link to job and buil status) and fill the listModel to display
*/
function getNodeList(jenkinsBaseUrl) {

    var xmlhttp = new XMLHttpRequest();
    var urlToCall = jenkinsBaseUrl+"/computer/api/json";

    //console.log("Loading Nodes from Jenkins url: "+jenkinsBaseUrl);

    xmlhttp.onreadystatechange=function() {
         if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {

             var obj = JSON.parse(xmlhttp.responseText);

             /* create an array of json Object */
             for(var i=0; i<obj.computer.length; i++){

                 try{
                    /* if a job have no 'color' set, means that is a folder, and this statement generate an Exception */
                    var tmp = obj.jobs[i].color.toString();

                    /* if no exception, add job to the model */
                    modelListNodes.append({"jobName" : obj.jobs[i].name, "jobUrl" : obj.jobs[i].url, "jobColor" : obj.jobs[i].color, "jenkinsBaseUrl":jenkinsBaseUrl } );

                 }catch(e){
                    //console.log("Found a folder, executing a recursive call to url: "+obj.jobs[i].url)
                    getJobList(obj.jobs[i].url);
                 }
             }
         }
    }

    xmlhttp.open("GET", urlToCall, true);
    xmlhttp.send();
}
