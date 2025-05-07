import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart' as geo;

import '../common.dart';
import '../provider/story_detail_provider.dart';
import '../static/story_detail_result_state.dart';
import '../widget/placemark_widget.dart';

class DetailScreen extends StatefulWidget {
  final String storyId;

  const DetailScreen({super.key, required this.storyId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late GoogleMapController mapController;
  late final Set<Marker> markers = {};
  geo.Placemark? placemark;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<StoryDetailProvider>().fetchStoryDetail(widget.storyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.detailScreenTitle,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: SingleChildScrollView(
        child: Consumer<StoryDetailProvider>(
          builder: (context, value, child) {
            return switch (value.resultState) {
              StoryDetailLoadedState(data: var story) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 300,
                        width: double.infinity,
                        child: Image.network(
                          story.story.photoUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        height: 300,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black54, Colors.transparent],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      story.story.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      story.story.description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      AppLocalizations.of(context)!.locationTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (story.story.lat != null && story.story.lon != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(story.story.lat!, story.story.lon!),
                            zoom: 15,
                          ),
                          markers: markers,
                          onMapCreated: (controller) {
                            final marker = Marker(
                              markerId: const MarkerId("source"),
                              position: LatLng(
                                story.story.lat!,
                                story.story.lon!,
                              ),
                            );
                            setState(() {
                              mapController = controller;
                              markers.add(marker);
                            });
                          },
                          onLongPress: (LatLng latLng) {
                            onLongPressGoogleMap(latLng);
                          },
                          zoomControlsEnabled: false,
                          myLocationButtonEnabled: false,
                          myLocationEnabled: false,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  if (placemark != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: PlacemarkWidget(
                        placemark: placemark!,
                        isButtonEnable: false,
                      ),
                    ),
                ],
              ),
              StoryDetailLoadingState() => const Center(
                child: CircularProgressIndicator(),
              ),
              StoryDetailErrorState(error: _) => Center(
                child: Text(AppLocalizations.of(context)!.errorSign),
              ),
              _ => Center(child: Text(AppLocalizations.of(context)!.errorSign)),
            };
          },
        ),
      ),
    );
  }

  void onLongPressGoogleMap(LatLng latLng) async {
    final info = await geo.placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
    );
    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      placemark = place;
    });
    defineMarker(latLng, street, address);
    mapController.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  void defineMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      infoWindow: InfoWindow(title: street, snippet: address),
    );

    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }
}
