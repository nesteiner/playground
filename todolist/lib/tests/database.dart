import 'dart:async';
import 'task.dart';
import 'task_dao.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 1, entities: [Task])
abstract class FlutterDataBase extends FloorDatabase {
  TaskDao get taskDao;
}