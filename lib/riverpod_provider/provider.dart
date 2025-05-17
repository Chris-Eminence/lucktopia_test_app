import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LotteryNotifier extends StateNotifier<LotteryState> {
  LotteryNotifier() : super(LotteryState());

  final Random random = Random();

  // Number selection logic
  void toggleNumber(int number) {
    if (state.selectedNumbers.contains(number)) {
      state = state.copyWith(
        selectedNumbers: {...state.selectedNumbers}..remove(number),
        isAutoPicked: false,
      );
    } else if (state.selectedNumbers.length < 6) {
      state = state.copyWith(
        selectedNumbers: {...state.selectedNumbers}..add(number),
        isAutoPicked: false,
      );
    }
  }

  // Auto pick numbers logic
  void autoPickNumbers(AnimationController controller) {
    final newNumbers = <int>{};
    while (newNumbers.length < 6) {
      newNumbers.add(random.nextInt(50) + 1);
    }

    state = state.copyWith(
      selectedNumbers: newNumbers,
      isAutoPicked: true,
    );

    controller.forward(from: 0);
  }

  // Clear selection logic
  void clearSelection() {
    state = state.copyWith(
      selectedNumbers: {},
      isAutoPicked: false,
    );
  }

  void addToHistory(Set<int> numbers) {
    final sortedNumbers = numbers.toList()..sort();
    state = state.copyWith(
      history: [...state.history, sortedNumbers],
      selectedNumbers: {},
      isAutoPicked: false,
    );
  }

  // UI helper methods
  static Widget buildNumberButton(int number, Set<int> selectedNumbers, void Function(int) onTap) {
    final isSelected = selectedNumbers.contains(number);
    return GestureDetector(
      onTap: () => onTap(number),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.blue : Colors.grey[300],
        ),
        alignment: Alignment.center,
        child: Text(
          number.toString(),
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static Widget buildSelectedNumbersContainer(Set<int> selectedNumbers) {
    final sortedNumbers = selectedNumbers.toList()..sort();

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Numbers',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (index) {
              if (index >= sortedNumbers.length) {
                return Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey),
                  ),
                );
              }

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.5),
                      blurRadius: 5,
                      spreadRadius: 1,
                    )
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  sortedNumbers[index].toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );


  }


}



class LotteryState {
  final Set<int> selectedNumbers;
  final bool isAutoPicked;
  final List<List<int>> history;


  LotteryState({
    this.selectedNumbers = const {},
    this.isAutoPicked = false,
    this.history = const [],

  });

  LotteryState copyWith({
    Set<int>? selectedNumbers,
    bool? isAutoPicked,
    List<List<int>>? history,

  }) {
    return LotteryState(
      selectedNumbers: selectedNumbers ?? this.selectedNumbers,
      isAutoPicked: isAutoPicked ?? this.isAutoPicked,
      history: history ?? this.history,

    );
  }
}

final lotteryProvider = StateNotifierProvider<LotteryNotifier, LotteryState>(
      (ref) => LotteryNotifier(),
);