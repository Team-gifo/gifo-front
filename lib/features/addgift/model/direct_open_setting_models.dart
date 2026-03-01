import 'package:image_picker/image_picker.dart';

class DirectOpenBeforeData {
  String? imageUrl;
  XFile? imageFile;
  String description;

  DirectOpenBeforeData({
    this.imageUrl,
    this.imageFile,
    this.description = '내가 준비한 선물이 과연 무엇일까?',
  });
}

class DirectOpenAfterData {
  String itemName;
  String? imageUrl;
  XFile? imageFile;

  DirectOpenAfterData({this.itemName = '', this.imageUrl, this.imageFile});
}
