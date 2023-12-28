import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../smart_widgets/online_status.dart';
import 'manual_viewmodel.dart';

class ManualView extends StatelessWidget {
  const ManualView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ManualViewModel>.reactive(
      onViewModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) {
        // print(model.node?.lastSeen);
        return Scaffold(
          appBar: AppBar(
            title: const Text('NaviGest Manual'),
            centerTitle: true,
            actions: const [IsOnlineWidget()],
          ),
          body: const _HomeBody(),
        );
      },
      viewModelBuilder: () => ManualViewModel(),
    );
  }
}

class _HomeBody extends ViewModelWidget<ManualViewModel> {
  const _HomeBody({Key? key}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, ManualViewModel model) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ConditionButton(
              text1: "Light ON",
              text2: "Light OFF",
              isTrue: model.deviceData.r1,
              onTap: model.setR1,
            ),
            ConditionButton(
              text1: "Pump ON",
              text2: "Pump OFF",
              isTrue: model.deviceData.r2,
              onTap: model.setR2,
            ),
            ConditionButton(
              text1: "Fan ON",
              text2: "Fan OFF",
              isTrue: model.deviceData.r3,
              onTap: model.setR3,
            ),
            ConditionButton(
              text1: "Lamp ON",
              text2: "Lamp OFF",
              isTrue: model.deviceData.r4,
              onTap: model.setR4,
            ),
            ConditionButton(
              text1: "Hangup",
              text2: "Call nurse",
              isTrue: model.isCalling,
              onTap: model.callNumber,
            ),
          ],
        ),
      ),
    );
  }
}

class ConditionButton extends StatelessWidget {
  final String text1;
  final String text2;
  final bool isTrue;
  final VoidCallback onTap;

  const ConditionButton({
    required this.text1,
    required this.text2,
    required this.isTrue,
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
          color: isTrue ? Colors.red : Colors.green,
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
