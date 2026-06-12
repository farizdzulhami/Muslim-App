import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/shalat_view_model.dart';
import '../model/shalat_schedule_response.dart';

class ShalatPage extends StatefulWidget {
  const ShalatPage({super.key});

  @override
  State<ShalatPage> createState() => _ShalatPageState();
}

class _ShalatPageState extends State<ShalatPage> {
  final int cityId = 1206; // Cianjur

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();
      context.read<ShalatViewModel>().fetchMonthlySchedule(
            cityId: cityId,
            year: now.year,
            month: now.month,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ShalatViewModel>();
    final now = DateTime.now();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF2F4F7),
      body: Builder(
        builder: (_) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.error != null) {
            return Center(child: Text(vm.error!));
          }

          if (vm.schedules.isEmpty) {
            return const Center(child: Text("Data kosong"));
          }

          final todayStr =
              "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";
          ShalatDaySchedule? today;
          try {
            today = vm.schedules
                .firstWhere((s) => s.tanggal.contains(todayStr));
          } catch (e) {
            today = vm.schedules.first;
          }

          return CustomScrollView(
            slivers: [
              // ================= PREMIUM HEADER =================
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                      top: 60, bottom: 40, left: 24, right: 24),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1565C0),
                        Color(0xFF0D47A1),
                      ],
                    ),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              if (Navigator.of(context).canPop())
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.arrow_back_ios_new,
                                      color: Colors.white, size: 20),
                                ),
                              if (Navigator.of(context).canPop())
                                const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Lokasi Saat Ini",
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 12),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: const [
                                      Icon(Icons.location_on,
                                          color: Colors.white, size: 14),
                                      SizedBox(width: 4),
                                      Text(
                                        "KAB. CIANJUR",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.notifications_active,
                                color: Colors.white),
                          )
                        ],
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              vm.currentPrayer.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white70,
                                letterSpacing: 4,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              vm.countdown,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              today.tanggal,
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ================= LIST JADWAL =================
              SliverPadding(
                padding: const EdgeInsets.only(
                    top: 24, left: 20, right: 20, bottom: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _tile(context, "Imsak", today.imsak, Icons.timer_outlined,
                        vm.currentPrayer == "Imsak"),
                    _tile(context, "Subuh", today.subuh, Icons.nightlight_outlined,
                        vm.currentPrayer == "Subuh"),
                    _tile(context, "Terbit", today.terbit, Icons.wb_sunny_outlined,
                        vm.currentPrayer == "Terbit"),
                    _tile(context, "Dzuhur", today.dzuhur, Icons.wb_sunny,
                        vm.currentPrayer == "Dzuhur"),
                    _tile(context, "Ashar", today.ashar, Icons.cloud_outlined,
                        vm.currentPrayer == "Ashar"),
                    _tile(context, "Maghrib", today.maghrib, Icons.wb_twilight,
                        vm.currentPrayer == "Maghrib"),
                    _tile(context, "Isya", today.isya, Icons.nights_stay,
                        vm.currentPrayer == "Isya"),
                  ]),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _tile(BuildContext context, String title, String time, IconData icon, bool highlight) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: highlight 
            ? const Color(0xFF1565C0) 
            : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: highlight
                  ? Colors.white.withOpacity(0.2)
                  : (isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF2F4F7)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon,
                color: highlight ? Colors.white : const Color(0xFF1565C0)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: highlight ? Colors.white : (isDark ? Colors.white : Colors.black87),
                fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 18,
              color: highlight ? Colors.white : const Color(0xFF1565C0),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}