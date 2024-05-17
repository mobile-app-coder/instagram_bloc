import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/post_model.dart';
import '../../services/db_service.dart';
import '../../services/file_service.dart';

part 'upload_event.dart';
part 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  PageController? pageController;

  var captionController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  File? _image;

  UploadBloc() : super(UploadInitial()) {
    on<UploadGalleryEvent>(_imgFromGallery);
    on<UploadCameraEvent>(_imgFromCamera);
  }

  moveToFeed() {
    captionController.text = "";
    _image = null;
    pageController!.animateToPage(0,
        duration: const Duration(microseconds: 200), curve: Curves.easeIn);
  }

  Future<void> _imgFromGallery(
      UploadGalleryEvent event, Emitter<UploadState> emit) async {
    XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    _image = File(image!.path);
    emit(UploadInitial());
  }

  Future<void> _imgFromCamera(
      UploadCameraEvent event, Emitter<UploadState> emit) async {
    XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    _image = File(image!.path);
    emit(UploadInitial());
  }

  uploadNewPost() {
    String caption = captionController.text.toString().trim();
    if (caption.isEmpty) return;
    if (_image == null) return;
    _apiPostImage();
  }

  Future<void> _apiPostImage() async {
    var path = await FileService.uploadPostImage(_image!);
    _resPostImage(path);
  }

  void _resPostImage(String downloadUrl) {
    String caption = captionController.text.toString().trim();
    Post post = Post(caption, downloadUrl);
    _apiStorePost(post);
  }

  void _apiStorePost(Post post) async {
    // Post to posts
    Post posted = await DBService.storePost(post);
    // Post to feeds
    await DBService.storeFeed(posted);
    moveToFeed();
  }

  void showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
              child: Container(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text("Pick Photo"),
                  onTap: () {
                    // _imgFromCamera();
                    add(UploadCameraEvent());
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text("Pick Photo"),
                  onTap: () {
                    add(UploadGalleryEvent());
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ));
        });
  }
}
