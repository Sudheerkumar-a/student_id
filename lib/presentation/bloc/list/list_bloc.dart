import 'package:student_id/domain/entities/zone.dart';
import 'package:student_id/domain/use_cases/get_zones.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_id/core/errors/failures.dart';
import 'package:student_id/presentation/ui/screens/list_screen.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Cubit<ListState> {
  final GetZones getZonesUsecase;
  ListBloc({required this.getZonesUsecase}) : super(ListInitial());

  Future<void> getData(ListType listType, {String lookupId = ''}) async {
    emit(ListLoading());

    final result = await getZonesUsecase.execute(listType, lookupId: lookupId);
    emit(result.fold((l) => ListLoadedWithError(message: _getErrorMessage(l)),
        (r) => ListLoadedWithSuccess(zones: r)));
  }

  String _getErrorMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message;
      case CacheFailure:
        return (failure as CacheFailure).message;
      default:
        return 'An unknown error has occured';
    }
  }
}
