import 'package:my_notes/core/data/crud_repository.dart';

abstract class LocalDatabaseRepository<O, I, Id>
    implements CrudRepository<O, I, Id> {
  Future<void> initialize();
  Future<void> close();
  bool get isInitialized;
}
