import 'dart:async';
import 'task.dart';
import 'package:floor/floor.dart';

@dao
abstract class TaskDao {
  @Query('select * from task where id = :id')
  Future<Task?> findTaskById(int id) ;

  @Query('select * from task')
  Future<List<Task>> findAllTask();

  @Query('select * from task')
  Stream<List<Task>> findAllTasksAsStream();

  @insert
  Future<void> insertTask(Task task);

  @insert
  Future<void> insertTasks(List<Task> tasks);

  @update
  Future<void> updateTask(Task task);

  @update
  Future<void> updateTasks(List<Task> tasks);

  @delete
  Future<void> deleteTask(Task task);

  @delete
  Future<void> deleteTasks(List<Task> tasks);
}