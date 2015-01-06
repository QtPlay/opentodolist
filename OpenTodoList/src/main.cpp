/*
 *  OpenTodoList - A todo and task manager
 *  Copyright (C) 2014 - 2015 Martin Höher <martin@rpdev.net>
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <QDir>
#include <QQmlEngine>
#include <QQmlContext>
#include <QCommandLineParser>

#include <iostream>

#include "systemintegration/application.h"

using namespace OpenTodoList;

int startService( int &argc, char *argv[] ) {
  SystemIntegration::Application *app = qobject_cast< SystemIntegration::Application* >( qApp );
  if ( !app ) {
    app = new SystemIntegration::Application( argc, argv );
  }
  app->prepare();

  if ( app->instance()->state() ==
       OpenTodoList::SystemIntegration::ApplicationInstance::InstanceIsSecondary ) {
    return 1;
  }
  return 0;
}

int stopService() {
  if ( qApp ) {
    delete qApp;
    return 0;
  }
  return 1;
}

int startApp() {
  SystemIntegration::Application *app = qobject_cast< SystemIntegration::Application* >( qApp );
  if ( app ) {
    return app->exec();
  }
  return 1;
}

void showWindow() {
  SystemIntegration::Application *app = qobject_cast< SystemIntegration::Application* >( qApp );
  if ( app ) {
    app->showWindow();
  }
}

void hideWindow() {
  SystemIntegration::Application *app = qobject_cast< SystemIntegration::Application* >( qApp );
  if ( app ) {
    app->hideWindow();
  }
}

int main(int argc, char *argv[])
{
  QCoreApplication::setApplicationName( "OpenTodoList" );
  QCoreApplication::setApplicationVersion( VERSION );
  QCoreApplication::setOrganizationDomain( "www.rpdev.net" );
  QCoreApplication::setOrganizationName( "RPdev" );

  SystemIntegration::Application *app = new SystemIntegration::Application( argc, argv );

  QCommandLineOption startInBackgroundOption( { "B", "startInBackground" },
                                              QCoreApplication::translate(
                                                "main",
                                                "Start service but do not show the user interface" ) );
  QCommandLineOption helpOption( { "h", "help" },
                                 QCoreApplication::translate(
                                   "main",
                                   "Shows the build in help" ) );
  QCommandLineOption versionOption( "version",
                                    QCoreApplication::translate(
                                      "main",
                                      "Shows the application version" ) );
  QCommandLineParser parser;
  parser.addOption( helpOption );
  parser.addOption( versionOption );
  parser.addOption( startInBackgroundOption );

  parser.process(*app);

  if ( parser.isSet( helpOption ) ) {
    std::cout << parser.helpText().toStdString();
    delete app;
    return 0;
  } else if ( parser.isSet( versionOption ) ) {
    std::cout << "OpenTodoList version " << VERSION << std::endl;
    delete app;
    return 0;
  } else {
    if ( startService( argc, argv ) == 0 ) {
      if ( !parser.isSet( startInBackgroundOption ) ) {
        showWindow();
      }
      int exitCode = startApp();
      stopService();
      return exitCode;
    }
  }
  return 1;
}
