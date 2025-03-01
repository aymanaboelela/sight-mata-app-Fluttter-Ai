import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sight_mate_app/core/constants/app_assets.dart';

import '../../core/helper/location/location_permission.dart';
import '../../data/model/maps_models.dart';
import '../../data/repository/map_repository.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  final MapsRepositoryInterface mapsRepository;
  final LocationService locationService;

  MapCubit(this.mapsRepository, this.locationService) : super(MapInitial());

  Future<void> fetchCurrentLocation() async {
    final location = await locationService.getCurrentLocation();
    if (location != null) {
      List<Marker> newMarkers = List.from(state.markers);
      newMarkers.add(
        Marker(
          width: 200.0,
          height: 200.0,
          point: location,
          builder: (_) => Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.blueAccent,
                      width: 2.0,
                    )),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue.withOpacity(0.3),
                ),
              ),
              Image.asset(AppAssets.currentLocation, width: 40, height: 40)
            ],
          ),
        ),
      );

      emit(MapLoaded(
        currentLocation: location,
        destination: state.destination,
        routePoints: state.routePoints,
        searchResults: state.searchResults,
        markers: newMarkers,
        isSearching: state.isSearching,
        isLoading: state.isLoading,
        isDriverMode: state.isDriverMode,
      ));
    }

    locationService.onLocationChanged().listen((newLocation) {
      emit(MapLoaded(
        currentLocation: newLocation,
        destination: state.destination,
        routePoints: state.routePoints,
        searchResults: state.searchResults,
        markers: state.markers,
        isSearching: state.isSearching,
        isLoading: state.isLoading,
        isDriverMode: state.isDriverMode,
      ));
    });
  }

  Future<void> newMarker(LatLng destination) async {
    if (state.currentLocation == null) return;

    emit(MapLoaded(
      currentLocation: state.currentLocation,
      destination: state.destination,
      routePoints: state.routePoints,
      searchResults: state.searchResults,
      markers: state.markers,
      isSearching: state.isSearching,
      isLoading: true,
      isDriverMode: state.isDriverMode,
    ));

    List<LatLng> newRoutePoints = [];
    newRoutePoints = [destination];

    List<Marker> newMarkers =
        state.markers.where((marker) => marker.builder is Stack).toList();

    newMarkers.add(Marker(
      width: 200.0,
      height: 200.0,
      point: state.currentLocation!,
      builder: (_) => Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.blueAccent,
                  width: 2.0,
                )),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.withOpacity(0.3),
            ),
          ),
          Image.asset(AppAssets.currentLocation, width: 40, height: 40),
        ],
      ),
    ));
    newMarkers.add(
      Marker(
        width: 40.0,
        height: 40.0,
        point: destination,
        builder: (_) => Image.asset(AppAssets.searchedLocation),
      ),
    );

    emit(MapLoaded(
      currentLocation: state.currentLocation,
      destination: destination,
      routePoints: newRoutePoints,
      searchResults: state.searchResults,
      markers: newMarkers,
      isSearching: state.isSearching,
      isLoading: false,
      isDriverMode: state.isDriverMode,
    ));
  }

  Future<void> searchLocation(String query) async {
    if (query.isEmpty) {
      emit(MapLoaded(
        currentLocation: state.currentLocation,
        destination: state.destination,
        routePoints: state.routePoints,
        searchResults: [],
        markers: state.markers,
        isSearching: false,
        isLoading: state.isLoading,
        isDriverMode: state.isDriverMode,
      ));
      return;
    }

    emit(MapLoaded(
      currentLocation: state.currentLocation,
      destination: state.destination,
      routePoints: state.routePoints,
      searchResults: state.searchResults,
      markers: state.markers,
      isSearching: true,
      isLoading: state.isLoading,
      isDriverMode: state.isDriverMode,
    ));

    final results = await mapsRepository.searchLocation(query);

    emit(MapLoaded(
      currentLocation: state.currentLocation,
      destination: state.destination,
      routePoints: state.routePoints,
      searchResults: results,
      markers: state.markers,
      isSearching: false,
      isLoading: state.isLoading,
      isDriverMode: state.isDriverMode,
    ));
  }

  void updateMarkers(List<LatLng> points) {
    List<Marker> newMarkers = points.map((point) {
      return Marker(
        width: 40.0,
        height: 40.0,
        point: point,
        builder: (_) => const Icon(
          Icons.location_on,
          color: Colors.blue,
          size: 40,
        ),
      );
    }).toList();

    emit(MapLoaded(
      currentLocation: state.currentLocation,
      destination: state.destination,
      routePoints: state.routePoints,
      searchResults: state.searchResults,
      markers: newMarkers,
      isSearching: state.isSearching,
      isLoading: state.isLoading,
      isDriverMode: state.isDriverMode,
    ));
  }

  void resetMap() {
    emit(MapLoaded(
      currentLocation: state.currentLocation,
      destination: null,
      routePoints: [],
      searchResults: [],
      markers: [
        Marker(
          width: 200.0,
          height: 200.0,
          point: state.currentLocation!,
          builder: (_) => Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.blueAccent,
                      width: 2.0,
                    )),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue.withOpacity(0.3),
                ),
              ),
              Image.asset(AppAssets.currentLocation, width: 40, height: 40),
            ],
          ),
        ),
      ],
      isSearching: false,
      isLoading: false,
      isDriverMode: false,
    ));
  }
}
