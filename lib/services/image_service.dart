import 'dart:async';
import 'dart:io';

import 'package:carstat/features/turbostat/domain/entities/car.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageService {

  Future<File> getImage(Car car) async {
    var _fileName = car.carId + '.png';
    final dir = await getApplicationDocumentsDirectory();
    final String path = dir.path + '/' + _fileName;
    final File image = File(path);
    File _image = image;
    return _image;
  }

  Future<File> getImageFromCam(String fileName) async {
    // for camera
    final File image = await ImagePicker.pickImage(source: ImageSource.camera);
    return image;
  }

  Future<File> getImageFromGallery(String fileName) async {
    // for gallery
    final File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<File> saveImage(File image, String fileName) async {
    if (image == null) return null;
    final directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final File imageFile = await image.copy('$path/$fileName');
    return imageFile;
  }


}