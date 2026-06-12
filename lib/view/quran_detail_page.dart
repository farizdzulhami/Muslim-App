import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/quran_surah.dart';
import '../model/quran_detail.dart';
import '../viewmodel/quran_view_model.dart';

class QuranDetailPage extends StatefulWidget {
  final Surah surah;
  const QuranDetailPage({super.key, required this.surah});

  @override
  State<QuranDetailPage> createState() => _QuranDetailPageState();
}

class _QuranDetailPageState extends State<QuranDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuranViewModel>().fetchSurahDetail(widget.surah.nomor);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuranViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPlaying = vm.currentPlayingNomor == widget.surah.nomor;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        title: Text(
          widget.surah.namaLatin,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => vm.playAudio(widget.surah),
            icon: Icon(
              isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner Surah
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF1565C0),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              children: [
                Text(
                  widget.surah.nama,
                  style: const TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.surah.arti,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const Divider(color: Colors.white30, height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${widget.surah.tempatTurun.toUpperCase()} • ${widget.surah.jumlahAyat} AYAT",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Floating Action Button style for Play
                    GestureDetector(
                      onTap: () => vm.playAudio(widget.surah),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: const Color(0xFF1565C0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Builder(
              builder: (_) {
                if (vm.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (vm.error != null) {
                  return Center(child: Text("Error: ${vm.error}", style: TextStyle(color: isDark ? Colors.white : Colors.black)));
                }
                if (vm.surahDetail == null) {
                  return const SizedBox();
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: vm.surahDetail!.ayat.length,
                  separatorBuilder: (_, __) => Divider(height: 40, color: isDark ? Colors.white10 : Colors.grey[200]),
                  itemBuilder: (context, index) {
                    final ayat = vm.surahDetail!.ayat[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Nomor Ayat Badge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1565C0).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                ayat.nomorAyat.toString(),
                                style: const TextStyle(
                                  color: Color(0xFF1565C0),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Teks Arab
                        Text(
                          ayat.teksArab,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            height: 2,
                            color: isDark ? Colors.white : const Color(0xFF2D2D2D),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Latin
                        Text(
                          ayat.teksLatin,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1565C0),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Terjemahan
                        Text(
                          ayat.teksIndonesia,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.white70 : Colors.black87,
                            height: 1.5,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
