import 'dart:math';

import 'package:flutter/material.dart';
import 'package:music_player/bottomControls.dart';
import 'package:music_player/songs.dart';
import 'package:music_player/theme.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new MaterialApp(
        //导航栏 名字
        title: "Night Sky",
        debugShowCheckedModeBanner: false,
        //App 样式
        theme: new ThemeData(
          primaryColor: Colors.lightBlue,
          primarySwatch: Colors.lightBlue,
        ),
        home: new MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: const Color(0xFFDDDDDD),
            onPressed: () {}),
        title: new Text(''),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.menu),
              color: const Color(0xFFDDDDDD),
              onPressed: () {}),
        ],
      ),
      body: Column(
        children: <Widget>[
          // seek bar
          new Expanded(
            child: new Center(
              child: new Container(
                width: 140.0,
                height: 140.0,
                child: new RadialSeekBar(
                  trackColor: Color(0xFFDDDDDDD),
                  progressPercent: 0.2,
                  progressColor: accentColor,
                  thumbPosition: 0.2,
                  thumbColor: lightAccentColor,
                  innerPadding: const EdgeInsets.all(10.0),
                  outerPadding: const EdgeInsets.all(10.0),
                  child: new ClipOval(
                    clipper: new CircleClipper(),
                    child: new Image.network(
                      demoPlaylist.songs[0].albumArtUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // visualizer
          new Container(
            width: double.infinity,
            height: 125.0,
          ),

          // song title, artist name ,and controls
          new ButtonControls(),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(MyHomePage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
}

class RadialSeekBar extends StatefulWidget {
  final double trackWidth;
  final Color trackColor;
  final double progressWidth;
  final Color progressColor;
  final double progressPercent;
  final double thumbSize;
  final Color thumbColor;
  final double thumbPosition;
  final EdgeInsets outerPadding;
  final EdgeInsets innerPadding;
  final Widget child;

  RadialSeekBar({
    this.trackWidth = 3.0,
    this.trackColor = Colors.grey,
    this.progressWidth = 5.0,
    this.progressColor = Colors.black,
    this.progressPercent = 0.0,
    this.thumbSize = 10.0,
    this.thumbColor = Colors.black,
    this.thumbPosition = 0.0,
    this.outerPadding = const EdgeInsets.all(0.0),
    this.innerPadding = const EdgeInsets.all(0.0),
    this.child,
  });

  @override
  RadialSeekBarState createState() => new RadialSeekBarState();
}

class RadialSeekBarState extends State<RadialSeekBar> {

  EdgeInsets _insetsForPainter(){
    final outerThickness = max(
      widget.trackWidth,
      max(
        widget.progressWidth,
        widget.thumbSize,
      ),
    )/ 2.0;
    return new EdgeInsets.all(outerThickness);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.outerPadding,
      child: new CustomPaint(
        foregroundPainter: new RadialSeekBarPainter(
            trackWidth: widget.trackWidth,
            trackColor: widget.trackColor,
            progressColor: widget.progressColor,
            progressWidth: widget.progressWidth,
            progressPercent: widget.progressPercent,
            thumbSize: widget.thumbSize,
            thumbColor: widget.thumbColor,
            thumbPosition: widget.thumbPosition),
        child: Padding(
          padding: _insetsForPainter() + widget.innerPadding,
          child: widget.child,
        ),
      ),
    );
  }
}

class RadialSeekBarPainter extends CustomPainter {
  final double trackWidth;
  final Paint trackPaint;
  final double progressWidth;
  final Paint progressPaint;
  final double progressPercent;
  final double thumbSize;
  final Paint thumbPaint;
  final double thumbPosition;

  RadialSeekBarPainter({
    @required this.trackWidth,
    @required trackColor,
    @required this.progressWidth,
    @required progressColor,
    @required this.progressPercent,
    @required this.thumbSize,
    @required thumbColor,
    @required this.thumbPosition,
  })
      : trackPaint = new Paint()
    ..color = trackColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = trackWidth,
        progressPaint = new Paint()
          ..color = progressColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = progressWidth
          ..strokeCap = StrokeCap.round,
        thumbPaint = new Paint()
          ..color = thumbColor
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    final outerThickness = max(trackWidth,max(progressWidth,thumbSize));
    Size contrainedSize = new Size(
        size.width - outerThickness,
        size.height - outerThickness
    );

    final center = new Offset(size.width / 2, size.height / 2);
    final radius = min(contrainedSize.width, contrainedSize.height) / 2;

    // Paint track
    canvas.drawCircle(
      //center
      center,
      //radius
      radius,
      //paint
      trackPaint,
    );

    // Paint progress
    final progressAngle = 2 * pi * progressPercent;
    canvas.drawArc(
        new Rect.fromCircle(
          center: center,
          radius: radius,
        ),
        -pi / 2,
        progressAngle,
        null,
        progressPaint);

    // Paint thumb
    final thumbAngle = 2 * pi * thumbPosition - (pi / 2);
    final thumbX = cos(thumbAngle) * radius;
    final thumbY = sin(thumbAngle) * radius;
    final thumbCenter = new Offset(thumbX, thumbY) + center;
    final thumbRadius = thumbSize / 2.0;
    canvas.drawCircle(
        thumbCenter,
        thumbRadius,
        thumbPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
