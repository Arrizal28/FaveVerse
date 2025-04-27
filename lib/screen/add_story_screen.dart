import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:faveverse/provider/add_story_provider.dart';
import 'package:faveverse/style/colors/fv_colors.dart';
import 'package:faveverse/widget/auth_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../common.dart';
import '../provider/story_list_provider.dart';
import '../provider/upload_provider.dart';
import '../routes/page_manager.dart';

class AddStoryScreen extends StatefulWidget {
  final VoidCallback onStoryAdded;
  final VoidCallback onCancel;
  final VoidCallback onAddLocation;

  const AddStoryScreen({
    super.key,
    required this.onStoryAdded,
    required this.onCancel,
    required this.onAddLocation,
  });

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final TextEditingController _descController = TextEditingController();
  String? _selectedAddress;

  bool get isUploadEnabled {
    final hasImage = context.read<AddStoryProvider>().imagePath != null;
    final hasDesc = _descController.text.trim().isNotEmpty;
    return hasImage && hasDesc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.createStoryTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          context.watch<AddStoryProvider>().imagePath == null
              ? DottedBorder(
                color: Colors.grey,
                dashPattern: const [8, 4],
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 50, color: FvColors.blue.color),
                      Text(
                        AppLocalizations.of(context)!.noImage,
                        style: TextStyle(color: FvColors.blue.color),
                      ),
                    ],
                  ),
                ),
              )
              : Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: _showImage(),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed:
                            () => context.read<AddStoryProvider>().clearImage(),
                      ),
                    ),
                  ),
                ],
              ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _onGalleryView(),
                  icon: const Icon(Icons.photo_library),
                  label: Text(AppLocalizations.of(context)!.gallery),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _onCameraView(),
                  icon: const Icon(Icons.camera_alt),
                  label: Text(AppLocalizations.of(context)!.camera),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descController,
            maxLines: 4,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.descriptionLabel,
              hintText: AppLocalizations.of(context)!.descriptionHint,
            ),
            onChanged: (_) => setState(() {}),
          ),

          const SizedBox(height: 16),

          _selectedAddress == null
              ? ElevatedButton.icon(
                onPressed: () async {
                  widget.onAddLocation();
                  final address =
                      await context.read<PageManager>().waitForResult();

                  setState(() {
                    _selectedAddress = address;
                  });
                },
                icon: const Icon(Icons.location_on),
                label: const Text('Tambah Lokasi'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              )
              : Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: FvColors.blue.color),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _selectedAddress!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
          const SizedBox(height: 60),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 60,
          width: double.infinity,
          child: Consumer<UploadProvider>(
            builder: (context, uploadProvider, child) {
              return uploadProvider.isUploading
                  ? Center(
                    child: CircularProgressIndicator(
                      color: FvColors.blueyoung.color,
                    ),
                  )
                  : AuthButton(
                    onPressed: isUploadEnabled ? _onUpload : null,
                    text: AppLocalizations.of(context)!.upload,
                  );
            },
          ),
        ),
      ),
    );
  }

  _onUpload() async {
    final ScaffoldMessengerState scaffoldMessengerState = ScaffoldMessenger.of(
      context,
    );
    final uploadProvider = context.read<UploadProvider>();
    final addStoryProvider = context.read<AddStoryProvider>();

    final imagePath = addStoryProvider.imagePath;
    final imageFile = addStoryProvider.imageFile;

    if (imagePath == null || imageFile == null) return;

    uploadProvider.setLoadingState(true);

    try {
      await Future.delayed(Duration(milliseconds: 50));

      final fileName = imageFile.name;
      final bytes = await imageFile.readAsBytes();
      final newBytes = await uploadProvider.compressImage(bytes);
      final description = _descController.text.trim();

      await uploadProvider.apiService.uploadDocument(
        newBytes,
        fileName,
        description,
      );

      addStoryProvider.setImageFile(null);
      addStoryProvider.setImagePath(null);

      widget.onStoryAdded();

      Future.microtask(() {
        if (context.mounted) {
          context.read<StoryListProvider>().fetchStoryList();
        }
      });

      if (context.mounted) {
        scaffoldMessengerState.showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.uploadSuccess)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        scaffoldMessengerState.showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorWithMessage(e.toString()),
            ),
          ),
        );
      }
    } finally {
      if (context.mounted) {
        uploadProvider.setLoadingState(false);
      }
    }
  }

  _onGalleryView() async {
    final ImagePicker picker = ImagePicker();
    final provider = context.read<AddStoryProvider>();

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onCameraView() async {
    final ImagePicker picker = ImagePicker();
    final provider = context.read<AddStoryProvider>();

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) return;

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  Widget _showImage() {
    final imagePath = context.read<AddStoryProvider>().imagePath;
    return kIsWeb
        ? Image.network(imagePath.toString(), fit: BoxFit.contain)
        : Image.file(File(imagePath.toString()), fit: BoxFit.contain);
  }
}
