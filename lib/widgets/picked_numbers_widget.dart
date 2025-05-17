import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../riverpod_provider/provider.dart';

class PickNumbersWidget extends StatelessWidget {
  const PickNumbersWidget({
    super.key,
    required this.lotteryState,
    required List<Animation<Offset>> numberAnimations,
  }) : _numberAnimations = numberAnimations;

  final LotteryState lotteryState;
  final List<Animation<Offset>> _numberAnimations;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: lotteryState.selectedNumbers.isNotEmpty ? Center(
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: lotteryState.selectedNumbers.map((number) {
            final index = lotteryState.selectedNumbers.toList().indexOf(number);
            final animation = index < _numberAnimations.length
                ? _numberAnimations[index]
                : AlwaysStoppedAnimation(Offset.zero);

            return SlideTransition(
              position: animation,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    number.toString(),
                    style: GoogleFonts.nunito(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ) : Container(
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),),
        child: Center(
          child: Text('Selected Numbers',
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}