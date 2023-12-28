import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../smart_widgets/online_status.dart';
import 'automatic_viewmodel.dart';

class AutomaticView extends StackedView<AutomaticViewModel> {
  const AutomaticView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AutomaticViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Face recognition"),
        actions: [
          const IsOnlineWidget(),
          IconButton(
            onPressed: viewModel.switchCam,
            icon: const Icon(Icons.camera_rear_sharp),
          )
        ],
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
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (viewModel.isEnable)
                    Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ConditionButtonWithSelection(
                            text1: "Light ON",
                            text2: "Light OFF",
                            isTrue: viewModel.deviceData.r1,
                            onTap: viewModel.setR1,
                            isSelected: viewModel.selectionIndex == 0,
                          ),
                          ConditionButtonWithSelection(
                            text1: "Pump ON",
                            text2: "Pump OFF",
                            isTrue: viewModel.deviceData.r2,
                            onTap: viewModel.setR2,
                            isSelected: viewModel.selectionIndex == 1,
                          ),
                          ConditionButtonWithSelection(
                            text1: "Fan ON",
                            text2: "Fan OFF",
                            isTrue: viewModel.deviceData.r3,
                            onTap: viewModel.setR3,
                            isSelected: viewModel.selectionIndex == 2,
                          ),
                          ConditionButtonWithSelection(
                            text1: "Lamp ON",
                            text2: "Lamp OFF",
                            isTrue: viewModel.deviceData.r4,
                            onTap: viewModel.setR4,
                            isSelected: viewModel.selectionIndex == 3,
                          ),
                          ConditionButtonWithSelection(
                            text1: "Hangup",
                            text2: "Call nurse",
                            isTrue: viewModel.isCalling,
                            onTap: viewModel.callNumber,
                            isSelected: viewModel.selectionIndex == 4,
                          ),
                          ConditionButtonWithSelection(
                            text1: "Disable",
                            text2: "Automatic",
                            isTrue: viewModel.isEnable,
                            onTap: viewModel.disable,
                            isSelected: viewModel.selectionIndex == 5,
                          ),
                        ],
                      ),
                    )
                  else
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.done_outline),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Blink 3 times to enable",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  AutomaticViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AutomaticViewModel();

  @override
  void onViewModelReady(AutomaticViewModel viewModel) {
    viewModel.onModelReady();
    super.onViewModelReady(viewModel);
  }
}

class ConditionButtonWithSelection extends StatelessWidget {
  final String text1;
  final String text2;
  final bool isTrue;
  final bool isSelected;
  final VoidCallback onTap;

  const ConditionButtonWithSelection({
    required this.text1,
    required this.text2,
    required this.isTrue,
    required this.isSelected,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected
              ? Colors.green
              : isTrue
                  ? Colors.red
                  : Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: ClipRRect(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                isTrue ? text1 : text2,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
