#include "candrv.h"

#include <QDebug>

CanDrv::CanDrv(QObject *parent) : QObject(parent)
{
    QString errorString;
    m_canDevice = QCanBus::instance()->createDevice(
        QStringLiteral("socketcan"), QStringLiteral("can1"), &errorString);
    if (!errorString.isEmpty()) {
        // Error handling goes here
        qDebug() << errorString;
//        while(1);
    } else {

        // TODO: add CAN filter

        connect(m_canDevice, &QCanBusDevice::framesReceived, this, &CanDrv::processReceivedFrames);

        m_canDevice->connectDevice();
    }

    m_canData = {};
    m_canData.engineWaterTemperature = (double)0;
}

canData_t CanDrv::readCanData()
{
    return m_canData;
}

void CanDrv::processReceivedFrames()
{
    if (!m_canDevice)
        return;

    while (m_canDevice->framesAvailable()) {
        const QCanBusFrame frame = m_canDevice->readFrame();

        QString view;
        if (frame.frameType() == QCanBusFrame::ErrorFrame)
            view = m_canDevice->interpretErrorFrame(frame);
        else
            view = frame.toString();

        const QString time = QString::fromLatin1("%1.%2  ")
                .arg(frame.timeStamp().seconds(), 10, 10, QLatin1Char(' '))
                .arg(frame.timeStamp().microSeconds() / 1000, 3, 10, QLatin1Char('0'));

       // qDebug() << view;

        switch(frame.frameId()) {
        case FRAME_DATA_1:
            m_canData.engineWaterTemperature = (double)frame.payload()[0] / 2;
            m_canData.engineOilTemperature = (double)frame.payload()[1] / 2 - 10;
            m_canData.ambientTemperature = (double)frame.payload()[2] / 2 - 50;
            m_canData.airboxTemperature = (double)frame.payload()[3] / 2 - 50;
            m_canData.fuelTemperature = (double)frame.payload()[4] / 4;
            m_canData.batteryVoltage = (double)frame.payload()[5] / 20 + 6;
            m_canData.ambientPressure = (double)frame.payload()[6] / 4 + 80;
            break;
        case FRAME_DATA_2:
            m_canData.throttlePosition = (double)frame.payload()[0] / 2;
            m_canData.engineOilPressure = (double)frame.payload()[1] / 10 - 1;
            m_canData.fuelPressure = (double)frame.payload()[2] / 10;
            m_canData.engineSpeed = (unsigned)frame.payload()[3] * 50;
            m_canData.steeringAngle = (short)(frame.payload()[4] << 8) | (int)(frame.payload()[5]);
            m_canData.gear = (unsigned)frame.payload()[6];
            break;
        case FRAME_DATA_3:
            break;
        case FRAME_DATA_4:
            break;
        case FRAME_DATA_5:
            break;
        default:
            break;
        }

        emit newCanData();
    }
}

void CanDrv::mockCanData() {
    //qDebug() << "Test";

    m_canData.engineWaterTemperature += 0.1;

    // qDebug() << "mockCanData: " << m_canData.engineWaterTemperature;

    emit newCanData();
}
