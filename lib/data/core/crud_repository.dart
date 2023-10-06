abstract class CrudRepository<Output, CreateInput, UpdateInput, EntityId> {
  Future<Output> createOne(CreateInput createInput);
  Future<List<Output>> createMultiples(List<CreateInput> list);
  Future<Output?> getOneById(EntityId id);
  Future<List<Output>> getAll(
      {required int limit, required int page}); // Default -1, page 1
  Future<List<Output>> getAllByIds(List<EntityId> ids);
  Future<void> deleteByIds(List<EntityId> ids);
  Future<Output> updateOne(UpdateInput updateInput, EntityId currentId);
  Future<void> deleteOneById(EntityId id);
  Future<void> deleteAll();
}
