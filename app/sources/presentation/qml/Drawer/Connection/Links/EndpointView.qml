import QtQuick 2.6
import QtQuick.Layouts 1.3

import Industrial.Controls 1.0 as Controls

RowLayout {
    id: root

    property string endpoint

    signal remove()
    signal changed(string endpoint)

    function updateEdits() {
        var split = endpoint.split("/");

        address.text = split.length > 0 ? split[0] : ""
        port.text = split.length > 1 ? split[1] : ""
    }

    function updateEndpoint() {
        changed(address.text + "/" + port.text);
    }

    onEndpointChanged: updateEdits()

    spacing: sizings.spacing

    Controls.NumericInput {
        id: address
        horizontalAlignment: Text.AlignHCenter
        validator: RegExpValidator {
            regExp: /^(([01]?[0-9]?[0-9]|2([0-4][0-9]|5[0-5]))\.){3}([01]?[0-9]?[0-9]|2([0-4][0-9]|5[0-5]))$/
        }
        onFinished: updateEndpoint()
        Layout.fillWidth: true
    }

    Controls.NumericInput {
        id: port
        horizontalAlignment: Text.AlignHCenter
        validator: IntValidator { bottom: 0; top: 65535 }
        inputMethodHints: Qt.ImhDigitsOnly
        onFinished: updateEndpoint()
        Layout.fillWidth: true
    }

    Controls.Button {
        flat: true
        tipText: qsTr("Remove")
        iconSource: "qrc:/icons/remove.svg"
        iconColor: customPalette.dangerColor
        onClicked: remove()
    }
}

