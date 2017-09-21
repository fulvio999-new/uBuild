TEMPLATE = aux
TARGET = uBuild

RESOURCES += \
    ubuild.qrc

QML_FILES += $$files(*.qml,true) \
             $$files(*.js,true)  \
             $$files(*.png,true) \
             $$files(*.gif,true)

CONF_FILES +=  uBuild.apparmor \
               uBuild.png

AP_TEST_FILES += tests/autopilot/run \
                 $$files(tests/*.py,true)               

OTHER_FILES += $${CONF_FILES} \
               $${QML_FILES} \
               $${AP_TEST_FILES} \
               uBuild.desktop


#specify where the qml/js files are installed to
qml_files.path = /uBuild
qml_files.files += $${QML_FILES}

#specify where the config files are installed to
config_files.path = /uBuild
config_files.files += $${CONF_FILES}

#install the desktop file, a translated version is 
#automatically created in the build directory
desktop_file.path = /uBuild
desktop_file.files = $$OUT_PWD/uBuild.desktop
desktop_file.CONFIG += no_check_exist

INSTALLS+=config_files qml_files desktop_file

DISTFILES += \
    JobsRestClient.js \
    BuildQueueRestClient.js \
    JobListDelegate.qml \
    HighlightComponent.qml \
    JobDetailsTablet.qml \
    JobDetailsPhone.qml \
    ConfigurationPageTablet.qml \
    ConfigurationPagePhone.qml \
    JobsRestClientDebug.js \
    Storage.js \
    InvalidInputPopUp.qml \
    OperationSuccessResult.qml \
    Settings.qml \
    AboutProductDialog.qml \
    DataBaseEraserDialog.qml \
    JenkinsUrlDelegate.qml \
    HighlightJenkinsUrlComponent.qml \
    NoDataFoundDialog.qml \
    NodesRestClient.js \
    JobsMainPageTablet.qml \
    JobsMainPagePhone.qml
