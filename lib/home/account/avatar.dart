import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String? photoUrl;

  const Avatar({Key? key, this.photoUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle, border: Border.all(color: Colors.teal)),
      child: CircleAvatar(
        radius: 50.0,
        backgroundColor: Colors.black12,
        backgroundImage: photoUrl != null
            ? NetworkImage(photoUrl!)
            : const AssetImage('images/profile1.jpg') as ImageProvider,
        // error:The argument type 'Object' can't be assigned to the parameter type 'ImageProvider<Object>' Solved--> as ImageProvider

        // child: photoUrl == null ? Icon(Icons.camera_alt, size: 50.0) : null,
      ),
    );
  }
}
