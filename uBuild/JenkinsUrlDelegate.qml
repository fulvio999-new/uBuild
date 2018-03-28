
import QtQuick 2.0
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3

import QtQuick.LocalStorage 2.0
import "Storage.js" as Storage
import "utility.js" as Utility

/*
  Display a seved Jenkins url with his Alias and offer the operations to manage it: edit, delete
*/

    Item {
        id: jenkinsUrlListDelegate

        width: configurationPage.width
        height: units.gu(13) /* the heigth of the rectangular container */
        visible: true;

        /* create a container for each category */
        Rectangle {
            id: background
            x: 2; y: 2; width: parent.width - x*2; height: parent.height - y*1
            border.color: "grey"
            radius: 5
        }

        Component{
           id: invalidInputPopUp
           InvalidInputPopUp{msg:i18n.tr("Display name or url")}
        }

        Component{
           id: operationSuccessResult
           OperationSuccessResult{}
        }

        /* Confirm Dialog before delete a Jenkins url */
        Component {
            id: confirmDeleteUrlComponent

            Dialog {
                id: confirmDeleteUrlDialog
                text: "<b>"+i18n.tr("Remove selected Jenkins URL ?")+ "<br/>"+i18n.tr("(there is no restore)")+"</b>"

                Rectangle {
                    width: jenkinsUrlListDelegate.width;
                    height: 50
                    Item{
                        Column{
                            spacing: units.gu(1)

                            Row{
                                spacing: units.gu(1)

                                /* placeholder */
                                Rectangle {
                                    color: "transparent"
                                    width: units.gu(3)
                                    height: units.gu(3)
                                }

                                Button {
                                    id: closeButton
                                    text: i18n.tr("Close")
                                    onClicked: PopupUtils.close(confirmDeleteUrlDialog)
                                }

                                Button {
                                    id: importButton
                                    text: i18n.tr("Delete")
                                    color: UbuntuColors.orange
                                    onClicked: {

                                        /* 'jenkins_url_id' is a field loaded from the database but not shown in the UI */
                                        var jenkinsUrlIdToDelete = savedJenkinsUrlListModel.get(savedJenkinsListView.currentIndex).jenkins_url_id;
                                        Storage.deleteJenkinsUrl(jenkinsUrlIdToDelete);

                                        deleteOperationResult.text = i18n.tr("Operation executed successfully")
                                        Storage.loadAllJenkinsUrl(); //refresh combo
                                        Storage.loadAllJenkinsUrlForEditing();

                                        /* if all urls are deleted. User can re-import default ones */
                                        if(savedJenkinsUrlListModel.count == 0)
                                           settings.defaultDataImported = false
                                    }
                                }
                            }

                            Row{
                                Label{
                                    id: deleteOperationResult
                                }
                            }
                        }
                    }
                }
           }
        }


        MouseArea {
            id: selectableMouseArea
            anchors.fill: parent    /* MouseArea covers the entire delegate Item */

            onClicked: {
                /* move the highlight component to the currently selected Row */
                savedJenkinsListView.currentIndex = index
            }
        }

        /* create a Row for each entry in the Model */
        Row {
            id: topLayout
            x: 10; y: 1; height: background.height; width: parent.width

            Column {
                id: containerColumn
                width: background.width - manageUrlColumn.width
                height: jenkinsUrlListDelegate.height
                spacing: units.gu(1)

                Rectangle {
                    id: placeholder
                    color: "transparent"
                    width: parent.width
                    height: units.gu(0.5)
                }

                Row{
                    id:displayNameRow
                    spacing: units.gu(1)
                    Label {
                        id: displayNameLabel
                        anchors.verticalCenter: displayNameTextField.verticalCenter
                        text: i18n.tr("Display name:")
                        font.bold: true
                    }

                    TextField {
                        id: displayNameTextField
                        text:  display_name
                        height: units.gu(4)
                        width: Utility.getTextFieldWidth();
                        enabled: false
                        //focus: true
                    }
                }

                Row{
                    id:urlRow
                    spacing: displayNameLabel.text.length
                    Label {
                        anchors.verticalCenter: urlTextField.verticalCenter
                        text: i18n.tr("URL:")
                        font.bold: true
                    }

                    TextField {
                        id: urlTextField
                        x:displayNameTextField.x
                        text: url
                        height:units.gu(4)
                        width: Utility.getTextFieldWidth(); // jenkinsUrlListDelegate.width - units.gu(7); // units.gu(url.length)
                        enabled: false
                    }
                }
            }


            Column{
                id: manageUrlColumn
                height: parent.height
                width: units.gu(7);
                spacing: units.gu(1)

                Rectangle {
                    id: placeholder2
                    color: "transparent"
                    width: parent.width
                    height: units.gu(0.1)
                }

                Row{
                    id:deleteUrlRow
                    Icon {
                        id: deleteUrlIcon
                        width: units.gu(3)
                        height: units.gu(3)
                        name: "delete"

                        MouseArea {
                            width: deleteUrlIcon.width
                            height: deleteUrlIcon.height
                            onClicked: {
                                PopupUtils.open(confirmDeleteUrlComponent);
                            }
                        }
                    }
                }

                Row{
                    id:editUrlRow
                    Icon {
                        id: editUrlIcon
                        width: units.gu(3)
                        height: units.gu(3)
                        name: "edit"

                        MouseArea {
                            width: editUrlIcon.width
                            height: editUrlIcon.height
                            onClicked: {
                                displayNameTextField.enabled = true
                                urlTextField.enabled = true
                                saveUrlRow.visible = true
                            }
                        }
                    }
                }


                Row{
                    id:saveUrlRow
                    visible: false
                    Icon {
                        id: editUrlIcon2
                        width: units.gu(3)
                        height: units.gu(3)
                        name: "save"

                        MouseArea {
                            width: editUrlIcon.width
                            height: editUrlIcon.height
                            onClicked: {

                                /* 'jenkins_url_id' is a field loaded from the database but not shown in the UI */
                                var jenkinsUrlId = savedJenkinsUrlListModel.get(savedJenkinsListView.currentIndex).jenkins_url_id;

                                if(Utility.isInputTextEmpty(displayNameTextField.text) || Utility.isInputTextEmpty(urlTextField.text))
                                {
                                   PopupUtils.open(invalidInputPopUp);
                                }else {
                                    //console.log("Updating Jenkins url with id: "+jenkinsUrlId+" Display name:"+ displayNameTextField.text+ " URL: "+urlTextField.text);
                                    Storage.updateJenkins(jenkinsUrlId,displayNameTextField.text,urlTextField.text);

                                    displayNameTextField.enabled = false
                                    urlTextField.enabled = false
                                    saveUrlRow.visible = false

                                    /* refresh model for the url chooser popup button */
                                    Storage.loadAllJenkinsUrl();
                                    Storage.loadAllJenkinsUrlForEditing();

                                    PopupUtils.open(operationSuccessResult);
                                }
                            }
                        }
                    }
                }

           }
     }

}
