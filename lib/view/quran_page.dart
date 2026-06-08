import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/quran_view_model.dart';
import '../model/quran_surah.dart';
import 'quran_detail_page.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuranViewModel>().fetchSurahList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuranViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text(
          "Al-Quran",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F9D8A),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header Background
          Container(
            height: 10,
            decoration: const BoxDecoration(
              color: Color(0xFF0F9D8A),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
          ),
          Expanded(
            child: Builder(
              builder: (_) {
                if (vm.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (vm.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Terjadi kesalahan: ${vm.error}"),
                        ElevatedButton(
                          onPressed: () => vm.fetchSurahList(),
                          child: const Text("Coba Lagi"),
                        )
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: vm.surahList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final surah = vm.surahList[index];
                    final isPlaying = vm.currentPlayingNomor == surah.nomor;

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                QuranDetailPage(surah: surah),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Nomor Surah
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(Icons.star_border_outlined,
                                    size: 45,
                                    color: const Color(0xFF0F9D8A)
                                        .withOpacity(0.2)),
                                Text(
                                  surah.nomor.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F9D8A),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            // Nama Surah
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    surah.namaLatin,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    "${surah.tempatTurun} • ${surah.jumlahAyat} Ayat",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? Colors.white60 : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Action Buttons (Play & Arabic Name)
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => vm.playAudio(surah),
                                  icon: Icon(
                                    isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                                    color: const Color(0xFF0F9D8A),
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  surah.nama,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F9D8A),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
