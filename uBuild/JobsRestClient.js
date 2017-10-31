.import "JobsRestClientDebug.js" as JobsRestClientDebug
.import "utility.js" as Utility


/* TODO: next relase: try to use JsonListModel + JSonPath instead of "manual"  parsing */


//--------------- JOBS INFO --------------------

    /*
        Get all Job name with some info about them (link to job and buil status) and fill the listModel to display
    */
    function getJobList(jenkinsBaseUrl) {

        var xmlhttp = new XMLHttpRequest();
        var urlToCall = jenkinsBaseUrl+"/api/json";

        //console.log("Loading jobs from Jenkins url: "+jenkinsBaseUrl);

        xmlhttp.onreadystatechange=function() {
             if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {

                 var obj = JSON.parse(xmlhttp.responseText);

                 /* create an array of json Object */
                 for(var i=0; i<obj.jobs.length; i++){

                     try{
                         /* workaround to check if color is set if a job have no 'color' set, means that is a folder, and this statement generate an Exception */
                         var color = obj.jobs[i].color.toString();

                         var jobStatus = "";
                         if(color === "blue"){
                             jobStatus = "success";
                         }else if (color === "red"){
                             jobStatus = "failed";
                         }else if(color.indexOf("anime") !== -1){
                             jobStatus = "progress";
                         }else if (color === "disabled"){
                             jobStatus = "disabled";
                         }else if (color === "aborted"){
                             jobStatus = "aborted";
                         }else if (color === "notbuilt"){
                             jobStatus = "notbuilt";
                         }

                         /* if no exception, add job to the model */
                         modelListJobs.append({"jobName" : obj.jobs[i].name, "jobUrl" : obj.jobs[i].url, "jobColor" : obj.jobs[i].color, "jenkinsBaseUrl":jenkinsBaseUrl, "jobStatus":jobStatus } );

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

    /*
       Get details for the given job
    */
    function getJobDetails(jenkinsUrl, jobName){

        var xmlhttp = new XMLHttpRequest();
        var url = jenkinsUrl+"/job/"+jobName+"/api/json";

        //console.log("Loading job Details for job: "+jobName+ " from url: "+url);

        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                fillJobDetailsModel(jenkinsUrl,xmlhttp.responseText,jobName);
            }
        }

        xmlhttp.open("GET", url, true);
        xmlhttp.send();
    }


     /*
       Rest call is finished: Update the UI component with the obtained Job details
     */
     function fillJobDetailsModel(jenkinsUrl,json,jobname) {

            var obj = JSON.parse(json);

            //--- General job info
            var jobDescription = obj.description === null ? "N/A" : obj.description;
            var displayName = obj.displayName === null ? "N/A" : obj.displayName;
            var jobUrl = obj.url === null ? "N/A" : obj.url;
            var jobName = obj.name === null ? "N/A" : obj.name;
            var jobBuildable = obj.buildable === null ? "N/A" : obj.buildable;

            //--- Build info: available only if choesen node i job
            var totalBuilds = obj.builds.length === null ? "N/A" : obj.builds.length;

            //--- Last build
            var lastBuildNumber = obj.lastBuild === null ? "N/A" : obj.lastBuild.number.toString();
            var lastBuildUrl = obj.lastBuild === null ? "N/A" : obj.lastBuild.url;

            //--- Last Completed Build  (note: .toString() is necessary to prevent javascript warning about assignment of different role String -> Number)
            var lastCompletedBuildNumber = obj.lastCompletedBuild === null ? "N/A" : obj.lastCompletedBuild.number.toString();
            var lastCompletedBuildUrl = obj.lastCompletedBuild === null ? "N/A" : obj.lastCompletedBuild.url;

            //--- Last Failed Build
            var lastFailedBuildNumber = obj.lastFailedBuild === null ? "N/A" : obj.lastFailedBuild.number.toString();
            var lastFailedBuildUrl = obj.lastFailedBuild === null ? "N/A" : obj.lastFailedBuild.url;

            //--- Last Unstable Build
            var lastUnstableBuildNumber = obj.lastUnstableBuild === null ? "N/A" : obj.lastUnstableBuild.number.toString();
            var lastUnstableBuildUrl = obj.lastUnstableBuild === null ? "N/A" : obj.lastUnstableBuild.url;

            //--- Last Stable Build
            var lastStableBuildNumber = obj.lastStableBuild === null ? "N/A" : obj.lastStableBuild.number.toString();
            var lastStableBuildUrl = obj.lastStableBuild === null ? "N/A" : obj.lastStableBuild.url;

            //--- Next Build
            var nextBuildNumber = obj.nextBuildNumber === null ? "N/A" : obj.nextBuildNumber.toString();

            //--- Health Report (for arrary type use a different check)
            var healthReportDescription = obj.healthReport.length === 0 ? "N/A" : obj.healthReport[0].description;
            var healthReportScore = obj.healthReport.length === 0 ? "N/A" : obj.healthReport[0].score.toString();

            var inQueue = obj.inQueue === null ? "N/A" : obj.inQueue;
            //console.log("Job in Queue: "+inQueue)

            modelDetailsJob.insert(0,[{
                                          "jobDescription" : jobDescription,
                                          "displayName" : displayName,
                                          "jobUrl" : jobUrl,
                                          "jobName" : jobName,
                                          "jobBuildable" : jobBuildable,
                                          "totalBuilds" : totalBuilds,
                                          "lastBuildNumber" : lastBuildNumber,
                                          "lastBuildUrl" : lastBuildUrl,
                                          "lastCompletedBuildNumber" : lastCompletedBuildNumber,
                                          "lastCompletedBuildUrl" : lastCompletedBuildUrl,
                                          "lastFailedBuildNumber" : lastFailedBuildNumber,
                                          "lastFailedBuildUrl" : lastFailedBuildUrl,
                                          "lastUnstableBuildNumber" : lastUnstableBuildNumber,
                                          "lastUnstableBuildUrl" : lastUnstableBuildUrl,
                                          "lastStableBuildNumber" : lastStableBuildNumber,
                                          "lastStableBuildUrl" : lastStableBuildUrl,
                                          "nextBuildNumber" : nextBuildNumber,
                                          "healthReportDescription" : healthReportDescription,
                                          "healthReportScore" : healthReportScore,
                                          "inQueue" : inQueue
                                     }] );

            //JobsRestClientDebug.printJobDetailsModel(modelDetailsJob);

            if(lastStableBuildNumber !== "N/A"){
                getLastStableBuildDetails(jenkinsUrl,lastStableBuildNumber,jobname);
            }


           /*  Update the UI with the loaded values */
           jobUrlLabel.text = jobUrlLabel.text + Utility.getHyperLink(modelDetailsJob.get(0).jobUrl);
           jobDescriptionLabel.text = jobDescriptionLabel.text + modelDetailsJob.get(0).jobDescription;
           displayNameLabel.text = displayNameLabel.text + modelDetailsJob.get(0).displayName;

           jobBuildableLabel.text = jobBuildableLabel.text + modelDetailsJob.get(0).jobBuildable;
           totalBuildsLabel.text = totalBuildsLabel.text + modelDetailsJob.get(0).totalBuilds;
           lastBuildNumberLabel.text = lastBuildNumberLabel.text + modelDetailsJob.get(0).lastBuildNumber;

           lastBuildUrlLabel.text = lastBuildUrlLabel.text + Utility.getHyperLink(modelDetailsJob.get(0).lastBuildUrl);
           lastCompletedBuildNumberLabel.text = lastCompletedBuildNumberLabel.text + modelDetailsJob.get(0).lastCompletedBuildNumber;

           lastCompletedBuildUrlLabel.text = lastCompletedBuildUrlLabel.text + Utility.getHyperLink(modelDetailsJob.get(0).lastCompletedBuildUrl);
           lastFailedBuildNumberLabel.text = lastFailedBuildNumberLabel.text + modelDetailsJob.get(0).lastFailedBuildNumber;

           lastFailedBuildUrlLabel.text = lastFailedBuildUrlLabel.text + Utility.getHyperLink(modelDetailsJob.get(0).lastFailedBuildUrl);
           lastUnstableBuildNumberLabel.text = lastUnstableBuildNumberLabel.text + modelDetailsJob.get(0).lastUnstableBuildNumber;

           lastUnstableBuildUrlLabel.text = lastUnstableBuildUrlLabel.text + Utility.getHyperLink(modelDetailsJob.get(0).lastUnstableBuildUrl);
           lastStableBuildNumberLabel.text = lastStableBuildNumberLabel.text + modelDetailsJob.get(0).lastStableBuildNumber;

           lastStableBuildUrlLabel.text = lastStableBuildUrlLabel.text + Utility.getHyperLink(modelDetailsJob.get(0).lastStableBuildUrl);

           healthReportDescriptionLabel.text = healthReportDescriptionLabel.text + modelDetailsJob.get(0).healthReportDescription;

           healthReportScoreLabel.text = healthReportScoreLabel.text + modelDetailsJob.get(0).healthReportScore;

           jobInQueueLabel.text = jobInQueueLabel.text + modelDetailsJob.get(0).inQueue;
    }


//-------------- BUILD DETAILS ------------------

    /*
      Get information about a specific Job build number
      eg: http://<base-url>/job/<job-name>/<build-number>/api/json
    */
    function getLastStableBuildDetails(jenkinsUrl,buildNumber,jobName){

        var xmlhttp = new XMLHttpRequest();
        var url = jenkinsUrl+"/job/"+jobName+"/"+buildNumber+"/api/json";

        //console.log("Get Job build info for build: "+buildNumber+" to url: "+url)

        var lastBuildDetails;

        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
               fillLastStableBuildModel(xmlhttp.responseText);
            }
        }
        xmlhttp.open("GET", url, true);
        xmlhttp.send();       
    }


    function fillLastStableBuildModel(json){

        var obj = JSON.parse(json);

        var buildTimestamp = obj.timestamp === null ? "N/A" : obj.timestamp;       
        var buildUrl = obj.url === null ? "N/A" : obj.url;
        var buildEstimatedDuration = obj.estimatedDuration === null ? "N/A" : obj.estimatedDuration;        
        var buildResult = obj.result === null ? "N/A" : obj.result;

        var artifactsArray = [];

        if(obj.artifacts !== null)
        {
            for (var n=0; n < obj.artifacts.length; n++) {
                artifactsArray.push({ "fileName": obj.artifacts[n].fileName, "relativePath" : obj.artifacts[n].relativePath });
            }
        }

        lastStableBuildDetails.insert(0,[{
                                        "lastStableBuildTimestamp" : new Date(buildTimestamp).toGMTString(),
                                        //already present: "lastStableBuildUrl" : buildUrl,
                                        "lastStableBuildEstimatedDuration" : buildEstimatedDuration,
                                        "lastStableBuildResult" : buildResult,
                                        "lastStableArtifactsArray" :artifactsArray
                                      }]);

        //enable for debug
        //JobsRestClientDebug.printLastStableBuildModel(lastStableBuildDetails);
        //JobsRestClientDebug.printJavascriptArray(artifactsArray);

        /* Update UI. NOTE: this operation is done here because the rest call is async and here the call is completed */
        lastStableBuildTimestampLabel.text = lastStableBuildTimestampLabel.text + lastStableBuildDetails.get(0).lastStableBuildTimestamp
        lastStableBuildEstimatedDurationLabel.text = lastStableBuildEstimatedDurationLabel.text + lastStableBuildDetails.get(0).lastStableBuildEstimatedDuration
        lastStableBuildResultLabel.text = lastStableBuildResultLabel.text + lastStableBuildDetails.get(0).lastStableBuildResult


        /* fill the ListModel wiht the artifacts found for the build  */
        for (var i = 0; i < artifactsArray.length; i++) {
           var object = artifactsArray[i];

           for (var property in object) {
               //console.log("item [" + i + "]: " + property + " = " + object[property]);
               if(property === "fileName")
                  artifactList.append( {"fileName": object[property] });
           }
        }
    }

