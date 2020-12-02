import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

const kDuration600 = Duration(milliseconds: 600);
const kDuration400 = Duration(milliseconds: 400);

class MySimpleDialog extends StatefulWidget {
  final bool isSuccess;
  final String errorMessage;

  MySimpleDialog({@required this.isSuccess, this.errorMessage = ''});

  @override
  _MySimpleDialogState createState() => _MySimpleDialogState();
}

class _MySimpleDialogState extends State<MySimpleDialog>
    with TickerProviderStateMixin {
  AnimationController _enterAnimationController;
  AnimationController _lottieController;
  Animation<Offset> _animation;

  @override
  void initState() {
    _enterAnimationController = AnimationController(
      vsync: this,
      duration: kDuration400,
    )..forward();
    _animation = Tween<Offset>(begin: Offset(0, 1), end: Offset.zero).animate(
        CurvedAnimation(
            parent: _enterAnimationController, curve: Curves.easeInOutBack));
    _lottieController = AnimationController(vsync: this);
    Future.delayed(kDuration400, () => _lottieController.forward());
    super.initState();
  }

  @override
  void dispose() {
    _enterAnimationController.dispose();
    super.dispose();
  }

  Future<bool> onWillPop() async {
    _enterAnimationController.reverse();
    Future.delayed(kDuration400, () {
      Navigator.pop(context);
    });
    return false;
  }

  void _exitDialog() {
    _enterAnimationController.reverse();
    Future.delayed(kDuration400, () {
      Navigator.pop(context);
    });
  }

  Widget _lottieAnimation() {
    return Lottie.asset('assets/error.json', controller: _lottieController,
        onLoaded: (composition) {
      _lottieController..duration = composition.duration;
    }, height: 150, width: 150, repeat: false);
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1500)).whenComplete(() {
      _enterAnimationController.reverse();
      Future.delayed(kDuration400, () {
        Navigator.pop(context);
      });
    });
    return FadeTransition(
      opacity: _enterAnimationController,
      child: WillPopScope(
        onWillPop: onWillPop,
        child: SlideTransition(
          position: _animation,
          child: GestureDetector(
            onTap: _exitDialog,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.5 - 70,
                    top: 150),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(5)),
                child: IgnorePointer(
                    ignoring: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _lottieAnimation(),
                      ],
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
