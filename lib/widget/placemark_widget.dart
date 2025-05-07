import 'package:faveverse/style/colors/fv_colors.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;

import '../common.dart';

class PlacemarkWidget extends StatelessWidget {
  const PlacemarkWidget({
    super.key,
    required this.placemark,
    this.onSend,
    this.isButtonEnable = true,
  });

  final VoidCallback? onSend;
  final geo.Placemark placemark;
  final bool isButtonEnable;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(maxWidth: 700),
      decoration: BoxDecoration(
        color: FvColors.blue.color,
        borderRadius: const BorderRadius.all(Radius.circular(26)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 20,
            offset: Offset.zero,
            color: Colors.grey.withOpacity(0.5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  placemark.street!,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white
                  ),
                ),
                Text(
                  '${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white
                  ),
                ),
                const SizedBox(height: 10),
                if (isButtonEnable && onSend != null)
                  ElevatedButton.icon(
                    onPressed: onSend,
                    icon: const Icon(Icons.location_on),
                    label: Text(
                      AppLocalizations.of(context)!.selectLocationButton,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
