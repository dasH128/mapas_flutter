import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas_flutter/presentation/providers/providers.dart';

class ControlledMapScreen extends ConsumerWidget {
  const ControlledMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userLocation = ref.watch(userLocationProvider);

    return Scaffold(
      body: userLocation.when(
        data: (data) => MapAndControl(
          latitude: data.$1,
          longitude: data.$2,
        ),
        loading: () => const CircularProgressIndicator(),
        error: (err, _) => Text('$err'),
      ),
    );
  }
}

class MapAndControl extends ConsumerWidget {
  final double latitude;
  final double longitude;

  const MapAndControl({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mapControllerProvider);
    return Stack(
      children: [
        _MapView(
          initialLat: latitude,
          initialLng: longitude,
        ),
        Positioned(
          top: 40,
          left: 20,
          child: IconButton.filledTonal(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.pop();
            },
          ),
        ),
        Positioned(
          bottom: 40,
          left: 20,
          child: IconButton.filledTonal(
            icon: const Icon(Icons.location_searching),
            onPressed: () {
              ref
                  .read(mapControllerProvider.notifier)
                  // .goToLocation(latitude, longitude);
                  .findUser();
            },
          ),
        ),
        Positioned(
          bottom: 90,
          left: 20,
          child: IconButton.filledTonal(
            icon: (state.followUser)
                ? const Icon(Icons.directions_run_outlined)
                : const Icon(Icons.accessibility),
            onPressed: () {
              ref.read(mapControllerProvider.notifier).toogleFollowUser();
            },
          ),
        ),
        Positioned(
          bottom: 140,
          left: 20,
          child: IconButton.filledTonal(
            icon: const Icon(Icons.pin_drop_rounded),
            onPressed: () {
              ref
                  .read(mapControllerProvider.notifier)
                  .addMarkerCurrentPosition();
            },
          ),
        ),
      ],
    );
  }
}

class _MapView extends ConsumerStatefulWidget {
  final double initialLat;
  final double initialLng;
  const _MapView({
    required this.initialLat,
    required this.initialLng,
  });

  @override
  __MapViewState createState() => __MapViewState();
}

class __MapViewState extends ConsumerState<_MapView> {
  @override
  Widget build(BuildContext context) {
    var state = ref.watch(mapControllerProvider);
    return GoogleMap(
      markers: state.markersSet,
      mapType: MapType.hybrid,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          widget.initialLat,
          widget.initialLng,
        ),
        zoom: 15,
      ),
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      onMapCreated: (controller) {
        ref.read(mapControllerProvider.notifier).setMapController(controller);
      },
      onLongPress: (latLng) {
        ref.read(mapControllerProvider.notifier).addMarker(
            latLng.latitude, latLng.longitude, 'marker personalizado');
      },
    );
  }
}
