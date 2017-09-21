import QtQuick 2.0


/*
 Used by the ListView in Configuration page to highlight the currently selected Jenkins Ulr in the Jobs List
*/
Component {
    id: highlightJenkinsUrlComponent

    Rectangle {
        width: 180; height: 44
        color: "blue";

        radius: 2
        /* move the Rectangle on the currently selected List item with the keyboard */
        y: savedJenkinsListView.currentItem.y

        /* show an animation on change ListItem selection */
        Behavior on y {
            SpringAnimation {
                spring: 5
                damping: 0.1
            }
        }
    }
}
