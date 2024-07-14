import 'package:flutter/material.dart';

import 'package:assets_audio_player/assets_audio_player.dart';

class PlayerWidget extends StatefulWidget {
  const PlayerWidget({super.key});

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  void initPlayer() async {
    await assetsAudioPlayer.open(
      // Audio("assets/1.mp3"),
      Playlist(
        audios: [
          Audio(
            "assets/1.mp3",
            metas: Metas(
              title: 'Guitar',
            ),
          ),
          Audio(
            "assets/2.mp3",
            metas: Metas(
              title: 'Piano',
            ),
          ),
          Audio(
            "assets/3.mp3",
            metas: Metas(
              title: 'Flute',
            ),
          ),
        ],
      ),
      autoStart: false,
      loopMode: LoopMode.playlist,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text(
          //   'Test audio',
          //   style: Theme.of(context).textTheme.headlineMedium,
          // ),
          // IconButton(
          //   onPressed: () async {
          //     await assetsAudioPlayer.open(
          //         // Audio("assets/1.mp3"),
          //         Playlist(
          //       audios: [
          //         Audio("assets/1.mp3"),
          //         Audio("assets/2.mp3"),
          //         Audio("assets/3.mp3"),
          //       ],
          //     ));
          //   },
          //   icon: assetsAudioPlayer.builderIsPlaying(
          //     builder: (context, isPlaying) {
          //       return Icon(isPlaying ? Icons.pause : Icons.play_arrow);
          //     },
          //   ),
          // ),

          Container(
            height: 400,
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Center(
              child: StreamBuilder(
                  stream: assetsAudioPlayer.realtimePlayingInfos,
                  builder: (context, snapShots) {
                    if (snapShots.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            assetsAudioPlayer.getCurrentAudioTitle == ''
                                ? 'Play Audio'
                                : assetsAudioPlayer.getCurrentAudioTitle,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: snapShots.data?.current?.index == 0
                                      ? null
                                      : () {
                                          assetsAudioPlayer.previous();
                                        },
                                  icon: const Icon(Icons.skip_previous)),
                              getBtnWidget,
                              IconButton(
                                onPressed: snapShots.data?.current?.index ==
                                        (assetsAudioPlayer
                                                    .playlist?.audios.length ??
                                                0) -
                                            1
                                    ? null
                                    : () {
                                        assetsAudioPlayer.next(
                                          stopIfLast: true,
                                          keepLoopMode: false,
                                        );
                                      },
                                icon: const Icon(Icons.skip_next),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Slider(
                            inactiveColor: Colors.grey,
                            value: snapShots.data?.currentPosition.inSeconds
                                    .toDouble() ??
                                0.0,
                            min: 0,
                            max:
                                snapShots.data?.duration.inSeconds.toDouble() ??
                                    0.0,
                            onChanged: (value) {
                              assetsAudioPlayer.seek(
                                Duration(
                                  seconds: value.toInt(),
                                ),
                              );
                            },
                          ),
                          Text(
                            '${convertSeconds(snapShots.data?.currentPosition.inSeconds ?? 0)} / ${convertSeconds(snapShots.data?.duration.inSeconds ?? 0)}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget get getBtnWidget => assetsAudioPlayer.builderIsPlaying(
        builder: (context, isPlaying) => FloatingActionButton.large(
          onPressed: () {
            // assetsAudioPlayer.open(
            //   // Audio("assets/1.mp3"),
            //   Playlist(
            //     audios: [
            //       Audio(
            //         "assets/1.mp3",
            //         metas: Metas(
            //           title: '1',
            //         ),
            //       ),
            //       Audio(
            //         "assets/2.mp3",
            //         metas: Metas(
            //           title: '2',
            //         ),
            //       ),
            //       Audio(
            //         "assets/3.mp3",
            //         metas: Metas(
            //           title: '3',
            //         ),
            //       ),
            //     ],
            //   ),
            // );
            isPlaying ? assetsAudioPlayer.pause() : assetsAudioPlayer.play();
            setState(() {});
          },
          shape: const CircleBorder(),
          child: assetsAudioPlayer.builderIsPlaying(
            builder: (context, isPlaying) {
              return Icon(size: 70, isPlaying ? Icons.pause : Icons.play_arrow);
            },
          ),
        ),
      );
  String convertSeconds(int seconds) {
    String minutes = (seconds ~/ 60).toString();
    String secondsStr = (seconds % 60).toString();
    return '${minutes.padLeft(2, '0')}:${secondsStr.padLeft(2, '0')}';
  }
}
