import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:student_id/app/preferences_provider.dart';
import 'package:student_id/core/utils/pref_utils.dart';
import 'package:student_id/features/catalog/domain/entities/zone.dart';
import 'package:student_id/features/catalog/domain/enums/catalog_enums.dart';
import 'package:student_id/features/catalog/presentation/models/list_screen_args.dart';
import 'package:student_id/features/catalog/presentation/providers/catalog_navigation.dart';
import 'package:student_id/features/catalog/presentation/providers/catalog_providers.dart';
import 'package:student_id/features/catalog/presentation/utils/zone_state_filter.dart';

class ListScreen extends ConsumerWidget {
  const ListScreen({super.key});

  static const _surfaceMuted = Color(0xFFF5F5F7);
  static const _borderColor = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = GoRouterState.of(context).extra! as ListScreenArgs;
    final isZones = args.listType == ListType.zones;

    if (isZones) {
      return DefaultTabController(
        length: ZoneStateTab.values.length,
        child: _ListScreenBody(args: args),
      );
    }

    return _ListScreenBody(args: args);
  }
}

class _ListScreenBody extends ConsumerWidget {
  const _ListScreenBody({required this.args});

  final ListScreenArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.read(preferencesProvider);
    final isZones = args.listType == ListType.zones;
    final theme = Theme.of(context);

    final catalogAsync = ref.watch(
      catalogItemsProvider(
        CatalogQuery(
          listType: args.listType,
          lookupId: CatalogNavigation.lookupIdFor(args),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: ListScreen._surfaceMuted,
      appBar: CatalogNavigation.appBarFor(args, prefs),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isZones)
            Material(
              color: theme.colorScheme.surface,
              child: TabBar(
                labelColor: theme.colorScheme.primary,
                unselectedLabelColor: Colors.grey.shade600,
                indicatorColor: theme.colorScheme.primary,
                indicatorWeight: 3,
                tabs: ZoneStateTab.values
                    .map((tab) => Tab(text: tab.label))
                    .toList(),
              ),
            ),
          Expanded(
            child: catalogAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text(error.toString())),
              data: (zones) {
                if (isZones) {
                  return TabBarView(
                    children: ZoneStateTab.values
                        .map(
                          (tab) => _ZonesByStateTab(
                            args: args,
                            zones: ZoneStateFilter.filter(zones, tab),
                            prefs: prefs,
                            stateTab: tab,
                          ),
                        )
                        .toList(),
                  );
                }
                return _PlainCatalogList(
                  args: args,
                  zones: zones,
                  prefs: prefs,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ZonesByStateTab extends StatelessWidget {
  const _ZonesByStateTab({
    required this.args,
    required this.zones,
    required this.prefs,
    required this.stateTab,
  });

  final ListScreenArgs args;
  final List<Zones> zones;
  final PrefUtils prefs;
  final ZoneStateTab stateTab;

  @override
  Widget build(BuildContext context) {
    if (zones.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.map_outlined, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(
                'No zones in ${stateTab.label}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: zones.length,
      itemBuilder: (context, index) {
        final zone = zones[index];
        return _ZoneListCard(
          title: zone.name ?? 'Unnamed',
          subtitle: zone.state,
          onTap: () {
            final effectiveState = (zone.state?.trim().isNotEmpty ?? false)
                ? zone.state!.trim()
                : stateTab.label;
            final target = CatalogNavigation.onItemTap(
              args,
              Zones(id: zone.id, name: zone.name, state: effectiveState),
              prefs,
            );
            context.push(target.route, extra: target.extra);
          },
        );
      },
    );
  }
}

class _PlainCatalogList extends StatelessWidget {
  const _PlainCatalogList({
    required this.args,
    required this.zones,
    required this.prefs,
  });

  final ListScreenArgs args;
  final List<Zones> zones;
  final PrefUtils prefs;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: zones.length,
      itemBuilder: (context, index) {
        final zone = zones[index];
        return _ZoneListCard(
          title: zone.name ?? 'Unnamed',
          onTap: () {
            final target = CatalogNavigation.onItemTap(args, zone, prefs);
            context.push(target.route, extra: target.extra);
          },
        );
      },
    );
  }
}

class _ZoneListCard extends StatelessWidget {
  const _ZoneListCard({
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ListScreen._borderColor),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (subtitle != null && subtitle!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
