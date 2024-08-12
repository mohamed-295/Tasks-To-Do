abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppGetDatabaseStateSuccess extends AppStates {}
class AppGetInsertDatabaseStateSuccess extends AppStates {}
class AppErrorDatabaseState extends AppStates {
  final String error;
  AppErrorDatabaseState(this.error);
}
