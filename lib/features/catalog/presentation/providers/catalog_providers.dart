import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_id/core/network/network_providers.dart';
import 'package:student_id/core/utils/failure_message.dart';
import 'package:student_id/features/catalog/data/repositories/catalog_repository_impl.dart';
import 'package:student_id/features/catalog/domain/entities/zone.dart';
import 'package:student_id/features/catalog/domain/enums/catalog_enums.dart';
import 'package:student_id/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:student_id/features/catalog/domain/usecases/get_catalog_items_usecase.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>(
  (ref) => CatalogRepositoryImpl(ref.watch(remoteDataStoreProvider)),
);

final getCatalogItemsUseCaseProvider = Provider<GetCatalogItemsUseCase>(
  (ref) => GetCatalogItemsUseCase(ref.watch(catalogRepositoryProvider)),
);

class CatalogQuery {
  final ListType listType;
  final String lookupId;

  const CatalogQuery({required this.listType, this.lookupId = ''});

  @override
  bool operator ==(Object other) {
    return other is CatalogQuery &&
        other.listType == listType &&
        other.lookupId == lookupId;
  }

  @override
  int get hashCode => Object.hash(listType, lookupId);
}

final catalogItemsProvider =
    FutureProvider.family<List<Zones>, CatalogQuery>((ref, query) async {
  final result = await ref.read(getCatalogItemsUseCaseProvider).call(
        query.listType,
        lookupId: query.lookupId,
      );
  return result.fold(
    (failure) => throw Exception(failureMessage(failure)),
    (zones) => zones,
  );
});
