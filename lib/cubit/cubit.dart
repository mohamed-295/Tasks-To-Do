import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  
  late Database database;
  List<Map> tasks = [];
  List<Map> doneTasks = [];
  List<Map> archieveTasks = [];

  void creatDatabase() async {
    database = await openDatabase('path.db', version: 1,
        onCreate: (database, version) async {
      print('database created');
      await database.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, status TEXT)');
      print('table created');
    }, onOpen: (database) async {
      print('database opened');
      getDataFromDatabase(database);
    });
  }

  Future insertToDatabase({
    required String title,
    required String time,
    required String date,
    required String status,
  }) async {
    await database.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO tasks(title, time, date, status) VALUES("$title","$time","$date","$status")')
          .then((value) {
        getDataFromDatabase(database);
        emit(AppGetInsertDatabaseStateSuccess());
      }).catchError((error) {
        emit(AppErrorDatabaseState(error.toString()));
      });
    });
  }

  void getDataFromDatabase(database) async {
    tasks.clear();
    doneTasks.clear();
    archieveTasks.clear();
    await database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((e) {
        if (e['status'] == 'status') {
          tasks.add(e);
        } else if (e['status'] == 'done') {
          doneTasks.add(e);
        } else if (e['status'] == 'archieve') {
          archieveTasks.add(e);
        }
      }
      );
      emit(AppGetDatabaseStateSuccess());
    });
  }

  void deleteDataFromDatabase(int id) async {
    await database
        .rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
    });
  }

  void updateDatabaseState(String status, int id) async {
    await database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      getDataFromDatabase(database);
      print(status);
    });
  }
}
