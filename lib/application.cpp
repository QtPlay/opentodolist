#include "application.h"

#include "locallibraryfactory.h"

#include <QCoreApplication>

/**
   @brief Constructor.
   
   Creates a new Application object. The instance will be a child of the given @p parent.
 */
Application::Application(QObject *parent) : QObject(parent),
  m_settings(new QSettings(QSettings::IniFormat, QSettings::UserScope,
                           QCoreApplication::organizationName(),
                           QCoreApplication::applicationName(), this)),
  m_loadingLibraries(false)
{
  Q_CHECK_PTR(m_settings);
  createFactories();
  loadLibraries();
}

Application::Application(QSettings *settings, QObject *parent) :
  QObject(parent),
  m_settings(settings),
  m_loadingLibraries(false)
{
  Q_CHECK_PTR(m_settings);
  createFactories();
  loadLibraries();
}

/**
   @brief Return the list of all library factory IDs.
   
   This method returns the list of all LibraryFactory IDs (cf LibraryFactory::id()) registered
   in the Application.
   
   @sa Application::libraryFactoryForType()
 */
QStringList Application::libraryTypes() const
{
  QStringList result;
  for (auto factory : m_libraryFactories) {
    result << factory->id();
  }
  result.sort();
  return result;
}

/**
   @brief Return the LibraryFactory for a given type of library.
   
   This method returns the LibraryFactory where the LibraryFactory::id() equals the
   given @p factoryId. If no such library is found, returns a nullptr.
   @param factoryId
   @return 
 */
LibraryFactory *Application::libraryFactoryForType(const QString &factoryId) const
{
  for (auto factory : m_libraryFactories) {
    if (factory->id() == factoryId) {
      return factory;
    }
  }
  return nullptr;
}

/**
   @brief Create a new library.
   
   This method creates a new library using the factory identified by the @p factoryId
   and passing it the @p args.
 */
Library *Application::addLibrary(const QString &factoryId,
                                 const QString &name,
                                 const QString &directory,
                                 const QVariantMap &args)
{
  auto factory = libraryFactoryForType(factoryId);
  if (factory) {
    auto library = factory->createLibrary(name, directory, args, this);
    if (library) {
      m_libraries.append(library);
      saveLibraries();
      return library;
    }
  }
  return nullptr;
}

void Application::createFactories()
{
  m_libraryFactories << new LocalLibraryFactory(this);
}

void Application::saveLibraries()
{
  if (!m_loadingLibraries) {
    m_settings->beginWriteArray("Library", m_libraries.size());
    for (int i = 0; i < m_libraries.size(); ++i) {
      m_settings->setArrayIndex(i);
      auto library = m_libraries.at(i);
      m_settings->setValue("name", library->name());
      m_settings->setValue("type", library->factory()->id());
      m_settings->setValue("directory", library->directory());
      m_settings->beginGroup("args");
      auto args = library->saveArgs();
      for (auto arg : args.keys()) {
        m_settings->setValue(arg, args.value(arg));
      }
      m_settings->endGroup();
    }
    m_settings->endArray();
  }
}

void Application::loadLibraries()
{
  m_loadingLibraries = true;
  for (auto library : m_libraries) {
    delete library;
  }
  int numLibraries = m_settings->beginReadArray("Library");
  for (int i = 0; i < numLibraries; ++i) {
    m_settings->setArrayIndex(i);
    QString name = m_settings->value("name").toString();
    QString type = m_settings->value("type").toString();
    QString directory = m_settings->value("directory").toString();
    QVariantMap args;
    m_settings->beginGroup("args");
    for (auto value : m_settings->childKeys()) {
      args["value"] = m_settings->value(value);
    }
    m_settings->endGroup();
    addLibrary(type, name, directory, args);
  }
  m_settings->endArray();
  m_loadingLibraries = false;
}


