import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

/* to replace the 'incomplete' QML API U1db with the low-level QtQuick API */
import QtQuick.LocalStorage 2.0
import "Storage.js" as Storage


/* Show a Dialog where the user can choose to delete ALL the saved expense */
Dialog {
    id: dataBaseEraserDialog
    text: "<b> "+i18n.tr("Remove ALL Saved Jenkins URL ?")+" <br/>"+i18n.tr("(there is no restore)")+"</b>"

    Rectangle {
        width: 180;
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
                        onClicked: PopupUtils.close(dataBaseEraserDialog)
                    }

                    Button {
                        id: importButton
                        text: i18n.tr("Delete")
                        color: UbuntuColors.orange
                        onClicked: {

                            Storage.deleteAllJenkinsUrl();

                            deleteOperationResult.color = UbuntuColors.green
                            deleteOperationResult.text = i18n.tr("Succesfully Removed ALL data")
                            closeButton.enabled = true

                            settings.defaultDataImported = false
                            modelListJobs.clear();
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
