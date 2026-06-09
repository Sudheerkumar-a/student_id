import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_id/core/network/network_providers.dart';
import 'package:student_id/features/visitors/data/repositories/visitor_repository_impl.dart';
import 'package:student_id/features/visitors/domain/repositories/visitor_repository.dart';
import 'package:student_id/features/visitors/domain/usecases/visitor_usecase.dart';

final visitorRepositoryProvider = Provider<VisitorRepository>(
  (ref) => VisitorRepositoryImpl(ref.watch(remoteDataStoreProvider)),
);

final visitorUseCaseProvider = Provider<VisitorUseCase>(
  (ref) => VisitorUseCase(ref.watch(visitorRepositoryProvider)),
);
