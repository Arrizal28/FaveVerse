import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:provider/provider.dart';
import '../routes/page_manager.dart';

class PlacemarkWidget extends StatelessWidget {
  const PlacemarkWidget({super.key, required this.placemark, required this.onSend});

  final VoidCallback onSend;
  final geo.Placemark placemark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(maxWidth: 700),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(50)),
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
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 10,),
                ElevatedButton.icon(
                  onPressed: () {
                    final address = '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}';

                    onSend;

                    context.read<PageManager>().returnData(address);

                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.location_on),
                  label: const Text('Pakai lokasi ini'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
