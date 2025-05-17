import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../riverpod_provider/provider.dart';
import '../widgets/picked_numbers_widget.dart';

class LotteryPage extends ConsumerStatefulWidget {
  const LotteryPage({super.key});

  @override
  ConsumerState<LotteryPage> createState() => _LotteryPageState();
}

class _LotteryPageState extends ConsumerState<LotteryPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _rotateController;
  late Animation<double> _rotateAnimation;
  final List<AnimationController> _numberAnimationControllers = [];
  final List<Animation<Offset>> _numberAnimations = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _rotateAnimation = Tween<double>(begin: 0.0, end: -1.0).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.easeInOut),
    );
  }

  void _animateNumberSelection(int index) {
    final controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    final animation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.elasticOut),
    );

    setState(() {
      _numberAnimationControllers.add(controller);
      _numberAnimations.add(animation);
    });

    controller.forward();
  }

  void _proceed(BuildContext context, Set<int> selectedNumbers) {
    ref.read(lotteryProvider.notifier).addToHistory(selectedNumbers);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Numbers Saved', style: GoogleFonts.nunito(color: Colors.black)),
          content: Text('Saved numbers: ${selectedNumbers.join(', ')}', style: GoogleFonts.nunito(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK', style: GoogleFonts.nunito(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _autoPickWithAnimation() {
    final lotteryNotifier = ref.read(lotteryProvider.notifier);
    lotteryNotifier.clearSelection();

    // Clear previous animations
    for (var controller in _numberAnimationControllers) {
      controller.dispose();
    }
    _numberAnimationControllers.clear();
    _numberAnimations.clear();

    // Auto pick numbers
    lotteryNotifier.autoPickNumbers(_controller);

    // Animate the numbers with a delay
    Future.delayed(const Duration(milliseconds: 300), () {
      final selectedNumbers = ref.read(lotteryProvider).selectedNumbers.toList();
      for (int i = 0; i < selectedNumbers.length; i++) {
        Future.delayed(Duration(milliseconds: i * 200), () {
          if (mounted) {
            _animateNumberSelection(i);
          }
        });

      }
    });
  }



  @override
  Widget build(BuildContext context) {
    final lotteryState = ref.watch(lotteryProvider);
    final lotteryNotifier = ref.read(lotteryProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Lottery Picker',
          style: GoogleFonts.nunito(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Animated selected numbers container
            PickNumbersWidget(lotteryState: lotteryState, numberAnimations: _numberAnimations),
            const SizedBox(height: 20),
            Container(
              height: 490,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Select Six Numbers (1 - 50)',
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: RotationTransition(
                          turns: _rotateAnimation,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: SvgPicture.asset('assets/reload.svg'),
                          ),
                        ),
                        color: Colors.white,
                        onPressed: () {
                          _rotateController.forward(from: 0.0);
                          lotteryNotifier.clearSelection();
                          // Clear animations
                          for (var controller in _numberAnimationControllers) {
                            controller.dispose();
                          }
                          _numberAnimationControllers.clear();
                          _numberAnimations.clear();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 5,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      children: List.generate(
                        50,
                            (index) {
                          final number = index + 1;
                          return LotteryNotifier.buildNumberButton(
                            number,
                            lotteryState.selectedNumbers,
                                (numbers) {
                              lotteryNotifier.toggleNumber(numbers);
                              if (lotteryState.selectedNumbers.contains(numbers)) {
                                _animateNumberSelection(
                                    lotteryState.selectedNumbers.toList().indexOf(numbers)
                                );
                              }
                              if (lotteryState.selectedNumbers.length == 6) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'You can only select 6 numbers',
                                      style: GoogleFonts.nunito(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                      ),
                      onPressed: _autoPickWithAnimation,
                      child: Text(
                        'Auto Pick',
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: lotteryState.selectedNumbers.length == 6
                          ? () => _proceed(context, lotteryState.selectedNumbers)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: lotteryState.selectedNumbers.length == 6
                            ? Colors.black
                            : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                      ),
                      child: Text(
                        'Proceed',
                        style: GoogleFonts.nunito(
                          color: lotteryState.selectedNumbers.length == 6
                              ? Colors.white
                              : Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _rotateController.dispose();
    for (var controller in _numberAnimationControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}