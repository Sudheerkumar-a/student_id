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
import 'package:student_id/shared/presentation/theme/form_tokens.dart';
import 'package:student_id/shared/presentation/widgets/forms/app_form_section_card.dart';
import 'package:student_id/shared/presentation/widgets/lists/app_list_item_card.dart';
import 'package:student_id/shared/presentation/widgets/lists/app_list_state_view.dart';
import 'package:student_id/shared/presentation/widgets/staff_appbar_widget.dart';

class ListScreen extends ConsumerWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = GoRouterState.of(context).extra! as ListScreenArgs;
    final isZones = args.listType == ListType.zones;

    if (isZones) {
      return DefaultTabController(
        length: ZoneStateTab.values.length,
        child: _ListScreenContent(args: args),
      );
    }

    return _ListScreenContent(args: args);
  }
}

class _ListScreenContent extends ConsumerWidget {
  const _ListScreenContent({required this.args});

  final ListScreenArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.read(preferencesProvider);
    final title = CatalogNavigation.titleFor(args);
    final subtitle = CatalogNavigation.subtitleFor(args);
    final isStaff = CatalogNavigation.isStaffLoggedIn(prefs);
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
      backgroundColor: FormTokens.surfaceMuted,
      appBar: isStaff
          ? StaffAppBar(title)
          : AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimary.withValues(
                        alpha: 0.85,
                      ),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isZones)
            Material(
              color: theme.colorScheme.surface,
              child: TabBar(
                labelColor: theme.colorScheme.primary,
                unselectedLabelColor: FormTokens.textSecondary,
                indicatorColor: theme.colorScheme.primary,
                indicatorWeight: 3,
                labelStyle: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                tabs: ZoneStateTab.values
                    .map((tab) => Tab(text: tab.label))
                    .toList(),
              ),
            ),
          Expanded(
            child: catalogAsync.when(
              loading: () =>
                  const AppListLoadingView(message: 'Loading zones...'),
              error: (error, _) => AppListErrorView(
                message: error.toString(),
                onRetry: () => ref.invalidate(
                  catalogItemsProvider(
                    CatalogQuery(
                      listType: args.listType,
                      lookupId: CatalogNavigation.lookupIdFor(args),
                    ),
                  ),
                ),
              ),
              data: (zones) {
                if (isZones) {
                  return TabBarView(
                    children: ZoneStateTab.values
                        .map(
                          (tab) => _ZonesTabBody(
                            args: args,
                            zones: ZoneStateFilter.filter(zones, tab),
                            prefs: prefs,
                            stateTab: tab,
                          ),
                        )
                        .toList(),
                  );
                }
                return _CatalogListBody(
                  args: args,
                  zones: zones,
                  prefs: prefs,
                  subtitle: subtitle,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ZonesTabBody extends StatelessWidget {
  const _ZonesTabBody({
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
      return AppListEmptyView(
        title: 'No zones in ${stateTab.label}',
        message: 'No zones are available for this state.',
        icon: Icons.map_outlined,
      );
    }

    return SingleChildScrollView(
      padding: FormTokens.screenPadding.copyWith(bottom: FormTokens.spacingXl),
      child: AppFormSectionCard(
        title: stateTab.label,
        subtitle: '${zones.length} zone(s) — tap to select',
        icon: Icons.map_outlined,
        children: zones
            .map(
              (zone) => AppListItemCard(
                title: zone.name ?? 'Unnamed',
                subtitle: zone.stateName,
                icon: Icons.location_on_outlined,
                onTap: () {
                  final effectiveState =
                      (zone.stateName?.trim().isNotEmpty ?? false)
                          ? zone.stateName!.trim()
                          : stateTab.label;
                  final target = CatalogNavigation.onItemTap(
                    args,
                    Zones(
                      id: zone.id,
                      name: zone.name,
                      stateName: effectiveState,
                    ),
                    prefs,
                  );
                  context.push(target.route, extra: target.extra);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class _CatalogListBody extends StatelessWidget {
  const _CatalogListBody({
    required this.args,
    required this.zones,
    required this.prefs,
    required this.subtitle,
  });

  final ListScreenArgs args;
  final List<Zones> zones;
  final PrefUtils prefs;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    if (zones.isEmpty) {
      return const AppListEmptyView(
        title: 'No items found',
        message: 'There are no options available for this selection.',
        icon: Icons.search_off_outlined,
      );
    }

    return SingleChildScrollView(
      padding: FormTokens.screenPadding.copyWith(bottom: FormTokens.spacingXl),
      child: AppFormSectionCard(
        title: CatalogNavigation.titleFor(args),
        subtitle: subtitle,
        icon: CatalogNavigation.iconFor(args.listType),
        children: zones
            .map(
              (zone) => AppListItemCard(
                title: zone.name ?? 'Unnamed',
                icon: CatalogNavigation.iconFor(args.listType),
                onTap: () {
                  final target = CatalogNavigation.onItemTap(args, zone, prefs);
                  context.push(target.route, extra: target.extra);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
