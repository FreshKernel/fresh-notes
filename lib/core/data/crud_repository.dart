/// O is the output, I is the Input for creating the note
/// I2 is the input for updating the note
/// Id is just identifier
abstract class CrudRepository<O, I, I2, Id> {
  Future<O> createOne(I createInput);
  Future<List<O>> createMultiples(List<I> list);
  Future<O?> getOneById(Id id);
  Future<List<O>> getAll(
      {required int limit, required int page}); // Default -1, page 1
  Future<List<O>> getAllByIds(List<Id> ids);
  Future<void> deleteByIds(List<Id> ids);
  Future<O> updateOne(I2 updateInput, Id currentId);
  Future<void> deleteOneById(Id id);
  Future<void> deleteAll();
}
