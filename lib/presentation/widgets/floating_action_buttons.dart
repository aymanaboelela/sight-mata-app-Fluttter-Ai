import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:sight_mate_app/core/constants/app_assets.dart';

import '../../controllers/cubit/map_cubit.dart';

class FloatingActionButtonWidgets extends StatelessWidget {
  const FloatingActionButtonWidgets({
    super.key,
    required MapController mapController,
    this.isZoomOut,
  }) : _mapController = mapController;
  final bool? isZoomOut;
  final MapController _mapController;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MapCubit>();
    final state = context.watch<MapCubit>().state;

    final buttonsVerticalSpacing = SizedBox(height: kIsWeb ? 10 : 5);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buttonsVerticalSpacing,
        _buildSmallButton(
          heroTag: "current_location",
          onPressed: () {
            if (state.currentLocation != null) {
              _mapController.move(state.currentLocation!, 12.0);
            }
          },
          image: AppAssets.currentLocation,
        ),
        buttonsVerticalSpacing,
        FloatingActionButton.small(
          heroTag: "reset",
          onPressed: () {
            isZoomOut == true ? null : cubit.resetMap();
            _mapController.move(state.currentLocation!, 10.0);
          },
          child: Icon(isZoomOut == true ? Icons.zoom_out : Icons.refresh,
              color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildSmallButton({
    required String heroTag,
    required VoidCallback onPressed,
    required String image,
  }) {
    return FloatingActionButton.small(
      heroTag: heroTag,
      onPressed: onPressed,
      child: Image.asset(
        image,
        color: Colors.black,
        width: 20,
        height: 20,
      ),
    );
  }
}
