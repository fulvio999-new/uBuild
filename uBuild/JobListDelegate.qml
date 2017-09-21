import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3

import "JobsRestClient.js" as JobsRestClient
import "utility.js" as Utility

    /*
       Delegate component used to display a Jenkins job from the chosen Jenkins url
    */
   Item {
        id: jobItem

        width: jobsListPage.width
        height: units.gu(8.5) /* heigth of the rectangle */
        visible: true;

        /* create a container for each job */
        Rectangle {
            id: background
            x: 2; y: 2; width: parent.width - x*2; height: parent.height - y*1
            border.color: "black"
            radius: 5
        }

        ActivityIndicator {
            id: loadingJobDetailsActivity
        }

        /* This mouse region covers the entire delegate */
        MouseArea {
            id: selectableMouseArea
            anchors.fill: parent

            onClicked: {
                loadingJobDetailsActivity.running = true
                /* to recreate the job details page each time the user select a different job */
                pageLoader.source = "";

                pageStack.clear();
                pageStack.push(jobDetailsPage,
                                   {
                                       /* <page-variable-name>:<property-value-to-pass> */
                                       jobName:jobName,
                                       jenkinsBaseUrl:jenkinsBaseUrl
                                   }
                                   )

                /* move the highlight component to the currently selected item */
                listView.currentIndex = index
                loadingJobDetailsActivity.running = false
            }
        }        

        /* create a row for each entry in the Model */
        Row {
            id: topLayout
            x: 10; y: 7; height: background.height; width: parent.width
            spacing: units.gu(3)

            Column {
                id: containerColumn
                width: topLayout.width - units.gu(10); //jobStatusColumn.width; // units.gu(10);//background.width - buildStatusColumn.width; // -10;
                height: jobItem.height
                anchors.verticalCenter: topLayout.Center
                spacing: units.gu(1)

                Label {
                    text: i18n.tr("Job name: ") + jobName
                    fontSize: "small"
                }

                Label {
                    text: i18n.tr("url: ") + Utility.truncateUrlString(jobUrl)
                    fontSize: "small"
                }

                Label {
                    text: i18n.tr("Status: ")
                    id : jobStatusLabel
                    fontSize: "small"
                    font.bold: true
                }
            }


            /* Build statu Image icon */
            Column{
                id: buildStatusColumn
                width: units.gu(5);
                height: jobItem.height
                anchors.verticalCenter: topLayout.Center
                anchors.horizontalCenter: topLayout.Center
                spacing: units.gu(1)


                /* NB: if the image file are not found when running on emulator, add this entry in the .pro file
                   of the project:  $$files(*.png,true) and or  $$files(*.gif,true) then run Build --> qmake
                */
                AnimatedImage {
                    id: buildStatusImage                   
                    width: parent.width * 0.8
                    height: parent.height * 0.8
                    anchors.centerIn: buildStatusColumn.Right
                    fillMode: Image.PreserveAspectFit
                    paused: true
                }

                /* choose the color of the build icon status
                   See: http://javadoc.jenkins-ci.org/hudson/model/BallColor.html

                   https://github.com/jenkinsci/jenkins/tree/master/war/src/main/webapp/images/48x48
                */
                Component.onCompleted: {

                    /* console.log("Job icon color: "+jobColor); */

                    if(jobColor === "blue"){
                        buildStatusImage.source = "blue.png"  //success
                        jobStatusLabel.text = jobStatusLabel.text + "Success"

                    }else if(jobColor === "red"){
                        buildStatusImage.source = "red.png"     //failed
                        jobStatusLabel.text = jobStatusLabel.text + "Failed"

                    }else if(jobColor.indexOf("anime") !== -1){ // === "blue_anime") or 'red_anime' or 'aborted_anime'
                        buildStatusImage.source = "building_anime.gif"  //in progress
                        buildStatusImage.paused = false
                        jobStatusLabel.text = jobStatusLabel.text + "In progress"

                    }else if(jobColor === "disabled"){                        
                        buildStatusImage.source = "disabled.png" //disabled
                        jobStatusLabel.text = jobStatusLabel.text + "Disabled"


                    /* for folders there is recursive sub-scan
                    }else if(jobColor === ""){
                        buildStatusImage.source = "folder.png"
                    */

                    }else if(jobColor === "aborted"){
                         buildStatusImage.source = "aborted.png"
                         jobStatusLabel.text = jobStatusLabel.text + "Aborted"

                    }else if(jobColor === "notbuilt"){ //the project was never built
                        buildStatusImage.source = "nobuilt.png"
                        jobStatusLabel.text = jobStatusLabel.text + "No built"
                    }
                }
            }
        }
    }

