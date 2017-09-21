import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3


/* Notify no data found */
Dialog {
    id: operationDialog

    property string msg;
    title: i18n.tr("Operation Result")

    Label{
        text: i18n.tr("No saved Jenkins url found to display")
        color: UbuntuColors.red
    }

    Button {
        text: "Close"
        onClicked:
            PopupUtils.close(operationDialog)
    }
}
