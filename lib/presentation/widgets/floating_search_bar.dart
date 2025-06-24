import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:easy_localization/easy_localization.dart'; // Import for localization

import '../../controllers/cubit/map_cubit.dart';
import 'loading_indicator.dart';

class FloatingSearchBarWidget extends StatelessWidget {
  const FloatingSearchBarWidget({super.key, required this.mapController});
  final MapController mapController;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MapCubit>();
    final state = context.watch<MapCubit>().state;

    return SafeArea(
      child: SizedBox(
        child: FloatingSearchBar(
          hint: 'search_hint'.tr(), // Using localized hint text
          onQueryChanged: (query) {
            if (query.isNotEmpty) {
              cubit.searchLocation(query);
            }
          },
          builder: (context, transition) {
            return Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.isSearching) const MyLinearLoadingIndicator(),
                  if (state.searchResults.isEmpty && !state.isSearching)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('no_results_found'.tr()), // Using localized text for no results
                      ),
                    ),
                  if (state.searchResults.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.searchResults.length,
                      itemBuilder: (context, index) {
                        final result = state.searchResults[index];
                        return ListTile(
                          title: Text(result.displayName),
                          onTap: () {
                            final point = LatLng(result.lat, result.lon);
                            mapController.move(point, 16.0);
                            FloatingSearchBar.of(context)?.close();
                          },
                        );
                      },
                    ),
                ],
              ),
            );
          },
          actions: [
            FloatingSearchBarAction.searchToClear(
              showIfClosed: false,
            ),
          ],
        ),
      ),
    );
  }
}
