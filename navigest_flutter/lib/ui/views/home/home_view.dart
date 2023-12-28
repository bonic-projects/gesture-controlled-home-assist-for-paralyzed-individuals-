import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      // onViewModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) {
        // print(model.node?.lastSeen);
        return Scaffold(
          appBar: AppBar(
            title: const Text('NaviGest'),
            actions: [
              IconButton(
                  onPressed: model.logout, icon: const Icon(Icons.logout))
            ],
          ),
          body: GridView.count(
            crossAxisCount: 2,
            children: [
              Option(
                  name: 'Manual control',
                  onTap: model.openInControlView,
                  file: 'assets/lottie/control.json'),
              Option(
                  name: 'Speech',
                  onTap: model.openSpeechView,
                  file: 'assets/lottie/speech.json'),
              // Option(
              //     name: 'Object Train',
              //     onTap: model.openTrainView,
              //     file: 'assets/lottie/face.json'),
              Option(
                  name: 'Face recog',
                  onTap: model.openFaceTestView,
                  file: 'assets/lottie/face.json'),
              Option(
                  name: 'Automatic',
                  onTap: model.openAutomaticView,
                  file: 'assets/lottie/patient.json'),
            ],
          ),
        );
      },
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}

class Option extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  final String file;

  const Option(
      {Key? key, required this.name, required this.onTap, required this.file})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 1.5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: onTap,
          child: Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.all(0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: Lottie.asset(file),
                      )),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(6)),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
