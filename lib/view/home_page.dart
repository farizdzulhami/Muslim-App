import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/shalat_view_model.dart';
import '../viewmodel/profile_view_model.dart';
import 'shalat_page.dart';
import 'quran_page.dart';
import 'doa_page.dart';
import 'asmaul_husna_page.dart';
import 'kiblat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();
      context.read<ShalatViewModel>().fetchMonthlySchedule(
            cityId: 1206,
            year: now.year,
            month: now.month,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ShalatViewModel>();
    final profileVM = context.watch<ProfileViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FB),
      body: CustomScrollView(
        slivers: [
          // Header Hero
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 30, left: 24, right: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Assalamualaikum, ${profileVM.userName.split(' ')[0]}", 
                    style: const TextStyle(color: Colors.white70, fontSize: 16)),
                  const Text("Selamat Beribadah", 
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  // Next Prayer Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(vm.currentPrayer.toUpperCase(), 
                              style: const TextStyle(color: Colors.white70, letterSpacing: 2, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(vm.currentPrayerTime, 
                              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Icon(Icons.access_time_filled, color: Colors.white, size: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Features Grid
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _featureCard(
                  context,
                  title: "Al-Quran",
                  subtitle: "30 Juz & Terjemahan",
                  icon: Icons.menu_book_rounded,
                  color: const Color(0xFF1565C0),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuranPage())),
                ),
                _featureCard(
                  context,
                  title: "Jadwal Shalat",
                  subtitle: "Cianjur",
                  icon: Icons.notifications_active_rounded,
                  color: Colors.orange,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ShalatPage())),
                ),
                _featureCard(
                  context,
                  title: "Doa Harian",
                  subtitle: "Kumpulan Doa",
                  icon: Icons.volunteer_activism_rounded,
                  color: Colors.blue,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DoaPage())),
                ),
                _featureCard(
                  context,
                  title: "Asmaul Husna",
                  subtitle: "99 Nama Allah",
                  icon: Icons.auto_awesome_rounded,
                  color: Colors.purple,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AsmaulHusnaPage())),
                ),
                _featureCard(
                  context,
                  title: "Kiblat",
                  subtitle: "Arah Ka'bah",
                  icon: Icons.explore_rounded,
                  color: Colors.redAccent,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KiblatPage())),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureCard(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.04), 
              blurRadius: 10, 
              offset: const Offset(0, 4)
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15), 
                borderRadius: BorderRadius.circular(12)
              ),
              child: Icon(icon, color: color),
            ),
            const Spacer(),
            Text(title, 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black87
              )
            ),
            const SizedBox(height: 2),
            Text(subtitle, 
              style: TextStyle(
                color: isDark ? Colors.white60 : Colors.grey[600], 
                fontSize: 11
              )
            ),
          ],
        ),
      ),
    );
  }
}
