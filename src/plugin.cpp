#include <QQmlEngine>
#include <QQmlExtensionPlugin>
#include "asusbackend.h"

class AsusArmouryPlugin : public QQmlExtensionPlugin {
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)
public:
    void registerTypes(const char *uri) override {
        qmlRegisterType<AsusBackend>(uri, 1, 0, "AsusBackend");
    }
};

#include "plugin.moc"
