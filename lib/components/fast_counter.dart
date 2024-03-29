import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fast_provider.dart';
import '../providers/people_provider.dart';
import '../providers/theme_provider.dart';
import 'dart:async';

class FastCounter extends StatefulWidget {
  final int amount;

  const FastCounter({super.key, required this.amount});

  @override
  State<FastCounter> createState() => _FastCounterState();
}

class _FastCounterState extends State<FastCounter> {
  Timer? _timer;
  bool _longPressCanceled = false;

  void _cancelIncrease() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _longPressCanceled = true;
  }

  @override
  Widget build(BuildContext context) {
    final peopleProvider = Provider.of<PeopleProvider>(context);
    final fastProvider = Provider.of<FastProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    var user = peopleProvider.currentUser;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 140),
          child: Text(
            "Days:",
            style: TextStyle(
              fontSize: 32,
              color: themeProvider.text(),
              // fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: GestureDetector(
                  onLongPressEnd: (LongPressEndDetails longPressEndDetails) {
                    _cancelIncrease();
                  },
                  onLongPress: () {
                    _longPressCanceled = false;
                    Future.delayed(const Duration(milliseconds: 0), () {
                      if (!_longPressCanceled) {
                        _timer = Timer.periodic(
                            const Duration(milliseconds: 50), (timer) {
                          fastProvider.incrementOperation(-1, user);
                        });
                      }
                    });
                  },
                  onLongPressUp: () {
                    _cancelIncrease();
                  },
                  child: FloatingActionButton(
                    elevation: widget.amount > 0 ? 3 : 0,
                    heroTag: 'fast' 'plus',
                    onPressed: () async {
                      fastProvider.incrementOperation(-1, user);
                    },
                    backgroundColor: widget.amount > 0
                        ? themeProvider.minus()
                        : themeProvider.minusDisabled(),
                    child: const Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  widget.amount.toString(),
                  style: TextStyle(fontSize: 63.0, color: themeProvider.text()),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 4,
                child: GestureDetector(
                  onLongPressEnd: (LongPressEndDetails longPressEndDetails) {
                    _cancelIncrease();
                  },
                  onLongPress: () {
                    _longPressCanceled = false;
                    Future.delayed(const Duration(milliseconds: 300), () {
                      if (!_longPressCanceled) {
                        _timer = Timer.periodic(
                            const Duration(milliseconds: 50), (timer) {
                          fastProvider.incrementOperation(1, user);
                        });
                      }
                    });
                  },
                  onLongPressUp: () {
                    _cancelIncrease();
                  },
                  child: FloatingActionButton(
                    elevation: 3,
                    heroTag: 'fast' 'minus',
                    onPressed: () => fastProvider.incrementOperation(1, user),
                    backgroundColor: themeProvider.plus(),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
