import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0

import "JobsRestClient.js" as JobsRestClient

/* Show the details of the selected job */
Flickable {
    id: flic
    anchors.fill: parent
    contentWidth: jobDetailsColumn.width;
    contentHeight: units.gu(6);
    flickableDirection: Flickable.HorizontalFlick; //necessary in case of Artifacts list is too long

    Column {
        id: jobDetailsColumn
        anchors.fill: parent
        spacing: units.gu(1)
        anchors.leftMargin: units.gu(0.5)

        Rectangle{
            color: "transparent"
            width: parent.width
            height: units.gu(6)
        }

        Component.onCompleted: {

            //execute the REST call to get the details of the selected job
            if (pageLoader.status === Loader.Loading){
                JobsRestClient.getJobDetails(jobDetailsPage.jenkinsBaseUrl,jobDetailsPage.jobName); //,jobDetailsPage.nodeType);
            }
        }

        //------ General data
        Row{

            Label {
                id: generalDataLabel
                text: "General Data"
                color: UbuntuColors.blue
                fontSize: "small"
            }
        }

        Row{

            Label {
                id: displayNameLabel
                text: "<b>Name: </b>"
                fontSize: "small"
            }
        }

        Row{
            Label {
                id: jobDescriptionLabel
                text: "<b>Description: </b>"
                fontSize: "small"
            }
        }

        Row{
            Label {
                id: jobUrlLabel
                /* text filled form javascript */
                text: "<b>URL: </b>"
                fontSize: "small"               
                onLinkActivated: Qt.openUrlExternally(link)
            }
        }

        Row{           
            Label {
                id: healthReportDescriptionLabel
                text: "<b>Health report descr.: </b>"
                fontSize: "small"
            }
        }

        Row{
            spacing: units.gu(2)

            Label {
                id: healthReportScoreLabel
                text: "<b>Health report score: </b>"
                fontSize: "small"
            }

            Label {
                id: jobInQueueLabel
                text: "<b>In Queue: </b>"
                fontSize: "small"
            }

            Label {
                id: jobBuildableLabel
                text: "<b>Buildable: </b>"
                fontSize: "small"
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
                text: "Build Informations"
                color: UbuntuColors.blue
                fontSize: "small"
            }
        }

        Row{
            spacing: units.gu(6)

            Label {
                id: totalBuildsLabel
                text: "<b>Total builds: </b>"
                fontSize: "small"
            }

            //---- Last Build
            Label {
                id: lastBuildNumberLabel
                text: "<b>Last build number: </b>"
                fontSize: "small"
            }
        }

        Row{
            Label {
                id: lastBuildUrlLabel
                text: "<b>URL: </b>"
                fontSize: "small"
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
                text: "Last complete build"
                color: UbuntuColors.blue
                fontSize: "small"
            }
        }

        Row{
            spacing: units.gu(6)

            Label {
                id: lastCompletedBuildNumberLabel
                text: "<b>Build number: </b>"
                fontSize: "small"
            }
        }

        Row{
            Label {
                id: lastCompletedBuildUrlLabel
                text: "<b>URL: </b>"
                fontSize: "small"
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
                text: "Last stable build"
                color: UbuntuColors.blue
                fontSize: "small"
            }
        }

        Row{
            spacing: units.gu(3)

            Label {
                id: lastStableBuildNumberLabel
                text: "<b>Build number: </b>"
                fontSize: "small"
            }

            Label {
                id: lastStableBuildResultLabel
                text: "<b>Build result: </b>"
                fontSize: "small"
            }
        }

        Row{
            Label {
                id: lastStableBuildUrlLabel
                text: "<b>URL: </b>"
                fontSize: "small"
                onLinkActivated: Qt.openUrlExternally(link)
            }
        }

        //Last stable Build Details
        Row{
            spacing: units.gu(6)

            Label {
                id: lastStableBuildTimestampLabel
                text: "<b>Build time: </b>"
                fontSize: "small"
            }
        }

        Row{
            Label {
                id: lastStableBuildEstimatedDurationLabel
                text: "<b>Build estimated duration: </b>"
                fontSize: "small"
            }
        }

        Row{
            Label {
                id: lastStableArtifactsArrayLabel
                text: "<b>Artifacts: </b>"
                fontSize: "small"
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


        //----- Last Failed Build ---
        Row{

            Label {
                id: lastFailedBuildLabel
                text: "Last failed build"
                color: UbuntuColors.blue
                fontSize: "small"
            }
        }

        Row{
            Label {
                id: lastFailedBuildNumberLabel
                text: "<b>Build number: </b>"
                fontSize: "small"
            }
        }

        Row{
            Label {
                id: lastFailedBuildUrlLabel
                text: "<b>URL: </b>"
                fontSize: "small"
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
                text: "Last Unstable build"
                color: UbuntuColors.blue
                fontSize: "small"
            }
        }

        Row{
            Label {
                id: lastUnstableBuildNumberLabel
                text: "<b>Build number: </b>"
                fontSize: "small"
            }
        }

        Row{
            Label {
                id: lastUnstableBuildUrlLabel
                text: "<b>URL: </b>"
                fontSize: "small"
                onLinkActivated: Qt.openUrlExternally(link)
            }
        }
        //------------------------
    }

    Scrollbar {
        flickableItem: flic
        align: Qt.AlignTrailing
    }

}
