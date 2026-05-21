import QtQuick

import Muse.Ui
import Muse.UiComponents

StyledToolBarView {
    id: stub

    property bool isEmpty: true

// Fixme: There needs to be some way to determine if we are on iOS.
// Sure, we could have another qml file for iOS, but that requires keeping
// things in sync if there are other changes to other files.
//     color: ui.theme.backgroundPrimaryColor

    visible: false

    StyledTextLabel {
        anchors.centerIn: parent
        text: "ExtensionsToolBar Stub"
    }
}
