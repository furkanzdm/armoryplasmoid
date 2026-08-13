#pragma once
#include <QObject>
#include <QProcess>
#include <QString>
#include <QDateTime>

class AsusBackend : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString currentPerformanceMode READ currentPerformanceMode NOTIFY performanceModeChanged)
    Q_PROPERTY(QString currentGpuMode READ currentGpuMode NOTIFY gpuModeChanged)
    Q_PROPERTY(QString currentFanMode READ currentFanMode NOTIFY fanModeChanged)
    Q_PROPERTY(int secondsSinceUpdate READ secondsSinceUpdate NOTIFY updateTimeChanged)

public:
    explicit AsusBackend(QObject *parent = nullptr);

    Q_INVOKABLE void setPerformanceMode(const QString &mode);
    Q_INVOKABLE void setGpuMode(const QString &mode);
    Q_INVOKABLE void setFanMode(const QString &mode);
    
    Q_INVOKABLE void refreshStatus();

    QString currentPerformanceMode() const;
    QString currentGpuMode() const;
    QString currentFanMode() const;
    int secondsSinceUpdate() const;

signals:
    void performanceModeChanged();
    void gpuModeChanged();
    void fanModeChanged();
    void updateTimeChanged();

private:
    QString m_performanceMode;
    QString m_gpuMode;
    QString m_fanMode;
    QDateTime m_lastUpdate;
    
    QString runCommand(const QString &program, const QStringList &args);
};
