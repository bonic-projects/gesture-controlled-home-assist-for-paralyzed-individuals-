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

// class _TempMeter extends ViewModelWidget<ManualViewModel> {
//   final double value;
//   const _TempMeter({required this.value, Key? key})
//       : super(key: key, reactive: true);
//
//   @override
//   Widget build(BuildContext context, ManualViewModel model) {
//     Widget _buildThermometer(BuildContext context) {
//       final Brightness brightness = Theme.of(context).brightness;
//       return Center(
//           child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 /// Linear gauge to display celsius scale.
//                 SfLinearGauge(
//                   minimum: -20,
//                   maximum: 50,
//                   interval: 10,
//                   minorTicksPerInterval: 2,
//                   axisTrackExtent: 23,
//                   axisTrackStyle: LinearAxisTrackStyle(
//                       thickness: 12,
//                       color: Colors.white,
//                       borderWidth: 1,
//                       edgeStyle: LinearEdgeStyle.bothCurve),
//                   tickPosition: LinearElementPosition.outside,
//                   labelPosition: LinearLabelPosition.outside,
//                   orientation: LinearGaugeOrientation.vertical,
//                   markerPointers: <LinearMarkerPointer>[
//                     LinearWidgetPointer(
//                         markerAlignment: LinearMarkerAlignment.end,
//                         value: 50,
//                         enableAnimation: false,
//                         position: LinearElementPosition.outside,
//                         offset: 8,
//                         child: SizedBox(
//                           height: 30,
//                           child: Text(
//                             '°C',
//                             style: TextStyle(
//                                 fontSize: 12, fontWeight: FontWeight.bold),
//                           ),
//                         )),
//                     LinearShapePointer(
//                       value: -20,
//                       markerAlignment: LinearMarkerAlignment.start,
//                       shapeType: LinearShapePointerType.circle,
//                       borderWidth: 1,
//                       borderColor: brightness == Brightness.dark
//                           ? Colors.white30
//                           : Colors.black26,
//                       color: value > 30
//                           ? const Color(0xffFF7B7B)
//                           : const Color(0xff0074E3),
//                       position: LinearElementPosition.cross,
//                       width: 24,
//                       height: 24,
//                     ),
//                     LinearShapePointer(
//                       value: -20,
//                       markerAlignment: LinearMarkerAlignment.start,
//                       shapeType: LinearShapePointerType.circle,
//                       borderWidth: 6,
//                       borderColor: Colors.transparent,
//                       color: value > 30
//                           ? const Color(0xffFF7B7B)
//                           : const Color(0xff0074E3),
//                       position: LinearElementPosition.cross,
//                       width: 24,
//                       height: 24,
//                     ),
//                     LinearWidgetPointer(
//                         value: -20,
//                         markerAlignment: LinearMarkerAlignment.start,
//                         child: Container(
//                           width: 10,
//                           height: 3.4,
//                           decoration: BoxDecoration(
//                             border: Border(
//                               left: BorderSide(width: 2.0, color: Colors.black),
//                               right:
//                                   BorderSide(width: 2.0, color: Colors.black),
//                             ),
//                             color: value > 30
//                                 ? const Color(0xffFF7B7B)
//                                 : const Color(0xff0074E3),
//                           ),
//                         )),
//                     // LinearWidgetPointer(
//                     //     value: value,
//                     //     enableAnimation: false,
//                     //     position: LinearElementPosition.outside,
//                     //     // onChanged: (dynamic value) {
//                     //     //   setState(() {
//                     //     //     _meterValue = value as double;
//                     //     //   });
//                     //     // },
//                     //     child: Container(
//                     //         width: 16,
//                     //         height: 12,
//                     //         transform: Matrix4.translationValues(4, 0, 0.0),
//                     //         child: Image.asset(
//                     //           'images/triangle_pointer.png',
//                     //           color: value > 30
//                     //               ? const Color(0xffFF7B7B)
//                     //               : const Color(0xff0074E3),
//                     //         ))),
//                     LinearShapePointer(
//                       value: value,
//                       width: 20,
//                       height: 20,
//                       enableAnimation: false,
//                       color: Colors.transparent,
//                       position: LinearElementPosition.cross,
//                       // onChanged: (dynamic value) {
//                       //   setState(() {
//                       //     _meterValue = value as double;
//                       //   });
//                       // },
//                     )
//                   ],
//                   barPointers: <LinearBarPointer>[
//                     LinearBarPointer(
//                       value: value,
//                       enableAnimation: false,
//                       thickness: 6,
//                       edgeStyle: LinearEdgeStyle.endCurve,
//                       color: value > 30
//                           ? const Color(0xffFF7B7B)
//                           : const Color(0xff0074E3),
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Card(
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
//               child: Text("$value"),
//             ),
//           ),
//         ],
//       ));
//     }
//
//     return _buildThermometer(context);
//   }
// }
