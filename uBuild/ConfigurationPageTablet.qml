import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0

/* replace the 'incomplete' QML API U1db with the low-level QtQuick API */
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.ListItems 1.3 as ListItem

import "Storage.js" as Storage

Column{
    id: appConfigurationTablet

    anchors.fill: parent
    spacing: units.gu(3.5)
    anchors.leftMargin: units.gu(2)

    Component{
       id: invalidInputDialog
       InvalidInputPopUp{}
    }

    Component{
        id:noDataFoundDialog
        NoDataFoundDialog{}
    }

    Component{
       id: operationSuccessDialog
       OperationSuccessResult{}
    }

    /* transparent placeholder: required to place the content under the header */
    Rectangle {
        color: "transparent"
        width: parent.width
        height: units.gu(6)
    }    

    Row{
         id: headerCurrencyRow
         Label{
             text: "<b>"+i18n.tr("Add a new Jenkins")+"</b>"
         }
    }

    Row{
        id: jenkinsUrlRow
        spacing: units.gu(5)

        Label {
            id: jenkinsDisplayNameLabel
            anchors.verticalCenter: jenkinsDisplayNameText.verticalCenter
            text: "* "+i18n.tr("Display Name:")
        }

        TextField {
            id: jenkinsDisplayNameText
            placeholderText: ""
            echoMode: TextInput.Normal
            readOnly: false         
            width: units.gu(25)
        }

        Label {
            id: jenkinsUrlLabel
            anchors.verticalCenter: jenkinsUrlText.verticalCenter
            text: "* "+i18n.tr("URL:")
        }

        TextField {
            id: jenkinsUrlText
            placeholderText: ""
            echoMode: TextInput.Normal
            readOnly: false
            width: units.gu(45)
        }

        Button{
            id: insertNewJenkinsUrlButton
            width: units.gu(14)
            text: i18n.tr("Save")
            onClicked: {
                if(jenkinsDisplayNameText.text.length > 0 && jenkinsUrlText.text.length > 0)
                {
                  Storage.insertNewJenkins(jenkinsDisplayNameText.text,jenkinsUrlText.text)                 

                  jenkinsDisplayNameText.text = "";
                  jenkinsUrlText.text = "";

                  Storage.loadAllJenkinsUrl(); //refresh url chooser combo

                  PopupUtils.open(operationSuccessDialog);

                } else {
                   PopupUtils.open(invalidInputDialog);
                }
            }
        }

        Label {
            id: fieldRequiredLabel
            anchors.verticalCenter: insertNewJenkinsUrlButton.verticalCenter
            text: "* "+i18n.tr("Field required")
        }
    }

    Row{
        spacing: units.gu(3)
        x: insertNewJenkinsUrlButton.x

        Button{
            id: showSavedJenkinsUrlButton
            width: units.gu(14)
            text: i18n.tr("Show")
            onClicked: {
                Storage.loadAllJenkinsUrlForEditing();

                if(savedJenkinsUrlListModel.count == 0)
                    PopupUtils.open(noDataFoundDialog);
                else
                    pageStack.push(savedJenkinsUrlPage);
            }
        }

        Button{
            id: insertDefaultJenkinsUrlButton
            width: units.gu(14)
            text: i18n.tr("Load Default")           
            onClicked: {

                if (Storage.insertDefaultJenkinsUrl()){

                    Storage.loadAllJenkinsUrl();  //refresh
                    settings.defaultDataImported = true
                    PopupUtils.open(operationSuccessDialog);
                } else {
                    //import already done
                }
            }
        }        
    }   

}

