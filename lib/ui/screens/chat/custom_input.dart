// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:image_picker/image_picker.dart';
// import 'package:uuid/uuid.dart';

// class CustomInput extends StatefulWidget {
//   final types.User user;
//   final Function(types.PartialText) onSendPressed;
//   final Function(types.ImageMessage) onImageSendPressed;

//   CustomInput({
//     required this.user,
//     required this.onSendPressed,
//     required this.onImageSendPressed,
//   });

//   @override
//   _CustomInputState createState() => _CustomInputState();
// }

// class _CustomInputState extends State<CustomInput> {
//   final TextEditingController _controller = TextEditingController();
//   File? _imageFile;
//   Image? _selectedImage;
//   XFile? _selectedXFile;

//   void _handleSendPressed() {
//     final text = _controller.text.trim();
//     if (text.isNotEmpty) {
//       widget.onSendPressed(types.PartialText(text: text));
//       _controller.clear();
//       _handleRemoveImage();
//     }
//   }

//   void _handleImageSelection() async {
//     final picker = ImagePicker();
//     final pickedFiles = await picker.pickMultiImage();

//     if (pickedFiles != null) {
//       showModalBottomSheet<void>(
//         context: context,
//         builder: (BuildContext context) {
//           return _buildImageSelectionModal(pickedFiles);
//         },
//       );
//     }
//   }

//   Widget _buildImageSelectionModal(List<XFile> images) {
//     return StatefulBuilder(
//       builder: (BuildContext context, StateSetter setModalState) {
//         return Column(
//           children: [
//             Expanded(
//               child: GridView.builder(
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   crossAxisSpacing: 4.0,
//                   mainAxisSpacing: 4.0,
//                 ),
//                 itemCount: images.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   final image = images[index];
//                   final isSelected = _selectedXFile?.path == image.path;
//                   return Stack(
//                     children: [
//                       Positioned.fill(
//                         child: Image.file(
//                           File(image.path),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       Positioned(
//                         right: 4,
//                         top: 4,
//                         child: Checkbox(
//                           value: isSelected,
//                           onChanged: (bool? value) {
//                             setModalState(() {
//                               _selectedXFile = value == true ? image : null;
//                             });
//                           },
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//             if (_selectedXFile != null)
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     _sendSelectedImage();
//                   },
//                   child: Text('Gửi ảnh'),
//                 ),
//               ),
//           ],
//         );
//       },
//     );
//   }

//   void _sendSelectedImage() async {
//     if (_selectedXFile != null) {
//       final bytes = await _selectedXFile!.readAsBytes();
//       final image = await decodeImageFromList(bytes);

//       final imageMessage = types.ImageMessage(
//         author: widget.user,
//         createdAt: DateTime.now().millisecondsSinceEpoch,
//         height: image.height.toDouble(),
//         id: const Uuid().v4(),
//         name: _selectedXFile!.name,
//         size: bytes.length,
//         uri: _selectedXFile!.path,
//         width: image.width.toDouble(),
//       );

//       widget.onImageSendPressed(imageMessage);

//       setState(() {
//         _imageFile = File(_selectedXFile!.path);
//         _selectedImage = Image.file(_imageFile!);
//         _selectedXFile = null;
//       });
//     }
//   }

//   void _handleRemoveImage() {
//     setState(() {
//       _imageFile = null;
//       _selectedImage = null;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.grey.shade200,
//       padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
//       child: Row(
//         children: [
//           if (_selectedImage == null)
//             IconButton(
//               icon: Icon(Icons.photo),
//               onPressed: _handleImageSelection,
//             ),
//           if (_selectedImage != null) ...[
//             Stack(
//               children: [
//                 Container(
//                   width: 50,
//                   height: 50,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(8.0),
//                     child: _selectedImage,
//                   ),
//                 ),
//                 Positioned(
//                   right: 0,
//                   top: 0,
//                   child: IconButton(
//                     icon: Icon(Icons.close),
//                     onPressed: _handleRemoveImage,
//                     color: Colors.red,
//                     iconSize: 16,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(width: 8.0),
//           ],
//           Expanded(
//             child: _selectedImage == null
//                 ? TextField(
//                     controller: _controller,
//                     decoration: InputDecoration.collapsed(
//                       hintText: 'Type a message',
//                     ),
//                   )
//                 : Container(), // Empty container to replace TextField when an image is selected
//           ),
//           IconButton(
//             icon: Icon(Icons.send),
//             onPressed: _handleSendPressed,
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomInput extends StatefulWidget {
  final bool isEmpty;
  final Function(String) onChanged;
  final VoidCallback? onPressed;
  final TextEditingController textController;
  final Function(List<File>) onImagesSelected;

  CustomInput({
    required this.isEmpty,
    required this.onChanged,
    required this.onPressed,
    required this.textController,
    required this.onImagesSelected,
  });

  @override
  _CustomInputState createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  List<File>? _selectedImages;

  void _handleImageSelection() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        _selectedImages = pickedFiles.map((e) => File(e.path)).toList();
      });

      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return _buildImageSelectionModal();
        },
      );
    }
  }

  Widget _buildImageSelectionModal() {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemCount: _selectedImages!.length,
            itemBuilder: (BuildContext context, int index) {
              final image = _selectedImages![index];
              return Image.file(
                image,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onImagesSelected(_selectedImages!);
            },
            child: Text('Gửi ảnh'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.photo),
            onPressed: _handleImageSelection,
          ),
          Expanded(
            child: TextField(
              controller: widget.textController,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                hintText: 'Nhập tin nhắn...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: widget.isEmpty ? Colors.grey : Theme.of(context).primaryColor,
            onPressed: widget.onPressed,
          ),
        ],
      ),
    );
  }
}

