import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:student_id/app_routes.dart';
import 'package:student_id/domain/entities/student_entity.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key});
  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;
  int _cameraType = 0;
  late CameraScreenInputsPojo _agrs;

  void _intializeCamera(List<CameraDescription> camera) {
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      camera[_cameraType],
      // Define the resolution to use.
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
    // Get a specific camera from the list of available cameras.
  }

  Future<void> _takePicture() async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;

      // Attempt to take a picture and get the file `image`
      // where it was saved.
      final image = await _controller.takePicture();

      if (!mounted) return;

      // If the picture was taken, display it on a new screen.
      await Navigator.of(context).pushNamed(AppRoutes.teacherReviewScreen,
          arguments: StudentEntity(
              name: _agrs.studentDetails.name,
              admissionNumber: _agrs.studentDetails.admissionNumber,
              profileUrl: image.path));
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    // Next, initialize the controller. This returns a Future.
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _agrs =
        ModalRoute.of(context)!.settings.arguments as CameraScreenInputsPojo;
    _intializeCamera(_agrs.cameras);
    return Scaffold(
      appBar: AppBar(title: const Text('Take your picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Container(
              color: const Color.fromARGB(255, 0, 0, 0),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: CameraPreview(_controller),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // IconButton(
                      //     onPressed: () {
                      //       setState(() {
                      //         _cameraType = _cameraType == 0 ? 1 : 0;
                      //       });
                      //     },
                      //     icon: const Icon(
                      //       Icons.flip_camera_android,
                      //       color: Colors.white,
                      //     )),
                      IconButton(
                        onPressed: () {
                          _takePicture();
                        },
                        icon: const Icon(Icons.camera),
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class CameraScreenInputsPojo {
  List<CameraDescription> cameras;
  StudentEntity studentDetails;
  CameraScreenInputsPojo(this.cameras, this.studentDetails);
}
