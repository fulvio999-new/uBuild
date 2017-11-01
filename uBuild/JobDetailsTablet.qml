import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0

import "JobsRestClient.js" as JobsRestClient

/* Show the details of the selected job */

 Column {
        id: jobDetailsColumn

        anchors.fill: parent
        spacing: units.gu(2)
        anchors.leftMargin: units.gu(2)

        Rectangle{
            color: "transparent"
            width: parent.width
            height: units.gu(6)
        }

        Component.onCompleted: {

            /* execute the REST call to get the details of the selected job */
            if (pageLoader.status === Loader.Loading){
                JobsRestClient.getJobDetails(jobDetailsPage.jenkinsBaseUrl,jobDetailsPage.jobName);
            }
        }

        //------ General data
        Row{

            Label {
                id: generalDataLabel
                text: "<b>General Data</b>"
                color: UbuntuColors.blue
            }
        }

        Row{
            spacing: units.gu(6)

            Label {
                id: displayNameLabel
                text: "<b>Name: </b>"
            }

            Label {
                id: jobDescriptionLabel
                text: "<b>Description: </b>"
            }
        }

        Row{
            spacing: units.gu(8)

            Label {
                id: jobBuildableLabel
                text: "<b>Buildable: </b>"
            }

            Label {
                id: jobUrlLabel
                /* text updated from javascript */
                text: "<b>URL: </b>"                
                onLinkActivated: Qt.openUrlExternally(link)
            }
        }

        //health report
        Label {
            id: healthReportDescriptionLabel
            text: "<b>Health report description: </b>"
        }

        Row{
            spacing: units.gu(2)

            Label {
                id: healthReportScoreLabel
                text: "<b>Health report score: </b>"
            }

            Label {
                id: jobInQueueLabel
                text: "<b>In Queue: </b>"
            }
        }

        /* line separator */
        Rectangle {
            color: "grey"
            width: units.gu(100)
            anchors.horizontalCenter: parent.horizontalCenter
            height: units.gu(0.1)
        }


        //----- Builds Section
        Row{
            Label {
                id: buildLabel
                text: "<b>Build Informations</b>"
                color: UbuntuColors.blue
            }
        }

        Row{
            spacing: units.gu(6)

            Label {
                id: totalBuildsLabel
                text: "<b>Total builds: </b>"
            }

            //---- Last Build
            Label {
                id: lastBuildNumberLabel
                text: "<b>Last build number: </b>"
            }

            Label {
                id: lastBuildUrlLabel
                /* text updated with javascript */
                text: "<b>URL: </b>"
                onLinkActivated: Qt.openUrlExternally(link)
            }
        }
        //------------------------


        /* line separator */
        Rectangle {
            color: "grey"
            width: units.gu(100)
            anchors.horizontalCenter: parent.horizontalCenter
            height: units.gu(0.1)
        }

        //----- Last complete Build
        Row {
            spacing: units.gu(6)

            Label {
                id: lastBuildLabel
                text: "<b>Last complete build</b>"
                color: UbuntuColors.blue
            }
        }

        Row{
            spacing: units.gu(6)

            Label {
                id: lastCompletedBuildNumberLabel
                text: "<b>Build number: </b>"
            }

            Label {
                id: lastCompletedBuildUrlLabel
                /* text updated with javascript */
                text: "<b>URL: </b>"
                onLinkActivated: Qt.openUrlExternally(link)
            }
        }
        //------------------------


        /* line separator */
        Rectangle {
            color: "grey"
            width: units.gu(100)
            anchors.horizontalCenter: parent.horizontalCenter
            height: units.gu(0.1)
        }


        //----- Last Stable Build
        Row {

            Label {
                id: lastStableBuildLabel
                text: "<b>Last stable build</b>"
                color: UbuntuColors.blue
            }
        }

        Row{
            spacing: units.gu(6)

            Label {
                id: lastStableBuildNumberLabel
                text: "<b>Build number: </b>"
            }

            Label {
                id: lastStableBuildUrlLabel
                /* text updated by javascript */
                text: "<b>URL: </b>"
                onLinkActivated: Qt.openUrlExternally(link)
            }
        }

        //Last stable Build Details
        Row{
            spacing: units.gu(6)

            Label {
                id: lastStableBuildTimestampLabel
                text: "<b>Build time: </b>"
            }

            Label {
                id: lastStableBuildEstimatedDurationLabel
                text: "<b>Build estimated duration: </b>"
            }

            Label {
                id: lastStableBuildResultLabel
                text: "<b>Build result: </b>"
            }
        }

        Row{
            spacing: units.gu(3)

            Label {
                id: lastStableArtifactsArrayLabel
                anchors.verticalCenter: showArtifactButton.verticalCenter
                text: "<b>Artifact(s) found: "+artifactList.count+" </b>"
            }

            Button{
                id:showArtifactButton
                text: "Display"
                color: UbuntuColors.graphite
                onClicked: {
                   PopupUtils.open(popoverArtifactListComponent, showArtifactButton)
                }
            }
        }      


        /* line separator */
        Rectangle {
            color: "grey"
            width: units.gu(100)
            anchors.horizontalCenter: parent.horizontalCenter
            height: units.gu(0.1)
        }


        //----- Last Failed Build
        Row{

            Label {
                id: lastFailedBuildLabel
                text: "<b>Last failed build</b>"
                color: UbuntuColors.blue
            }
        }

        Row{
            spacing: units.gu(6)

            Label {
                id: lastFailedBuildNumberLabel
                text: "<b>Build number: </b>"
            }

            Label {
                id: lastFailedBuildUrlLabel
                /* text updated with javascript */
                text: "<b>URL: </b>"
                onLinkActivated: Qt.openUrlExternally(link)
            }
        }
        //------------------------

        /* line separator */
        Rectangle {
            color: "grey"
            width: units.gu(100)
            anchors.horizontalCenter: parent.horizontalCenter
            height: units.gu(0.1)
        }


        //------ Last Unstable Build
        Row{

            Label {
                id: lastUnstableBuildLabel
                text: "<b>Last Unstable build</b>"
                color: UbuntuColors.blue
            }
        }

        Row{
            spacing: units.gu(6)

            Label {
                id: lastUnstableBuildNumberLabel
                text: "<b>Build number: </b>"
            }

            Label {
                id: lastUnstableBuildUrlLabel
                /* text updated with javascript */
                text: "<b>URL: </b>"
                onLinkActivated: Qt.openUrlExternally(link)
            }
        }
        //------------------------

   }

