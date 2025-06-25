import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sight_mate_app/core/constants/app_assets.dart';

import '../../controllers/cubit/map_cubit.dart';
import '../widgets/floating_action_buttons.dart';
import '../widgets/loading_indicator.dart';

class BlindMapView extends StatefulWidget {
  const BlindMapView({super.key});

  @override
  State<BlindMapView> createState() => _BlindMapViewState();
}

class _BlindMapViewState extends State<BlindMapView> {
  @override
  void initState() {
    super.initState();
    mapController = MapController();
    context.read<MapCubit>().fetchCurrentLocation();
  }

  List<LatLng> dataList = [];
  late MapController mapController;

  void fetchPointsAndUpdateMarkers() async {
    List<LatLng> points = await fetchPointsFromBackend();
    context.read<MapCubit>().updateMarkers(points);
  }

  Future<List<LatLng>> fetchPointsFromBackend() async {
    await Future.delayed(const Duration(seconds: 2));
    return dataList;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(fit: StackFit.expand, children: [
            state.currentLocation == null
                ? const Center(child: MyCircularLoadingIndicator())
                : FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      center: state.currentLocation!,
                      zoom: 6.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        userAgentPackageName: 'flutter_map',
                        subdomains: const ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: state.markers,
                      ),
                    ],
                  ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 40,
              child: Image.asset(
                AppAssets.bb,
                width: 100,
                height: 100,
              ),
            ),
          ]),
          floatingActionButton: state.currentLocation != null
              ? FloatingActionButtonWidgets(
                  mapController: mapController,
                  isZoomOut: true,
                )
              : null,
        );
      },
    );
  }
}
