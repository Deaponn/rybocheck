import 'package:flutter/material.dart';

class TextSwitch extends StatelessWidget {
  const TextSwitch(
      {super.key, required this.leftText, required this.rightText, required this.switchValue, required this.onSwitch});

  final String leftText;
  final String rightText;
  final int switchValue;
  final Function() onSwitch;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSwitch();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedPositioned(
            left: switchValue == 0 ? 0 : 50,
            duration: const Duration(milliseconds: 250),
            child: Container(
              width: 70,
              height: 35,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.black),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                  child: Text(
                leftText,
                style: TextStyle(color: switchValue == 0 ? Colors.white : Colors.black),
              )),
              Center(
                  child: Text(
                rightText,
                style: TextStyle(color: switchValue == 1 ? Colors.white : Colors.black),
              )),
            ],
          ),
        ],
      ),
    );
  }
}
