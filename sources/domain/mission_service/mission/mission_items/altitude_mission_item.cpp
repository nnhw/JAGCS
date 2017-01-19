#include "altitude_mission_item.h"

// Qt
#include <QDebug>

// Internal
#include "mission.h"

using namespace domain;

AltitudeMissionItem::AltitudeMissionItem(Mission* mission, Command command,
                                         bool relativeAltitude):
    MissionItem(mission, command),
    m_altitude(0),
    m_relativeAltitude(relativeAltitude)
{}

float AltitudeMissionItem::altitude() const
{
    return m_altitude;
}

float AltitudeMissionItem::absoluteAltitude() const
{
    if (!this->isRelativeAltitude() || this->sequence() == 0)
        return this->altitude();

    AltitudeMissionItem* home = qobject_cast<AltitudeMissionItem*>(
                   this->mission()->item(0));
    if (!home) return 0;

    return home->altitude() + this->altitude();
}

bool AltitudeMissionItem::isRelativeAltitude() const
{
    return m_relativeAltitude;
}

float AltitudeMissionItem::climb() const
{
    if (this->sequence() < 1) return 0;

    AltitudeMissionItem* previous = nullptr;
    for (uint8_t seq = this->sequence() - 1; seq >= 0 ; seq--)
    {
        previous = qobject_cast<AltitudeMissionItem*>(
                       this->mission()->item(seq));
        if (!previous) continue;

        return this->absoluteAltitude() - previous->absoluteAltitude();
    }
    return 0;
}

void AltitudeMissionItem::clone(MissionItem* mission)
{
    auto altitudeItem = qobject_cast<AltitudeMissionItem*>(mission);

    if (altitudeItem)
    {
        this->setAltitude(altitudeItem->altitude());
        this->setRelativeAltitude(altitudeItem->isRelativeAltitude());
    }

    MissionItem::clone(mission);
}

void AltitudeMissionItem::setAltitude(float altitude)
{
    if (qFuzzyCompare(m_altitude, altitude)) return;

    m_altitude = altitude;
    emit altitudeChanged(altitude);
}

void AltitudeMissionItem::setRelativeAltitude(bool relativeAltitude)
{
    if (m_relativeAltitude == relativeAltitude) return;

    m_relativeAltitude = relativeAltitude;
    emit relativeAltitudeChanged(relativeAltitude);
}