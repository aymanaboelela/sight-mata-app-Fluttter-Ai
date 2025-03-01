// map_state.dart
part of 'map_cubit.dart';

abstract class MapState {
  final LatLng? currentLocation;
  final LatLng? destination;
  final List<LatLng> routePoints;
  final List<AddressDetails> searchResults;
  final List<Marker> markers;
  final bool isSearching;
  final bool isLoading;
  final bool isDriverMode;

  const MapState({
    required this.currentLocation,
    required this.destination,
    required this.routePoints,
    required this.searchResults,
    required this.markers,
    required this.isSearching,
    required this.isLoading,
    required this.isDriverMode,
  });
}

class MapInitial extends MapState {
  MapInitial() : super(
    currentLocation: null,
    destination: null,
    routePoints: const [],
    searchResults: const [],
    markers: const [],
    isSearching: false,
    isLoading: false,
    isDriverMode: false,
  );
}

class MapLoaded extends MapState {
  const MapLoaded({
    required super.currentLocation,
    required super.destination,
    required super.routePoints,
    required super.searchResults,
    required super.markers,
    required super.isSearching,
    required super.isLoading,
    required super.isDriverMode,
  });
}