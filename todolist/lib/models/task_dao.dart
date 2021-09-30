import 'dart:async';
import 'package:floor/floor.dart';
import 'package:todolist/models/task.dart';

@dao
abstract class TaskDao {
  @Query('select * from Task where id = :id')
  Future<Task?> find_one(int id);

  @Query('select * from Task')
  Future<List<Task>> find_all();

  @Query('select * from Task where listid = :listid')
  Future<List<Task>> find_match(int listid);

  @Query('select * from Task where listid = :listid')
  Stream<List<Task>> find_match_stream(int listid);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insert_one(Task task);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insert_all(List<Task> tasks);

  @update
  Future<void> update_one(Task task);

  @update
  Future<void> update_all(List<Task> tasks);

  @delete
  Future<void> delete_one(Task task);

  @delete
  Future<void> delete_all(List<Task> tasks);
}