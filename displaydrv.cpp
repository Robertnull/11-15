#include "displaydrv.h"

#include <QDebug>

bool inRange(double low, double high, double x);

DisplayDrv::DisplayDrv(QObject *parent) : QObject(parent)
{
    m_canData = {};
    m_displayData.gear = "N";
    m_displayData.page = 0;
    m_displayData.rev = 0;
    m_displayData.grid = {0, 0, 0, 0, 0, 0, 0, 0};
//    m_displayData.grid = {100, 90, 3.5, 5.5, 50, 4000, 50, 50}; // Test
    m_displayData.limit = {false, false, false, false, false, false, false, false};
    m_displayLabels.gridLabel = {"Water Temp", "Oil Temp", "Amb Temp", "Airbox Temp",
                              "Fuel Temp", "Oil Pres", "Amb Pres", "Fuel Pres"};
}

displayData_t DisplayDrv::readDisplayData()
{
    return m_displayData;
}

displayLabels_t DisplayDrv::readDisplayLabels()
{
    return m_displayLabels;
}


void DisplayDrv::setCanData(canData_t canData)
{
    m_canData = canData;

    switch (m_canData.displaySetting) {
    case 0:
        m_displayData.page = 0;
        m_displayData.grid[0] = m_canData.engineWaterTemperature;
        m_displayData.grid[1] = m_canData.engineOilTemperature;
        m_displayData.grid[2] = m_canData.engineOilPressure;
        m_displayData.grid[3] = m_canData.fuelPressure;
        m_displayData.grid[4] = m_canData.throttlePosition;
        m_displayData.grid[5] = m_canData.engineSpeed;
        m_displayData.grid[6] = m_canData.brakePressureFront;
        m_displayData.grid[7] = m_canData.brakePressureRear;

        // Limit checks
        // TODO: not the ideal place for this. CanDrv instead?
        m_displayData.limit[0] = !inRange(20, 90, m_canData.engineWaterTemperature);
        m_displayData.limit[1] = !inRange(20, 110, m_canData.engineOilTemperature);
        m_displayData.limit[2] = !inRange(1.0, 4.5, m_canData.engineOilPressure);
        m_displayData.limit[3] = !inRange(5.0, 6.0, m_canData.fuelPressure);
        m_displayData.limit[4] = !inRange(8, 100, m_canData.throttlePosition);
        m_displayData.limit[5] = !inRange(-1, 11000, m_canData.engineSpeed);
        m_displayData.limit[6] = !inRange(3, 60, m_canData.brakePressureFront);
        m_displayData.limit[7] = !inRange(3, 60, m_canData.brakePressureRear);
        break;
    case 1:
        break;
    default:
        break;
    }

    m_displayData.rev = m_canData.engineSpeed;

    // qDebug() << "setCanData: " << m_displayData.grid[0];

    emit newDisplayData();
}

// Returns true if x is in range [low..high], else false
bool inRange(double low, double high, double x)
{
    return (low <= x && x <= high);
}
