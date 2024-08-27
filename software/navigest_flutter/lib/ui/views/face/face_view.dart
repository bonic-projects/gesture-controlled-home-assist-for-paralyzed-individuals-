import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../smart_widgets/online_status.dart';
import 'face_viewmodel.dart';

class FaceView extends StackedView<FaceViewModel> {
  const FaceView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    FaceViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Face recognition"),
        actions: const [IsOnlineWidget()],
      ),
      body: Stack(
        children: [
          if (viewModel.cameraFeedReady)
            Positioned(
              child: SizedBox(
                height: 720,
                width: 1180,
                child: viewModel.customPaint,
              ),
            ),
          if (viewModel.cameraFeedReady)
            Center(
              child: CameraPreview(
                viewModel.camController!,
                child: viewModel.customPaint,
              ),
            ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (viewModel.leftEyeOpenProb != null &&
                          viewModel.leftEyeOpenProb! > 90)
                        const Icon(
                          Icons.remove_red_eye_outlined,
                          size: 60,
                        ),
                      if (viewModel.rightEyeOpenProb != null &&
                          viewModel.rightEyeOpenProb! > 90)
                        const Icon(
                          Icons.remove_red_eye_outlined,
                          size: 60,
                        ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (viewModel.smile != null && viewModel.smile! > 20)
                        const Icon(
                          Icons.emoji_emotions_outlined,
                          size: 60,
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Blinks count: ${viewModel.count}",
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  FaceViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      FaceViewModel();

  @override
  void onViewModelReady(FaceViewModel viewModel) {
    viewModel.onModelReady();
    super.onViewModelReady(viewModel);
  }
}
