#include "asusbackend.h"
#include <QDebug>
#include <QStringList>

AsusBackend::AsusBackend(QObject *parent) : QObject(parent), m_fanMode("Auto") {
    refreshStatus();
}

QString AsusBackend::runCommand(const QString &program, const QStringList &args) {
    QProcess p;
    p.start(program, args);
    p.waitForFinished(1500);
    QString output = QString(p.readAllStandardOutput()) + " " + QString(p.readAllStandardError());
    return output.trimmed();
}

void AsusBackend::refreshStatus() {
    // --- 1. Get Performance Mode ---
    QString profOutput = runCommand("asusctl", {"profile", "get"});
    m_performanceMode = "Unknown";
    
    QStringList lines = profOutput.split('\n');
    for (const QString &line : lines) {
        if (line.contains("Active profile", Qt::CaseInsensitive)) {
            if (line.contains("Quiet", Qt::CaseInsensitive)) m_performanceMode = "Quiet";
            else if (line.contains("Balanced", Qt::CaseInsensitive)) m_performanceMode = "Balanced";
            else if (line.contains("Performance", Qt::CaseInsensitive)) m_performanceMode = "Performance";
            break;
        }
    }
    emit performanceModeChanged();

    // --- 2. Get GPU Mode ---
    QString gpuOutput = runCommand("supergfxctl", {"-g"});
    if (gpuOutput.contains("Hybrid", Qt::CaseInsensitive)) m_gpuMode = "Hybrid";
    else if (gpuOutput.contains("Integrated", Qt::CaseInsensitive)) m_gpuMode = "Integrated";
    else if (gpuOutput.contains("AsusMuxDgpu", Qt::CaseInsensitive) || gpuOutput.contains("Dedicated", Qt::CaseInsensitive)) m_gpuMode = "Dedicated";
    else m_gpuMode = gpuOutput;
    emit gpuModeChanged();

    // --- 3. Update Timestamp ---
    m_lastUpdate = QDateTime::currentDateTime();
    emit updateTimeChanged();
}

void AsusBackend::setPerformanceMode(const QString &mode) {
    runCommand("asusctl", {"profile", "set", mode});
    refreshStatus();
}

void AsusBackend::setGpuMode(const QString &mode) {
    QString cmdMode = mode;
    if (mode == "Dedicated") cmdMode = "AsusMuxDgpu";
    runCommand("supergfxctl", {"-m", cmdMode});
    refreshStatus();
}

void AsusBackend::setFanMode(const QString &mode) {
    // Allows UI tracking for Fan Control 
    m_fanMode = mode;
    emit fanModeChanged();
}

QString AsusBackend::currentPerformanceMode() const { return m_performanceMode; }
QString AsusBackend::currentGpuMode() const { return m_gpuMode; }
QString AsusBackend::currentFanMode() const { return m_fanMode; }
int AsusBackend::secondsSinceUpdate() const { 
    return m_lastUpdate.secsTo(QDateTime::currentDateTime()); 
}
