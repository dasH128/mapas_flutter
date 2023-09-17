import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapas_flutter/presentation/providers/providers.dart';

class LocationMapScreen extends ConsumerWidget {
  const LocationMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userLocationAsync = ref.watch(userLocationProvider);
    final watchLocationAsync = ref.watch(watchLocationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubicaci+on'),
        actions: [
          IconButton(
            icon: const Icon(Icons.update),
            onPressed: () {
              ref.invalidate(userLocationProvider);
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Ubicaciòn actual'),
            userLocationAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) => Text('$error'),
              data: (data) => Text('$data'),
            ),
            const SizedBox(height: 30),
            const Text('Ubicaciòn actual'),
            watchLocationAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) => Text('$error'),
              data: (data) => Text('$data'),
            ),
          ],
        ),
      ),
    );
  }
}
