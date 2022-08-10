import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
class MyProvider with ChangeNotifier{
  bool isDark=false;
  changeMode(){
    isDark=!isDark;
    notifyListeners();
  }
   DateTime selectedDate = DateTime.now();
  changeSelectedDate(newDate){
    selectedDate=newDate;
    notifyListeners();
  }
  List<Map>tasks=[];
  Database? database;
  void createDataBase()async{
    database=await openDatabase(
        'todo.db',
        version: 1,
        onCreate: (dataBase,version){
          dataBase.execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,note TEXT,date TEXT,sTime TEXT,eTime TEXT,status TEXT)'
          ).then((value) {
          }).catchError((e){
            print('Error when creating table ${e.toString()}');
          });
        },
        onOpen: (dataBase){
          getDataFromDatabase(dataBase).then((value){
            tasks=value;
          });

        }
    );
    notifyListeners();
  }
   insertToDataBase(
      {
        required String title,
        required String note,
        required String date,
        required String sTime,
        required String eTime,
      }
      )async{
    notifyListeners();
     await database!.transaction((txn)async{
      txn.rawInsert(
          'INSERT INTO tasks (title,note,date,sTime,eTime,status) VALUES("$title","$note","$date","$sTime","$eTime","TO DO")'
      ).then((value){

        getDataFromDatabase(database).then((value){
          tasks=value;
        });
      }).catchError((e){
        print('Error when Inserting new Record ${e.toString()}');
      });
      return ;
    });

  }
  Future<List<Map>> getDataFromDatabase(database)async{
    notifyListeners();
    return await database!.rawQuery(
        'SELECT *FROM tasks'
    );
  }

  void updateData({
  required String status,
    required int id,
})async{
    notifyListeners();
    database!.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ? ',
      [status,id]
    ).then((value){
    getDataFromDatabase(database).then((value){
      tasks=value;
    });
    });
  }
  void deleteData({
    required int id,
  })async{
    notifyListeners();
    database!.rawDelete(
      'DELETE FROM tasks WHERE id=?',[id]
    ).then((value){
      getDataFromDatabase(database).then((value){
        tasks=value;
      });
    });
  }

}