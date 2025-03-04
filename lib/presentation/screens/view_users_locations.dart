import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sight_mate_app/controllers/add_data_cubit/data_cubit.dart';
import '../../controllers/cubit/map_cubit.dart';
import '../widgets/floating_action_buttons.dart';
import '../widgets/loading_indicator.dart';

class UserLocationsMapScreen extends StatefulWidget {
  const UserLocationsMapScreen({super.key});

  @override
  State<UserLocationsMapScreen> createState() => _UserLocationsMapScreenState();
}

class _UserLocationsMapScreenState extends State<UserLocationsMapScreen> {
  @override
  void initState() {
    super.initState();
    mapController = MapController();
    context.read<MapCubit>().fetchCurrentLocation();
    getMarkers();
    fetchPointsAndUpdateMarkers();
  }

  void getMarkers() async {
    dataList = await context.read<DataCubit>().getAllUsersWithLatLon();
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
