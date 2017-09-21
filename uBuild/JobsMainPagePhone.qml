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


    /*
       Show job search form shown when running on Phone
    */
        Column{
            id: listHeader
            x: units.gu(1)

            spacing: units.gu(1)

            /* transparent placeholder: required to place the content under the header */
            Rectangle {
                color: "transparent"
                width: parent.width
                height: units.gu(6)
            }

            Row{
                id:row0
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: units.gu(2)

                Label {
                    text: i18n.tr("Enable auto-refresh (2 minutes)")
                }

                Switch  {
                    id: autoRefresh
                    checked: false
                    enabled: false
                    onCheckedChanged: {
                        if(autoRefresh.checked){                          
                           refreshJobsStatusTimer.start();
                        }else{
                           refreshJobsStatusTimer.stop();
                        }
                    }
                }
            }

            Row{
                id:row1
                spacing: units.gu(1)
                anchors.horizontalCenter: parent.horizontalCenter

                TextField{
                    id: filterJobField
                    placeholderText: i18n.tr("Search job name")
                    width: units.gu(32)
                    enabled:false
                    onTextChanged: {

                        if(text.length === 0 ) { //show all
                            sortedModelListJobs.filter.pattern = /./
                            sortedModelListJobs.sort.order = Qt.AscendingOrder
                            sortedModelListJobs.sortCaseSensitivity = Qt.CaseSensitive
                        }
                    }
                }

                Button{
                    id:jobFilterButton
                    text: i18n.tr("Filter")
                    width: units.gu(12)
                    x: loadJobsButton.x
                    onClicked: {
                        if(filterJobField.text.length > 0 ) //filter
                        {
                            /* flag "i" = ignore case */
                            sortedModelListJobs.filter.pattern = new RegExp(filterJobField.text, "i")
                            sortedModelListJobs.sort.order = Qt.AscendingOrder
                            sortedModelListJobs.sortCaseSensitivity = Qt.CaseSensitive

                        } else { //show all

                            sortedModelListJobs.filter.pattern = /./
                            sortedModelListJobs.sort.order = Qt.AscendingOrder
                            sortedModelListJobs.sortCaseSensitivity = Qt.CaseSensitive
                        }
                    }
                }
            }

            Row{
                id:row2
                spacing: units.gu(3)
                anchors.horizontalCenter: parent.horizontalCenter

                Label{
                    id: lastCheckLabel
                    text: ""
                    font.bold: false
                    font.pointSize: units.gu(1)
                }

                Label{
                    id: jobsFoundLabel
                    text:  i18n.tr("Total Jobs found: ")+ listView.count
                    font.bold: false
                    font.pointSize: units.gu(1)
                }
            }

            Row{
                id: row3
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: units.gu(1)

                Component {
                    id: jenkinsUrlChooser

                    Dialog {
                        id: subCategoryPickerDialog
                        title: i18n.tr("Found: "+jenkinsUrlComboModel.count+ "Jenkins url(s)")

                        OptionSelector {
                            id: jenkinsAliasSelector
                            expanded: true
                            multiSelection: false
                            delegate: urlSelectorDelegate
                            model: jenkinsUrlComboModel
                            containerHeight: itemHeight * 4
                        }

                        Row {
                            spacing: units.gu(2)
                            Button {
                                text: i18n.tr("Close")
                                width: units.gu(14)
                                onClicked: {
                                    PopupUtils.close(subCategoryPickerDialog)
                                }
                            }

                            Button {
                                text: i18n.tr("Select")
                                width: units.gu(14)
                                onClicked: {
                                    var name = jenkinsUrlComboModel.get(jenkinsAliasSelector.selectedIndex).name;
                                    var url = jenkinsUrlComboModel.get(jenkinsAliasSelector.selectedIndex).description;

                                    jenkinsUrlChooserField.text = name;
                                    jenkinUrlText.text = url;
                                    /* clean old showed values */
                                    modelListJobs.clear();

                                    /* blank old values */
                                    lastCheckLabel.text = " ";                                    

                                    PopupUtils.close(subCategoryPickerDialog)
                                }
                            }
                        }
                    }
                }

                Button{
                    id: jenkinsUrlChooserField
                    width: units.gu(32)
                    color: UbuntuColors.warmGrey
                    iconName: "find"
                    text: i18n.tr("Choose Target Jenkins...")
                    onClicked:  {
                        PopupUtils.open(jenkinsUrlChooser, jenkinsUrlChooserField)
                    }
                }

                /*
                ActivityIndicator {
                   id: loadingJobListActivity
                }
                */


                Button {
                    id:loadJobsButton
                    width: units.gu(12)
                    text: i18n.tr("Load jobs")
                    onClicked: {                       

                        if(! Utility.isInputTextEmpty(jenkinUrlText.text)){

                            loadingJobListActivity.running = !loadingJobListActivity.running //start

                            modelListJobs.clear();
                            JobsRestClient.getJobList(jenkinUrlText.text)
                            filterJobField.enabled = true;
                            autoRefresh.enabled = true;
                            lastCheckLabel.text = i18n.tr("Last check: ") + Qt.formatDateTime(new Date(), "dd MMMM yyyy HH:mm:ss")                          

                            loadingJobListActivity.running = !loadingJobListActivity.running  //stop
                        } else {
                            PopupUtils.open(invalidInputPopUp);
                        }
                    }
                }

                /* to refresh displayed jobs and status */
                Timer {
                    id: refreshJobsStatusTimer
                    interval: 120000;  //120 sec
                    running: false;
                    repeat: true
                    onTriggered: {
                        //console.log("Refresh jobs status at: "+ Qt.formatDateTime(new Date(), "dd MMMM yyyy HH:mm:ss"))

                        if(! Utility.isInputTextEmpty(jenkinUrlText.text)){

                            loadingJobListActivity.running = !loadingJobListActivity.running //start

                            modelListJobs.clear();
                            JobsRestClient.getJobList(jenkinUrlText.text)
                            lastCheckLabel.text = i18n.tr("Last check: ") + Qt.formatDateTime(new Date(), "dd MMMM yyyy HH:mm:ss")
                            lastCheckLabel.visible = true;

                            loadingJobListActivity.running = !loadingJobListActivity.running  //stop
                        } else {
                            PopupUtils.open(invalidInputPopUp);
                        }
                    }
                }
            }

            Row{
                id: jenkinUrlRow
                /* Display the full Jenkins URL */
                Text {
                    id: jenkinUrlText
                    font.pointSize: units.gu(1.2)
                }

                ActivityIndicator {
                   id: loadingJobListActivity
                }
            }
        }
