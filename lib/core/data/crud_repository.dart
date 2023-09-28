/// O is the output, I is the Input, Id is just identifier
abstract class CrudRepository<O, I, Id> {
  Future<O> createOne(I entity);
  Future<O?> getOneById(Id id);
  Future<List<O>> getAll({int limit = -1, int page = 1});
  Future<List<O>> getAllByIds(List<Id> ids);
  Future<void> deleteByIds(List<Id> ids);
  Future<O> updateOne(I newEntity, Id currentId);
  Future<void> deleteOneById(Id id);
  Future<void> deleteAll();
}
