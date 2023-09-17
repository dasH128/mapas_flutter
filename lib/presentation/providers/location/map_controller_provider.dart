// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final mapControllerProvider =
    StateNotifierProvider<MapNotifier, MapState>((ref) {
  return MapNotifier();
});

class MapNotifier extends StateNotifier<MapState> {
  StreamSubscription? userLocation$;
  (double, double)? lastKnowLocation;

  MapNotifier() : super(MapState()) {
    trackUser().listen((event) {
      lastKnowLocation = (event.$1, event.$2);
    });
  }

  Stream<(double, double)> trackUser() async* {
    await for (final pos in Geolocator.getPositionStream()) {
      yield (pos.latitude, pos.longitude);
    }
  }

  setMapController(GoogleMapController controller) {
    updateState(controller: controller, isReady: true);
  }

  goToLocation(double latitude, double longitude) {
    final newPosition = CameraPosition(
      target: LatLng(
        latitude,
        longitude,
      ),
      zoom: 15,
    );

    state.controller?.animateCamera(
      CameraUpdate.newCameraPosition(newPosition),
    );
  }

  findUser() async {
    if (lastKnowLocation == null) return;
    final (latitude, longitude) = lastKnowLocation!;
    goToLocation(latitude, longitude);
  }

  toogleFollowUser() {
    updateState(followUser: !state.followUser);
    if (state.followUser) {
      userLocation$ = trackUser().listen((event) {
        goToLocation(event.$1, event.$2);
      });
    } else {
      userLocation$?.cancel();
    }
  }

  addMarkerCurrentPosition() {
    if (lastKnowLocation == null) return;
    final (latitude, longitude) = lastKnowLocation!;
    addMarker(latitude, longitude, 'name test');
  }

  addMarker(double latitude, double longitude, String name) {
    Marker marker = Marker(
      markerId: MarkerId('${state.markers.length}'),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(
        title: name,
        snippet: 'Esto es elñ snippet del info WINDOWS',
      ),
    );
    updateState(markers: [...state.markers, marker]);
  }

  updateState({
    bool? isReady,
    bool? followUser,
    List<Marker>? markers,
    GoogleMapController? controller,
  }) {
    state = state.copyWith(
      isReady: isReady,
      followUser: followUser,
      markers: markers,
      controller: controller,
    );
  }
}

class MapState {
  final bool isReady;
  final bool followUser;
  final List<Marker> markers;
  final GoogleMapController? controller;

  MapState({
    this.isReady = false,
    this.followUser = false,
    this.markers = const [],
    this.controller,
  });

  Set<Marker> get markersSet {
    return Set.from(markers);
  }

  MapState copyWith({
    bool? isReady,
    bool? followUser,
    List<Marker>? markers,
    GoogleMapController? controller,
  }) {
    return MapState(
      isReady: isReady ?? this.isReady,
      followUser: followUser ?? this.followUser,
      markers: markers ?? this.markers,
      controller: controller ?? this.controller,
    );
  }
}
