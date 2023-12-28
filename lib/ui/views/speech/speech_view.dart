import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../smart_widgets/online_status.dart';
import '../manual/manual_view.dart';
import 'speech_viewmodel.dart';

class SpeechView extends StackedView<SpeechViewModel> {
  const SpeechView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SpeechViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Speech control"),
        actions: const [IsOnlineWidget()],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (viewModel.isMic)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.mic,
                            color: Colors.green,
                          ),
                        ),
                        Text("Listening..")
                      ],
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("Not listening"),
                  ),
                CircleAvatar(
                  radius: 30,
                  // backgroundColor: Color(0xff94d500),
                  child: IconButton(
                    icon: const Icon(
                      Icons.mic,
                      color: Colors.white,
                    ),
                    onPressed: viewModel.startListen,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ViewerText(
              text: viewModel.lastWords,
              icon: Icons.mic,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ConditionButton(
                  text1: "Light ON",
                  text2: "Light OFF",
                  isTrue: viewModel.deviceData.r1,
                  onTap: viewModel.setR1,
                ),
                ConditionButton(
                  text1: "Pump ON",
                  text2: "Pump OFF",
                  isTrue: viewModel.deviceData.r2,
                  onTap: viewModel.setR2,
                ),
                ConditionButton(
                  text1: "Fan ON",
                  text2: "Fan OFF",
                  isTrue: viewModel.deviceData.r3,
                  onTap: viewModel.setR3,
                ),
                ConditionButton(
                  text1: "Lamp ON",
                  text2: "Lamp OFF",
                  isTrue: viewModel.deviceData.r4,
                  onTap: viewModel.setR4,
                ),
                ConditionButton(
                  text1: "Hangup",
                  text2: "Call nurse",
                  isTrue: viewModel.isCalling,
                  onTap: viewModel.callNumber,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  SpeechViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SpeechViewModel();

  @override
  void onViewModelReady(SpeechViewModel viewModel) {
    viewModel.onModelReady();
    super.onViewModelReady(viewModel);
  }
}

class ViewerText extends StatelessWidget {
  final String text;
  final IconData icon;

  const ViewerText({Key? key, required this.text, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Stack(
        children: [
          // Positioned(top: 0, right: 0, child: Icon(icon)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    ));
  }
}
