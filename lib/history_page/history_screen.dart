import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../riverpod_provider/provider.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(lotteryProvider.select((state) => state.history));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Lottery History',
          style: GoogleFonts.nunito(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: history.isEmpty
          ? Center(
        child: Text(
          'No tickets yet',
          style: GoogleFonts.nunito(fontSize: 18),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final numbers = history[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ticket ${index + 1}',
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: numbers.map((number) => Chip(
                      label: Text(
                        number.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.black,
                    )).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}