import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:student_id/domain/use_cases/get_zones.dart';
import 'package:student_id/presentation/bloc/list/list_bloc.dart';

import 'data/datasource/remote_data_source.dart';
import 'data/repositories/api_repository_impl.dart';
import 'domain/repositories/api_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // NEWS:

  // Data

  // DataSources
  sl.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl());

  // Repositories
  sl.registerLazySingleton<ApisRepository>(
      () => ApisRepositoryImpl(remoteDataSource: sl()));

  // Domain

  // Usecases
  sl.registerLazySingleton(() => GetZones(repository: sl()));

  // Presentation

  // BLoC
  sl.registerFactory(() => ListBloc(getZonesUsecase: sl()));

  // Misc
  sl.registerLazySingleton(() => http.Client());
}
