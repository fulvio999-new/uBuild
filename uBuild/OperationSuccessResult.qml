import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3


/* Notify an operation executed successfully */
Dialog {
    id: operationSuccessDialog

    property string msg;
    title: i18n.tr("Operation Result")

    Label{
        text: i18n.tr("Operation executed Successfully")
        color: UbuntuColors.green
    }

    Button {
        text: "Close"
        onClicked:
            PopupUtils.close(operationSuccessDialog)
    }
}
