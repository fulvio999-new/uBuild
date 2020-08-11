import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Layouts 1.0
import Ubuntu.Components.Popups 1.3
import QtQuick.LocalStorage 2.0

import "JobsRestClient.js" as JobsRestClient
import "NodesRestClient.js" as NodesRestClient
import "utility.js" as Utility
import "Storage.js" as Storage

import Ubuntu.Components.ListItems 1.3 as ListItem


MainView {

    id: rootPage

    objectName: "mainView"

    /* Note! applicationName needs to match the "name" field of the click manifest */
    applicationName: "ubuild"

    width: units.gu(160)
    height: units.gu(90)

    /* phone 4.5 */
    //width: units.gu(50)
    //height: units.gu(96)

    anchorToKeyboard: true

    property string appVersion : "1.2.3"

    property string jenkinsTargetUrl;

    /* Settings file is saved in ~user/.config/<applicationName>/<applicationName>.conf  File */
    Settings {
        id:settings
        /* flag to create or not the database */
        property bool isFirstUse : true;
        property bool defaultDataImported : false;
    }

    Component.onCompleted: {

        if(settings.isFirstUse == true){
           Storage.createTables();
           Storage.insertDefaultJenkinsUrl();
           settings.isFirstUse = false
           settings.defaultDataImported = true
        }

        if(settings.defaultDataImported == false){
           Storage.insertDefaultJenkinsUrl();
           settings.defaultDataImported = true
        }

        /* load saved jenkins urls */
        Storage.loadAllJenkinsUrl();
    }

    /* Enables the application to change orientation when the device is rotated. The default is false */
    automaticOrientation: true

    /* The list of registered Jenkins url, filled using Database saved content */
    ListModel {
       id: jenkinsUrlComboModel
    }

    Component {
        id: urlSelectorDelegate
        OptionSelectorDelegate { text: name; subText: description; }
    }

    /* PopUp with Application info */
    Component {
        id: aboutProductDialogue
        AboutProductDialog{}
    }

    /* Database eraser dialog */
    Component {
        id: dataBaseEraserDialog
        DataBaseEraserDialog{}
    }

    Component {
       id: invalidInputPopUp
       InvalidInputPopUp{msg:i18n.tr("Please, select an URL")}
    }

    /* Loader used to dinamically create the page with the job details  only for the chosen job */
    Loader {
        id: pageLoader
        anchors.fill: parent
    }

    /* the details of the chosen job */
    ListModel{
       id: modelDetailsJob
    }

    /* the last stable build details of the chosen job */
    ListModel{
       id: lastStableBuildDetails
    }



    PageStack {
        id: pageStack

        /* set the firts page of the application */
        Component.onCompleted: {
           pageStack.push(jobsListPage);
        }

        /* show the jobs list found in the target jenkins */
        Page {
            id: jobsListPage

            header: PageHeader {
                id: pageHeader
                title: "uBuild "+rootPage.appVersion

                /* leadingActionBar is the bar on the left side */
                leadingActionBar.actions: [
                    Action {
                        id: aboutPopover
                        /* icons names are file names under: /usr/share/icons/suru/actions/scalable */
                        iconName: "info"
                        text: i18n.tr("About")
                        onTriggered:{
                            PopupUtils.open(aboutProductDialogue)
                        }
                    }
                ]

                /* trailingActionBar is the bar on the right side */
                trailingActionBar.actions: [

                    Action {
                        iconName: "delete"
                        text: i18n.tr("Delete")
                        onTriggered:{
                            PopupUtils.open(dataBaseEraserDialog)
                        }
                    },

                    Action {
                        iconName: "settings"
                        text: i18n.tr("Settings")
                        onTriggered:{
                            pageStack.push(configurationPage)
                        }
                    }
                ]
            }

            /* the list of ALL jobs loaded from the chosen Jenkins */
            ListModel{
               id: modelListJobs
            }

            Component {
               id: jobListDelegate
               JobListDelegate{}
            }

            /* keep sorted the loaded jobs List based on "filter.property" property
               provided by the user with the filter combo */
            SortFilterModel {
                id: sortedModelListJobs
                model: modelListJobs
                sort.order: Qt.AscendingOrder
                sortCaseSensitivity: Qt.CaseSensitive
            }

            /* The Jobs list loaded from the chosen Jenkins url */
            UbuntuListView {
                id: listView
                anchors.fill: parent
                anchors.topMargin: units.gu(33)
                model: sortedModelListJobs
                delegate: jobListDelegate

                /* disable the dragging of the model list elements */
                boundsBehavior: Flickable.StopAtBounds
                highlight: HighlightComponent{}
                focus: true
                /* clip:true to prevent that UbuntuListView draw out of his assigned rectangle, default is false */
                clip: true
            }

            Component {
                id: filterTypeSelectorDelegate
                OptionSelectorDelegate { text: name; }
            }

            /* The available Job filter criteria */
            ListModel {
                 id: searchFilterModel
                 ListElement { name: "<b>Job Name</b>" }
                 ListElement { name: "<b>Job Status</b>" }
            }

            Layouts {
                id: layoutJobsMainPage
                width: parent.width
                height: parent.height
                layouts:[

                    ConditionalLayout {
                        name: "layoutsConfiguration"
                        when: rootPage.width > units.gu(50)
                        JobsMainPageTablet{}
                    }
                ]
                //else
                JobsMainPagePhone{}
            }

            Scrollbar {
                flickableItem: listView
                align: Qt.AlignTrailing
            }
        }


        //-------------------- JOB DETAILS PAGE ----------------------
        Page{
            id:jobDetailsPage
            visible: false
            anchors.fill: parent

            /* passed as input when the user selecct a job in the list */
            property string jobName;     /* the name of the selected job */
            property string jenkinsBaseUrl;

            /* contains the artifacts found for the chosen job */
            ListModel{
               id: artifactList
            }

            //------- Display the Artifact list with a PopUp ----------
            Component {
                id: popoverArtifactListComponent

                Dialog {
                    id: subCategoryPickerDialog
                    contentWidth: units.gu(42)
                    title: i18n.tr("Found")+": "+artifactList.count +" "+i18n.tr("Artifact(s)")

                    OptionSelector {
                        id: subCategoryOptionSelector
                        expanded: true
                        multiSelection: false
                        model: artifactList
                        containerHeight: itemHeight * 4
                    }

                    Button {
                        anchors.horizontalCenter: parent.Center
                        text: i18n.tr("Close")
                        width: units.gu(14)
                        onClicked: {
                            PopupUtils.close(subCategoryPickerDialog)
                        }
                    }
                }
            }
            //---------------------------------------------------------


            onVisibleChanged: {
                pageLoader.source = (rootPage.width > units.gu(80)) ? "JobDetailsTablet.qml" : "JobDetailsPhone.qml"
            }

            header: PageHeader {
                id: headerDetailsPage
                title: i18n.tr("Details for")+": " + "<b>" +jobDetailsPage.jobName +"</b>"

                leadingActionBar.actions: [
                    Action {
                        iconName: "back"
                        text: i18n.tr("Back")

                        onTriggered:{
                            pageStack.clear();
                            pageStack.push(jobsListPage);
                            /* otherwise there is an overlap of jobList and jobDetails Pages */
                            pageLoader.source = "";
                        }
                    }
                ]
            }
        }


        //----------------- App Configuration page -----------------
        Page {
            id: configurationPage
            visible: false

            header: PageHeader {
                title: i18n.tr("Application Configuration")
            }

            Layouts {
                id: layoutConfigurationPage
                width: parent.width
                height: parent.height
                layouts:[

                    ConditionalLayout {
                        name: "layoutsConfiguration"
                        when: rootPage.width > units.gu(50)
                        ConfigurationPageTablet{}
                    }
                ]
                //else
                ConfigurationPagePhone{}
            }
        }

       //---------------------- Show the currently saved Jenkins URL and their alias ------------------------

       Page{
            id:savedJenkinsUrlPage
            visible: false
            anchors.fill: parent
            header: PageHeader {
                title: i18n.tr("Saved Jenkins Url(s) found")+": "+savedJenkinsUrlListModel.count
            }

            /* the list of saved Jenkins url */
            ListModel{
               id: savedJenkinsUrlListModel
            }

            Component {
               id: jenkinsUrlDelegate
               JenkinsUrlDelegate{}
            }

            UbuntuListView {
                id: savedJenkinsListView
                anchors.fill: parent
                anchors.topMargin: units.gu(8)
                model: savedJenkinsUrlListModel
                delegate: jenkinsUrlDelegate
                /* if false, the List scroll under the above component (ie. the search form) */
                clip: true
                /* disable the pull/dragging of the model list elements */
                boundsBehavior: Flickable.StopAtBounds
                highlight: HighlightJenkinsUrlComponent{}
                focus: true
            }

            /* allow scroll to prevent keyboard overlap during edit operation */
            Scrollbar {
                flickableItem: savedJenkinsListView
                align: Qt.AlignTrailing
            }
        }
    }

}
