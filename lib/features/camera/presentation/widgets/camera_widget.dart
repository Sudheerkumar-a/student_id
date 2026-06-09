import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_id/features/camera/domain/entities/camera_capture.dart';
import 'package:student_id/features/camera/domain/entities/camera_screen_input.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key});

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  final int _cameraType = 0;
  CameraScreenInput? _args;

  void _initializeCamera(List<CameraDescription> cameras) {
    _controller?.dispose();
    _controller = CameraController(
      cameras[_cameraType],
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller!.initialize();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;

      final image = await _controller!.takePicture();

      if (!mounted || _args == null) return;

      await context.push(
        '/teacher-review',
        extra: CapturedPhoto(
          path: image.path,
          subject: _args!.subject,
        ),
      );
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra;
    if (extra is CameraScreenInput && _args != extra) {
      _args = extra;
      _initializeCamera(extra.cameras);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_args == null || _controller == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Take your picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              color: const Color.fromARGB(255, 0, 0, 0),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: CameraPreview(_controller!),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: _takePicture,
                        icon: const Icon(Icons.camera),
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
