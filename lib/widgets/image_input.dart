import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

import 'dart:io';

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;

  Future<void>_takePicture() async{
    final picker = ImagePicker();
    final imageFile = await picker.getImage(source: ImageSource.camera, maxWidth: 600, maxHeight: 800);
    if(imageFile == null){
      return;
    }
    setState(() {
      _storedImage = File(imageFile.path);
    });
    final appDirectory = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(_storedImage.path);
    final savedImage = await _storedImage.copy('${appDirectory.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150,
          height: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.grey,)
          ),
          child: _storedImage != null ?
          Image.file(
            _storedImage,
            fit: BoxFit.cover,
            width: double.infinity,
          )
              :
          Text("No image taken",
            textAlign: TextAlign.center,),
        ),
        SizedBox(width: 10,),
        Expanded(
            child: TextButton.icon(
              icon: Icon(Icons.camera),
              label: Text("Take a picture"),
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),),
              onPressed: _takePicture,
            )
        ),
      ],
    );
  }
}
