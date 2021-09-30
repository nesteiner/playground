import 'package:floor/floor.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/models/tasklist.dart';

@dao
abstract class TaskListDao {
  @Query('select * from TaskList')
  Future<List<TaskList>> find_all();

  @Query('select * from TaskList')
  Stream<List<TaskList>> find_all_stream();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insert_one(TaskList tasklist);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insert_all(List<TaskList> tasklist);

  @update
  Future<void> update_one(TaskList tasklist);

  @update
  Future<void> update_all(List<TaskList> tasklists);

  @delete
  Future<void> delete_one(TaskList tasklist);

  @delete
  Future<void> delete_all(List<TaskList> tasklists);
}