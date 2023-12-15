abstract class DatabaseOperationRepository<Output, CreateInput, UpdateInput,
    EntityId> {
  Future<Output> createOne(CreateInput createInput);
  Future<List<Output>> createMultiples(List<CreateInput> list);
  Future<Output?> getOneById(EntityId id);
  Future<List<Output>> getAll({
    required int limit,
    required int page,
  }); // Default -1, page 1
  Future<List<Output>> getAllByIds(List<EntityId> ids);
  Future<void> deleteByIds(List<EntityId> ids);
  Future<void> updateByIds(List<UpdateInput> entities);
  Future<Output?> updateOne(UpdateInput updateInput);
  Future<void> deleteOneById(EntityId id);
  Future<void> deleteAll();
}
