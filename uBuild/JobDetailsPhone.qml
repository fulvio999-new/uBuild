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
        spacing: units.gu(1)
        anchors.leftMargin: units.gu(0.5)

        Rectangle{
            color: "transparent"
            width: parent.width
            height: units.gu(6)
        }

        Component.onCompleted: {

            /* execute the REST call to get the details of the selected job */
            if (pageLoader.status === Loader.Loading){
                JobsRestClient.getJobDetails(jobDetailsPage.jenkinsBaseUrl,jobDetailsPage.jobName); //,jobDetailsPage.nodeType);
            }
        }

        //------ General data
        Row{

            Label {
                id: generalDataLabel
                text: i18n.tr("General Data")
                color: UbuntuColors.blue
                fontSize: "small"
            }
        }

        Row{

            Label {
                id: displayNameLabel
                text: "<b>"+i18n.tr("Name")+": </b>"
                fontSize: "small"
            }
        }

        Row{
            Label {
                id: jobDescriptionLabel
                text: "<b>"+i18n.tr("Description")+": </b>"
                fontSize: "small"
            }
        }

        Row{
            Label {
                id: jobUrlLabel
                /* text filled form javascript */
                text: "<b>"+i18n.tr("URL")+": </b>"
                fontSize: "small"
                onLinkActivated: Qt.openUrlExternally(link)
            }
        }

        Row{
            Label {
                id: healthReportDescriptionLabel
                text: "<b>"+i18n.tr("Health report descr.:")+" </b>"
                fontSize: "small"
            }
        }

        Row{
            spacing: units.gu(2)

            Label {
                id: healthReportScoreLabel
                text: "<b>"+i18n.tr("Health report score")+": </b>"
                fontSize: "small"
            }

            Label {
                id: jobInQueueLabel
                text: "<b>"+i18n.tr("In Queue")+": </b>"
                fontSize: "small"
            }

            Label {
                id: jobBuildableLabel
                text: "<b>"+i18n.tr("Buildable")+": </b>"
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
                text: i18n.tr("Build Informations")
                color: UbuntuColors.blue
                fontSize: "small"
            }
        }

        Row{
            spacing: units.gu(6)

            Label {
                id: totalBuildsLabel
                text: "<b>"+i18n.tr("Total builds")+": </b>"
                fontSize: "small"
            }

            //---- Last Build
            Label {
                id: lastBuildNumberLabel
                text: "<b>"+i18n.tr("Last build number")+": </b>"
                fontSize: "small"
            }
        }

        Row{
            Label {
                id: lastBuildUrlLabel
                text: "<b>"+i18n.tr("URL")+": </b>"
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
                text: i18n.tr("Last complete build")
                color: UbuntuColors.blue
                fontSize: "small"
            }
        }

        Row{
            spacing: units.gu(6)

            Label {
                id: lastCompletedBuildNumberLabel
                text: "<b>"+i18n.tr("Build number")+": </b>"
                fontSize: "small"
            }
        }

        Row{
            Label {
                id: lastCompletedBuildUrlLabel
                text: "<b>"+i18n.tr("URL")+": </b>"
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
                text: i18n.tr("Last stable build")
                color: UbuntuColors.blue
                fontSize: "small"
            }
        }

        Row{
            spacing: units.gu(3)

            Label {
                id: lastStableBuildNumberLabel
                text: "<b>"+i18n.tr("Build number")+": </b>"
                fontSize: "small"
            }

            Label {
                id: lastStableBuildResultLabel
                text: "<b>"+i18n.tr("Build result")+": </b>"
                fontSize: "small"
            }
        }

        Row{
            Label {
                id: lastStableBuildUrlLabel
                text: "<b>"+i18n.tr("URL")+": </b>"
                fontSize: "small"
                onLinkActivated: Qt.openUrlExternally(link)
            }
        }

        //Last stable Build Details
        Row{
            spacing: units.gu(6)

            Label {
                id: lastStableBuildTimestampLabel
                text: "<b>"+i18n.tr("Build time")+": </b>"
                fontSize: "small"
            }
        }

        Row{
            Label {
                id: lastStableBuildEstimatedDurationLabel
                text: "<b>"+i18n.tr("Build estimated duration")+": </b>"
                fontSize: "small"
            }
        }

        Row{
            spacing: units.gu(3)

            Label {
                id: lastStableArtifactsArrayLabel
                anchors.verticalCenter: showArtifactButton.verticalCenter
                text: "<b>"+i18n.tr("Artifact(s) found")+": "+artifactList.count+" </b>"
                fontSize: "small"
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
                text: i18n.tr("Last failed build")
                color: UbuntuColors.blue
                fontSize: "small"
            }
        }

        Row{
            Label {
                id: lastFailedBuildNumberLabel
                text: "<b>"+i18n.tr("Build number")+": </b>"
                fontSize: "small"
            }
        }

        Row{
            Label {
                id: lastFailedBuildUrlLabel
                text: "<b>"+i18n.tr("URL")+": </b>"
                fontSize: "small"
                onLinkActivated: Qt.openUrlExternally(link)
            }
        }


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
                text: i18n.tr("Last Unstable build")
                color: UbuntuColors.blue
                fontSize: "small"
            }
        }

        Row{
            spacing: units.gu(4)

            Label {
                id: lastUnstableBuildNumberLabel
                text: "<b>"+i18n.tr("Build number"+": </b>"
                fontSize: "small"
            }

            Label {
                id: lastUnstableBuildUrlLabel
                text: "<b>"+i18n.tr("URL")+": </b>"
                fontSize: "small"
                onLinkActivated: Qt.openUrlExternally(link)
            }
        }
        //------------------------

  }
