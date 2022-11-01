import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:srsbkn/theme/app_theme.dart';
import 'package:srsbkn/theme/theme_type.dart';

class MusicPlayer extends StatefulWidget {
  final Map songInfo;
  const MusicPlayer({required this.songInfo});

  @override
  MusicPlayerState createState() => MusicPlayerState();
}

class MusicPlayerState extends State<MusicPlayer> {
  bool isDark = false;
  bool buffered = false;

  double minimumValue = 0.0, maximumValue = 0.0, currentValue = 0.0;
  String currentTime = '', endTime = '';
  bool isPlaying = false;
  final AudioPlayer player = AudioPlayer();

  void initState() {
    super.initState();
    setSong(widget.songInfo);
  }

  void dispose() {
    super.dispose();
    player.dispose();
  }

  void setSong(songInfo) async {
    // widget.songInfo = songInfo;
    await player.setUrl(widget.songInfo["audio_location"]);
    buffered = true;
    currentValue = minimumValue;
    maximumValue = player.duration!.inMilliseconds.toDouble();
    setState(() {
      currentTime = getDuration(currentValue);
      endTime = getDuration(maximumValue);
    });
    isPlaying = false;
    changeStatus();
    player.positionStream.listen((duration) {
      currentValue = duration.inMilliseconds.toDouble();
      setState(() {
        currentTime = getDuration(currentValue);
      });
    });
  }

  void changeStatus() {
    setState(() {
      isPlaying = !isPlaying;
    });
    if (isPlaying) {
      player.play();
    } else {
      player.pause();
    }
  }

  String getDuration(double value) {
    Duration duration = Duration(milliseconds: value.round());

    return [duration.inMinutes, duration.inSeconds]
        .map((element) => element.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  Widget build(context) {
    isDark = AppTheme.themeType == ThemeType.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios_sharp,
                color: isDark ? Colors.white : Colors.black)),
        title: Text('Now Playing',
            style: TextStyle(color: isDark ? Colors.white : Colors.black)),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(5, 57, 5, 0),
        child: Column(children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment(-1.0, -4.0),
                    end: Alignment(1.0, 4.0),
                    colors: [
                      isDark ? Colors.black : Colors.white,
                      isDark ? Colors.black : Colors.white,
                    ]),
                borderRadius: BorderRadius.all(Radius.circular(35)),
                boxShadow: [
                  BoxShadow(
                      color: isDark ? Colors.black : Colors.grey,
                      offset: Offset(5.0, 5.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0),
                  BoxShadow(
                      color: isDark ? Colors.black : Colors.grey,
                      offset: Offset(-5.0, -5.0),
                      blurRadius: 18.0,
                      spreadRadius: 10.0),
                ]),
            child: Image(
              image: AssetImage('assets/gurujii.jpg'),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Expanded(
                child: Text(widget.songInfo["title"],
                    style: GoogleFonts.montserrat(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 25.0,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(5, 5, 5, 33),
            child: Text(
              widget.songInfo["description"],
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Slider(
            inactiveColor: isDark ? Colors.white54 : Colors.black12,
            activeColor: Colors.redAccent,
            min: minimumValue,
            max: maximumValue,
            value: currentValue,
            onChanged: (value) {
              currentValue = value;
              player.seek(Duration(milliseconds: currentValue.round()));
            },
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            transform: Matrix4.translationValues(0, -15, 0),
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(currentTime,
                    style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500)),
                Text(endTime,
                    style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // GestureDetector(
                //   child:
                //       Icon(Icons.skip_previous, color: Colors.black, size: 55),
                //   behavior: HitTestBehavior.translucent,
                //   onTap: () {
                //     widget.changeTrack(false);
                //   },
                // ),
                Stack(
                  children: [
                    !buffered
                        ? Center(
                            child: SizedBox(
                              height: 100.0,
                              width: 100.0,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).iconTheme.color!,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                    Center(
                      child: SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: GestureDetector(
                          child: Icon(
                              isPlaying
                                  ? Icons.pause_circle_filled_rounded
                                  : Icons.play_circle_fill_rounded,
                              color: isDark ? Colors.white : Colors.black,
                              size: 85),
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            changeStatus();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                // GestureDetector(
                //   child: Icon(Icons.skip_next, color: Colors.black, size: 55),
                //   behavior: HitTestBehavior.translucent,
                //   onTap: () {
                //     widget.changeTrack(true);
                //   },
                // ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
