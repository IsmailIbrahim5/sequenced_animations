library sequence_animation;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class SequencedAnimationsController {
  Function? forward;
  Function? reverse;

  bool isReversing = false;
  bool isForwarding = false;

  bool completed = true;
  bool dismissed = false;
  SequencedAnimationsController();
}

class SequencedAnimationsBuilder extends StatefulWidget {
  final Widget Function(List<double> values, [List<Widget>? children]) builder;
  final int animations;
  final Duration duration;
  final Duration? reverseDuration;
  final bool repeat;
  final bool reverse;
  final double delay;
  final Curve curve;
  final Curve? reverseCurve;
  final Function? endCallback;
  final List<Widget>? children;
  final SequencedAnimationsController? controller;
  const SequencedAnimationsBuilder({
    super.key,
    required this.builder,
    required this.animations,
    this.duration = const Duration(milliseconds: 400),
    this.repeat = false,
    this.reverse = true,
    this.delay = .25,
    this.reverseDuration,
    this.reverseCurve,
    this.curve = Curves.linear,
    this.endCallback,
    this.children,
    this.controller,
  });

  @override
  State<SequencedAnimationsBuilder> createState() =>
      _SequencedAnimationsBuilderState();
}

class _SequencedAnimationsBuilderState extends State<SequencedAnimationsBuilder> {
  late List<double> values;
  late Ticker _ticker;

  final ValueNotifier<int> _tickerValue = ValueNotifier(0);


  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.controller?.forward = initTicker;
    widget.controller?.reverse = reverse;
    initTicker();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: _tickerValue,
    builder: (context, value, child) {
      if (values.length != widget.animations) {
        values = List.generate(widget.animations, (index) => 1);
      }
      return widget.builder(values, widget.children);
    },
  );

  void initTicker() {
    values = List.generate(widget.animations, (index) => 0);
    widget.controller?.isForwarding = true;
    widget.controller?.completed = false;
    _ticker = Ticker((elapsed) {
      for (int i = 0; i < values.length; i++) {
        values[i] = (elapsed.inMilliseconds / widget.duration.inMilliseconds) +
            (widget.delay * i) * (widget.repeat ? 1.0 : -1.0);

        if (values[i] < 0) values[i] = 0;

        if (values[i] > 1.0) {
          if (widget.repeat) {
            if (widget.reverse) {
              if (values[i].toInt() % 2 == 0) {
                values[i] = values[i] % 1;
              } else {
                values[i] = 1 - (values[i] % 1);
              }
            } else {
              values[i] = values[i] % 1;
            }
          } else if (i == values.length - 1) {
            widget.controller?.isForwarding = false;
            widget.controller?.dismissed = true;
            widget.endCallback?.call();
            _ticker.stop();
            values[i] = 1;
          } else {
            values[i] = 1;
          }
        }
        values[i] = widget.curve.transform(values[i]);
      }
      _tickerValue.value = elapsed.inMilliseconds;
    });
    _ticker.start();
  }

  void reverse() {
    _ticker.stop();
    widget.controller?.isReversing = true;
    widget.controller?.dismissed = false;

    _ticker = Ticker((elapsed) {
      for (int i = 0; i < values.length; i++) {
        values[i] = (elapsed.inMilliseconds /
            (widget.reverseDuration?.inMilliseconds ??
                widget.duration.inMilliseconds)) +
            (widget.delay * -(values.length - 1 - i));
        if (values[i] < 0) values[i] = 0;
        values[i] = 1 - values[i];
        if (values[i] < 0) {
          values[i] = 0;
          if (i == 0) {
            widget.controller?.isReversing = false;
            widget.controller?.completed = true;
            widget.endCallback?.call();
            _ticker.stop();
          }
        }
        values[i] = widget.reverseCurve?.transform(values[i]) ??
            widget.curve.transform(values[i]);
      }
      _tickerValue.value = elapsed.inMilliseconds;
    });
    _ticker.start();
  }
}
