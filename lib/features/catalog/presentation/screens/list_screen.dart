import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:student_id/app/preferences_provider.dart';
import 'package:student_id/features/catalog/domain/entities/zone.dart';
import 'package:student_id/features/catalog/presentation/models/list_screen_args.dart';
import 'package:student_id/features/catalog/presentation/providers/catalog_navigation.dart';
import 'package:student_id/features/catalog/presentation/providers/catalog_providers.dart';

class ListScreen extends ConsumerWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = GoRouterState.of(context).extra! as ListScreenArgs;
    final prefs = ref.read(preferencesProvider);

    final catalogAsync = ref.watch(
      catalogItemsProvider(
        CatalogQuery(
          listType: args.listType,
          lookupId: CatalogNavigation.lookupIdFor(args),
        ),
      ),
    );

    return Scaffold(
      appBar: CatalogNavigation.appBarFor(args, prefs),
      body: catalogAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            error.toString(),
            style: const TextStyle(color: Colors.black),
          ),
        ),
        data: (zones) => ListView.builder(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          itemCount: zones.length,
          itemBuilder: (ctx, index) => ListTile(
            title: Text(zones[index].name ?? ''),
            shape: const Border(
              bottom: BorderSide(width: 2, color: Colors.black),
            ),
            onTap: () {
              final target = CatalogNavigation.onItemTap(
                args,
                zones[index],
                prefs,
              );
              context.push(target.route, extra: target.extra);
            },
          ),
        ),
      ),
    );
  }
}
