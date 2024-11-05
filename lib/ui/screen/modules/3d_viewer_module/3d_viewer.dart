// import 'package:flutter/material.dart';
// import 'package:model_viewer_plus/model_viewer_plus.dart';

// class ViewerScreen3D extends StatefulWidget {
//   String? src;
//   ViewerScreen3D({Key? key, this.src}) : super(key: key);

//   @override
//   State<ViewerScreen3D> createState() => _ViewerScreen3DState();
// }

// class _ViewerScreen3DState extends State<ViewerScreen3D> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Model Viewer")),
//       body: ModelViewer(
//         backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
//         src: 'assets/abc.glb', // a bundled asset file
//         ar: true,
//         arModes: ['scene-viewer', 'webxr', 'quick-look'],
//         autoRotate: true,
//         cameraControls: true,
//         iosSrc: 'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
//         disableZoom: true,
//       ),
//     );
//   }
// }
