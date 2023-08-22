import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mindandsoul/provider/themeProvider.dart';
import 'package:mindandsoul/provider/playerProvider.dart';
import 'package:provider/provider.dart';

import 'components.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    // final theme = Provider.of<ThemeProvider>(context);
    final musicPlayerProvider = Provider.of<MusicPlayerProvider>(context);
    final theme = Provider.of<ThemeProvider>(context,listen: false);

    return Visibility(
      visible: musicPlayerProvider.playerState != PlayerState.stopped,
      child: InkWell(
        onTap: (){
          Components(context).showPlayerSheet();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 10,sigmaX: 10),
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: 10.0,right: 10,left: 10),
                decoration: BoxDecoration(
                  color: theme.themeColorA.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child:
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(musicPlayerProvider.currentTrack?.thumbnail ?? 'https://www.altnews.in/wp-content/themes/newsbeat/images/wp-includes/images/media/audio.png',)),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                            musicPlayerProvider.currentTrack?.title ?? 'No Track',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Components(context).BlurBackgroundCircularButton(
                          buttonRadius: 20,
                          icon:
                          musicPlayerProvider.audioPlayer.playerState.playing == true
                              ? Icons.pause
                              : Icons.play_arrow,
                          onTap: () {
                            //print(musicPlayerProvider.audioPlayer.playerState);
                            if (musicPlayerProvider.audioPlayer.playerState.playing == true) {
                              musicPlayerProvider.audioPlayer.pause();
                            } else {
                              // Replace the Track instance with your actual track details.
                              //final track = musicPlayerProvider.currentTrack!;
                              //musicPlayerProvider.play(track);
                              musicPlayerProvider.audioPlayer.play();
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.clear,color: Colors.white70,),
                          onPressed: () {
                            musicPlayerProvider.stop();
                          },
                        ),

                      ],
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: LinearProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                        value: musicPlayerProvider.position.inSeconds/musicPlayerProvider.duration.inSeconds,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}