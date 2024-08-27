import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:stacked/stacked.dart';

import '../app/app.logger.dart';

class SttService with ListenableServiceMixin {
  final log = getLogger('SttService');

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  String get lastWords => _lastWords;

  /// This has to happen only once per app
  Future<bool?> initSpeech(Function(String)? onStatus,
      Function(SpeechRecognitionError) onError) async {
    try {
      log.i("Speech recognition init");
      _speechEnabled = await _speechToText.initialize(
        onStatus: onStatus,
        onError: onError,
      );
      return _speechEnabled;
    } catch (e) {
      log.e("Error $e");
    }
    return false;
    // setState(() {});
  }

  final List<String> _languages = ["en_IN", "ml_IN"];

  /// Each time to start a speech recognition session
  void startListening(
      Function(String text, bool isFinish)? onSpeech, int languageIndex) async {
    log.i("Speech recog started");
    _onSpeech = onSpeech;
    await _speechToText.listen(
      onResult: _onSpeechResult,
      localeId: _languages[languageIndex],
    );
    // setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void stopListening() async {
    log.i("Speech stopped");
    await _speechToText.stop();
    // setState(() {});
  }

  Function(String text, bool isFinish)? _onSpeech;
  Function(String text)? _onStatus;

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    // log.i(result.finalResult);
    // setState(() {
    _lastWords = result.recognizedWords;
    notifyListeners();
    // log.i(_lastWords);
    _onSpeech?.call(_lastWords, result.finalResult);
    // });
  }
}
