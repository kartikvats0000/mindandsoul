import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class MusicPlayerProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();


  Track? _currentTrack;
  PlayerState _playerState = PlayerState.stopped;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;


  AudioPlayer get audioPlayer => _audioPlayer;
  PlayerState get playerState => _playerState;
  Track? get currentTrack => _currentTrack;
  Track setTrack({title, thumbnail, audioUrl, gif}) => Track(title: title, thumbnail: thumbnail, audioUrl: audioUrl, gif: gif);
  Duration get position => _position;
  Duration get duration => _duration;

  ConcatenatingAudioSource _playlist = ConcatenatingAudioSource(children: []);

  void makePlaylist(ConcatenatingAudioSource concatenatingAudioSource){
    _playlist = concatenatingAudioSource;
   /* var list = List.generate(lst.length, (i) => AudioSource.uri(
        Uri.parse(lst[i].audioUrl),
        tag: MediaItem(
            id: '${i + 1}',
            title: lst[i].title,
            artist: 'Mind n Soul',
            artUri: Uri.parse(lst[i].thumbnail)
        )
    ),);
    _playlist = ConcatenatingAudioSource(children: list);*/
    notifyListeners();
  }

  /* _playlist = ConcatenatingAudioSource(children: [
        AudioSource.uri(
            Uri.parse(currentTrack!.audioUrl.toString()),
            tag: MediaItem(
                id: '1',
                title: currentTrack!.title,
                artist: 'Mind n Soul',
                artUri: Uri.parse(currentTrack!.thumbnail)
            )
        )
      ]);*/

  void play(Track track) async {

     _playlist = ConcatenatingAudioSource(children: [
        AudioSource.uri(
            Uri.parse(track.audioUrl.toString()),
            tag: MediaItem(
                id: '1',
                title: track.title,
                artist: 'Mind n Soul',
                artUri: Uri.parse(track.thumbnail)
            )
        ),
      ]);
    if (_currentTrack != track) {
      _currentTrack = track;

     /* _playlist = ConcatenatingAudioSource(children: [
        AudioSource.uri(
            Uri.parse(currentTrack!.audioUrl.toString()),
            tag: MediaItem(
                id: '1',
                title: currentTrack!.title,
                artist: 'Mind n Soul',
                artUri: Uri.parse(currentTrack!.thumbnail)
            )
        )
      ]);*/
    // await _audioPlayer.setUrl(track.audioUrl);
      await _audioPlayer.setAudioSource(_playlist);
      //_audioPlayer.play();
    }
     await _audioPlayer.setAudioSource(_playlist);

  /*  _playlist = ConcatenatingAudioSource(children: [
      AudioSource.uri(
        Uri.parse(currentTrack!.audioUrl.toString()),
        tag: MediaItem(
            id: '1',
            title: currentTrack!.title,
          artist: 'Mind n Soul',
          artUri: Uri.parse(currentTrack!.thumbnail)
        )
      )
    ]);*/
   // await _audioPlayer.setAudioSource(_playlist);
    _audioPlayer.pause();
    debugPrint(audioPlayer.currentIndex.toString());
    _playerState = PlayerState.playing;
    _audioPlayer.positionStream.listen((position) {
      _position = position;
      notifyListeners();
    });
    _audioPlayer.durationStream.listen((duration) {
      _duration = duration ?? Duration.zero;
      notifyListeners();
    });
    notifyListeners();
  }

  void pause() {
    _audioPlayer.pause();
    _playerState = PlayerState.paused;
    notifyListeners();
  }

  void stop() {
    _audioPlayer.stop();
    _playerState = PlayerState.stopped;
    _currentTrack = null;
    notifyListeners();
  }

  void seek(Duration duration){
    _audioPlayer.seek(duration);
  }
}

enum PlayerState { playing, paused, stopped }


class Track {
  final String title;
  final String thumbnail;
  final String audioUrl;
  final String gif;

  Track({
    required this.title,
    required this.thumbnail,
    required this.audioUrl,
    required this.gif
  });
}