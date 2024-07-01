import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_id/app_routes.dart';
import 'package:student_id/core/utils/pref_utils.dart';
import 'package:student_id/data/repositories/api_repository_impl.dart';
import 'package:student_id/domain/entities/student_entity.dart';
import 'package:student_id/presentation/bloc/list/list_bloc.dart';
import 'package:student_id/presentation/ui/widgets/staff_appbar_widget.dart';

import '../../../domain/entities/zone.dart';
import '../../../domain/use_cases/get_zones.dart';

class ListWidget extends StatefulWidget {
  ListWidget({super.key});

  //final Function(Widget) changeScreen;
  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  ListWidgetArguments? _agrs;
  PreferredSizeWidget _appBar = AppBar(title: const Text('Zone'));

  Future<void> _setAppBar() async {
    if ((PrefUtils().getStringValue(SharedPreferencesString.userName) ?? '')
        .isNotEmpty) {
      _appBar = StaffAppBar(_getTitle());
    } else {
      _appBar = AppBar(
        title: Text(_getTitle()),
      );
    }
  }

  String _getTitle() {
    String title = 'Zones';
    if (_agrs?.listType == ListType.zones) {
      title = 'Zones';
    } else if (_agrs?.listType == ListType.institutes) {
      title = 'Institutes';
    } else if (_agrs?.listType == ListType.colleges) {
      title = 'Colleges';
    } else {
      title = 'Classes';
    }
    return title;
  }

  ListType _getListType() {
    var type = ListType.institutes;
    if (_agrs?.listType == ListType.zones) {
      type = ListType.institutes;
    } else {
      if (PrefUtils().getBoolValue(SharedPreferencesString.isSchool)) {
        type = ListType.classes;
      } else {
        type = ListType.colleges;
      }
    }
    return type;
  }

  ListWidgetArguments _getArguments(Zones data) {
    ListWidgetArguments arguments = ListWidgetArguments(
        _agrs!.instituteType, _getListType(),
        zoneId: "${data.id}");
    if (_agrs?.listType == ListType.institutes) {
      arguments = ListWidgetArguments(_agrs!.instituteType, _getListType(),
          zoneId: _agrs!.zoneId,
          instituteId: "${data.id}",
          instituteName: "${data.name}");
    } else if (_agrs?.listType == ListType.classes ||
        _agrs?.listType == ListType.colleges) {
      String instituteId = _agrs!.instituteId;
      if ((PrefUtils().getStringValue(SharedPreferencesString.userName) ?? '')
          .isNotEmpty) {
        instituteId =
            (PrefUtils().getStringValue(SharedPreferencesString.instituteID) ??
                '');
      }
      arguments = ListWidgetArguments(_agrs!.instituteType, _getListType(),
          zoneId: _agrs!.zoneId,
          instituteId: instituteId,
          instituteName: _agrs!.instituteName,
          classID: "${data.id}");
    }
    return arguments;
  }

  @override
  Widget build(BuildContext context) {
    _agrs = ModalRoute.of(context)!.settings.arguments as ListWidgetArguments;
    var listType = _agrs?.listType ?? ListType.zones;
    // if ((PrefUtils().getStringValue(SharedPreferencesString.userName) ?? '')
    //     .isNotEmpty) {
    //   listType = ListType.classesColleges;
    // }
    var lookupId = _agrs?.zoneId ?? '';
    if (listType == ListType.zones) {
      lookupId =
          '${(_agrs?.instituteType ?? InstituteType.schools) == InstituteType.schools ? 1 : 2}';
    }
    _setAppBar();
    return BlocProvider<ListBloc>(
      create: (context) => ListBloc(
          getZonesUsecase:
              GetZones(repository: context.read<ApisRepositoryImpl>()))
        ..getData(listType, lookupId: lookupId),
      child: Scaffold(
        appBar: _appBar,
        body: BlocBuilder<ListBloc, ListState>(
          builder: (context, state) {
            if (state is ListLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ListLoadedWithSuccess) {
              return ListView.builder(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                itemCount: state.zones.length,
                itemBuilder: (ctx, index) => ListTile(
                  title: Text(state.zones[index].name ?? ''),
                  shape: const Border(
                      bottom: BorderSide(width: 2, color: Colors.black)),
                  onTap: () => {
                    if (_agrs?.listType == ListType.classes ||
                        _agrs?.listType == ListType.colleges)
                      {
                        if ((PrefUtils().getStringValue(
                                    SharedPreferencesString.userName) ??
                                '')
                            .isEmpty)
                          {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.studentDetails,
                              arguments: StudentEntity(
                                  schoolId:
                                      int.parse(_agrs?.instituteId ?? '0'),
                                  schoolName: _agrs?.instituteName ?? '',
                                  classNo: state.zones[index].id,
                                  className: state.zones[index].name),
                            )
                          }
                        else
                          {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.listStudentsScreen,
                              arguments: _getArguments(state.zones[index]),
                            )
                          }
                      }
                    else
                      {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.listScreen,
                          arguments: _getArguments(state.zones[index]),
                        )
                      }
                  },
                ),
              );
            } else if (state is ListLoadedWithError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              );
            }
            return const Center(
              child: Text(
                'data',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ListWidgetArguments {
  final InstituteType instituteType;
  final ListType listType;
  final String zoneId;
  final String instituteId;
  final String instituteName;
  final String classID;

  ListWidgetArguments(this.instituteType, this.listType,
      {this.zoneId = '',
      this.instituteId = '',
      this.classID = '',
      this.instituteName = ''});
}

enum ListType { zones, institutes, classes, colleges, classesColleges }

enum InstituteType { schools, colleges }
