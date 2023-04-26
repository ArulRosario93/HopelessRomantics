library variables;

import 'package:audioplayers/audioplayers.dart';

bool ChangehasBeenDone = false;

String whatChangedName = "";
String whatChangedNickname = "";
String whatChangedBio = "";
List downloadURL = [];

bool playing = false;
AudioPlayer audioPlayer = AudioPlayer();

bool profileContainerAudioPlaying = false;
AudioPlayer profileContainerAudio = AudioPlayer();
