﻿import QtQuick 2.6

import "../Controls" as Controls

AttitudeIndicator {
    id: fd

    property bool guided: false

    property real yawspeed: 0.0
    property real desiredPitch: 0.0
    property real desiredRoll: 0.0

    Behavior on yawspeed { PropertyAnimation { duration: 100 } }
    Behavior on desiredPitch { PropertyAnimation { duration: 100 } }
    Behavior on desiredRoll { PropertyAnimation { duration: 100 } }

    RollScale {
        id: rollScale
        anchors.fill: parent
        roll: rollInverted ? -fd.roll : fd.roll
        minRoll: fd.minRoll
        maxRoll: fd.maxRoll
        rollStep: fd.rollStep
        opacity: enabled ? 1 : 0.33
        color: operational ? palette.textColor : palette.dangerColor
    }

    PitchScale {
        id: pitchScale
        anchors.centerIn: parent
        width: parent.width
        height: effectiveHeight
        roll: rollInverted ? 0 : fd.roll
        minPitch: pitchInverted ? fd.pitch + fd.minPitch : fd.minPitch
        maxPitch: pitchInverted ? fd.pitch + fd.maxPitch : fd.maxPitch
        pitchStep: fd.pitchStep
        opacity: enabled ? 1 : 0.33
        color: operational ? palette.textColor : palette.dangerColor
    }

    DesiredAnglesMark {
        id: desiredMark
        anchors.fill: parent
        anchors.margins: sizings.margins
        effectiveHeight: fd.effectiveHeight
        visible: guided
        pitch: pitchInverted ? fd.pitch - desiredPitch : -desiredPitch
        roll: rollInverted ? -desiredRoll : fd.roll - desiredRoll
    }

    TurnIndicator {
        id: turn
        anchors.fill: parent
        value: yawspeed
    }

    Controls.Label {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -height
        text: qsTr("DISARMED")
        font.pixelSize: fd.height * 0.1
        font.bold: true
        color: armed ? "transparent" : palette.dangerColor
    }

    PlaneMark {
        id: mark
        anchors.fill: parent
        anchors.margins: sizings.margins
        effectiveHeight: fd.effectiveHeight
        pitch: pitchInverted ? 0 : -fd.pitch
        roll: rollInverted ? -fd.roll : 0
        markColor: armed ? palette.selectedTextColor : palette.dangerColor
    }
}
