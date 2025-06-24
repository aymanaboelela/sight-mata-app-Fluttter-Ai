import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sight_mate_app/presentation/widgets/loading_indicator.dart';

import '../../controllers/cubit/map_cubit.dart';
import '../widgets/floating_action_buttons.dart';
import '../widgets/floating_search_bar.dart';

LatLng? selectedLocation;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, this.latlng});
  final LatLng? latlng;
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
    mapController = MapController();
    context.read<MapCubit>().fetchCurrentLocation();
  }

  late MapController mapController;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return BlocBuilder<MapCubit, MapState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(fit: StackFit.expand, children: [
            state.currentLocation == null && widget.latlng == null
                ? const Center(child: MyCircularLoadingIndicator())
                : FlutterMap(
                    mapController:mapController,
                    options: MapOptions(
                      center: widget.latlng ?? state.currentLocation!,
                      zoom: 16.0,
                      onTap: (tapPosition, point) =>
                          context.read<MapCubit>().newMarker(point),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        userAgentPackageName: 'flutter_map',
                        subdomains: const ['a', 'b', 'c'],
                      ),
                      MarkerLayer(markers: state.markers),
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: state.routePoints,
                            strokeWidth: 4.0,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ],
                  ),
            FloatingSearchBarWidget(
              mapController: mapController,
            ),
            Positioned(
              bottom: 40,
              left: width * 0.25,
              right: width * 0.25,
              child: ElevatedButton(
                onPressed: () {
                  final location =
                      context.read<MapCubit>().state.routePoints.isNotEmpty
                          ? context.read<MapCubit>().state.routePoints.last
                          : null;
                  if (location != null) {
                    selectedLocation = location;
                  }
                  Navigator.pop(context);
                },
                             child: Text("confirm".tr()),
              ),
            ),
          ]),
          floatingActionButton: state.currentLocation != null
              ? FloatingActionButtonWidgets(
                  mapController: mapController,
                )
              : null,
        );
      },
    );
  }
}
