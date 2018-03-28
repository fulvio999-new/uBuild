import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3



/* General info about the application */
Dialog {
       id: aboutProductDialogue
       title: i18n.tr("Product Info")
       text: "uBuild: version "+rootPage.appVersion+"<br> Author: fulvio <br>"+i18n.tr("A Simple Read-only monitor for your favourite Jenkins")

       Button {
           text: i18n.tr("Close")
           onClicked: PopupUtils.close(aboutProductDialogue)
       }
}
