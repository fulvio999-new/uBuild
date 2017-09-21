
/*

  Rest clinet with debug functions and mock response that can be included where necessary

*/


/* ----------------------------------- DEBUG FUNCTIONS ----------------------------------- */


    /* DEBUG utility to print object like: var ob = [{"fileName": device_.tar.build, "relativePath":"devicePath1"}, {"fileName":device2_.tar.build, "relativePath":"devicePath2"}, ...]; */
    function printJavascriptArray(array){

         console.log("Input Array size: "+array.length);

         for (var i = 0; i < array.length; i++) {
            var object = array[i];
            for (var property in object) {
                 console.log("item [" + i + "]: " + property + " = " + object[property]);
            }
         }
    }


    /* DEBUG utility */
    function printLoadedJobsNames(){

        for (var n=0; n < modelListJobs.count; n++) {
            console.log("JobName: "+modelListJobs.get(n).jobName);
        }
    }

    /* DEBUG utility: print Last stable build model content */
    function printLastStableBuildModel(modelToPrint){

        console.log("---------- Last Stable Build Model: --------------");

        console.log("buildTimestamp: "+ modelToPrint.get(0).lastStableBuildTimestamp);
        console.log("buildUrl: "+ modelToPrint.get(0).lastStableBuildUrl);
        console.log("buildEstimatedDuration: "+ modelToPrint.get(0).lastStableBuildEstimatedDuration);
        console.log("buildResult: "+ modelToPrint.get(0).lastStableBuildResult);

    }

    /* DEBUG utility: print Job details model content */
    function printJobDetailsModel(modelToPrint){

         console.log("---------- Job Details Model: --------------");

         console.log("jobDescription: "+modelToPrint.get(0).jobDescription);
         console.log("displayName: "+modelToPrint.get(0).displayName);
         console.log("jobUrl: "+modelToPrint.get(0).jobUrl);
         console.log("jobName: "+modelToPrint.get(0).jobName);
         console.log("jobBuildable: "+modelToPrint.get(0).jobBuildable);
         console.log("totalBuilds: "+modelToPrint.get(0).totalBuilds);
         console.log("lastBuildNumber: "+modelToPrint.get(0).lastBuildNumber);
         console.log("lastBuildUrl: "+modelToPrint.get(0).lastBuildUrl);
         console.log("lastCompletedBuildNumber: "+modelToPrint.get(0).lastCompletedBuildNumber);
         console.log("lastCompletedBuildUrl: "+modelToPrint.get(0).lastCompletedBuildUrl);
         console.log("lastFailedBuildNumber: "+modelToPrint.get(0).lastFailedBuildNumber);
         console.log("lastFailedBuildUrl: "+modelToPrint.get(0).lastFailedBuildUrl);
         console.log("lastUnstableBuildNumber: "+modelToPrint.get(0).lastUnstableBuildNumber);
         console.log("lastUnstableBuildUrl: "+modelToPrint.get(0).lastUnstableBuildUrl);
         console.log("lastStableBuildNumber: "+modelToPrint.get(0).lastStableBuildNumber);
         console.log("lastStableBuildUrl: "+modelToPrint.get(0).lastStableBuildUrl);
         console.log("nextBuildNumber: "+modelToPrint.get(0).nextBuildNumber);
         console.log("healthReportDescription: "+modelToPrint.get(0).healthReportDescription);
         console.log("healthReportScore: "+modelToPrint.get(0).healthReportScore);
    }







/* ---------------------------- MOCK FUNTIONS ----------------------- */

    function getAllJobsNamesWithInfo_MOCK(jenkinsBaseUrl) {

        for(var i=0; i<4; i++){
           modelListJobs.append({"jobName" : "FakeName"+i, "jobUrl" : "FakeUrl"+i, "jobColor" : "FakeColor"+i, "jenkinsBaseUrl":jenkinsBaseUrl } );
        }
    }


    function getJobDetails_MOCK(jenkinsUrl, jobName){

        modelDetailsJob.insert(0,[{
                                    "jobDescription" : "jobDescription",
                                    "displayName" : "displayName",
                                    "jobUrl" : "jobUrl",
                                    "jobName" : jobName,
                                    "jobBuildable" : "jobBuildable",
                                    "totalBuilds" : "totalBuilds",
                                    "lastBuildNumber" : "lastBuildNumber",
                                    "lastBuildUrl" : "lastBuildUrl",
                                    "lastCompletedBuildNumber" : "lastCompletedBuildNumber",
                                    "lastCompletedBuildUrl" : "lastCompletedBuildUrl",
                                    "lastFailedBuildNumber" : "lastFailedBuildNumber",
                                    "lastFailedBuildUrl" : "lastFailedBuildUrl",
                                    "lastUnstableBuildNumber" : "lastUnstableBuildNumber",
                                    "lastUnstableBuildUrl" : "lastUnstableBuildUrl",
                                    "lastStableBuildNumber" : "lastStableBuildNumber",
                                    "lastStableBuildUrl" : "lastStableBuildUrl",
                                    "nextBuildNumber" : "nextBuildNumber",
                                    "healthReportDescription" :" healthReportDescription",
                                    "healthReportScore" : "healthReportScore"
                                }] );

         getLastStableBuildDetails_MOCK(100,jobName);

    }


    function getLastStableBuildDetails_MOCK(buildNumber,jobName){

        var artifactsArray = [];

        for (var n=0; n < 3; n++) {
            artifactsArray.push({ "fileName": "fileName-mock", "relativePath" : "relativePath-mock" });
        }

        lastStableBuildDetails.insert(0,[{
                                        "buildTimestamp" : "buildTimestamp",
                                        "buildUrl" : "buildUrl",
                                        "buildEstimatedDuration" : "buildEstimatedDuration",
                                        "buildResult" : "buildResult",
                                        "artifactsArray" :artifactsArray
                                      }]);

    }

