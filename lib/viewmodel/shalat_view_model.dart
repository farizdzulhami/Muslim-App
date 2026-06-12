import 'dart:async';
import 'package:flutter/foundation.dart';
import '../model/shalat_schedule_response.dart';
import '../repository/shalat_repository.dart';

class ShalatViewModel extends ChangeNotifier {
  final ShalatRepository _repo;
  Timer? _timer;

  ShalatViewModel(this._repo) {
    _startTimer();
  }

  bool _isLoading = false;
  String? _error;
  List<ShalatDaySchedule> _schedules = [];

  String currentPrayer = "Memuat...";
  String currentPrayerTime = "-";
  String countdown = "-";

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<ShalatDaySchedule> get schedules => _schedules;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_schedules.isNotEmpty) {
        updateCurrentPrayer();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchMonthlySchedule({
    required int cityId,
    required int year,
    required int month,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await _repo.getMonthlySchedule(
        cityId: cityId,
        year: year,
        month: month,
      );

      _schedules = res.schedules;
      updateCurrentPrayer();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void updateCurrentPrayer() {
    if (_schedules.isEmpty) return;
    
    final now = DateTime.now();
    final todayStr = "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";
    
    ShalatDaySchedule? today;
    try {
      today = _schedules.firstWhere((s) => s.tanggal.contains(todayStr));
    } catch (e) {
      today = _schedules.first;
    }

    Map<String, String> times = {
      "Subuh": today.subuh,
      "Terbit": today.terbit,
      "Dzuhur": today.dzuhur,
      "Ashar": today.ashar,
      "Maghrib": today.maghrib,
      "Isya": today.isya,
    };

    bool found = false;
    for (var entry in times.entries) {
      final parts = entry.value.split(":");
      final target = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );

      if (now.isBefore(target)) {
        currentPrayer = entry.key;
        currentPrayerTime = entry.value;
        countdown = _countdown(target);
        found = true;
        break;
      }
    }

    if (!found) {
      currentPrayer = "Subuh Besok";
      final tomorrow = now.add(const Duration(days: 1));
      final tomorrowStr = "${tomorrow.day.toString().padLeft(2, '0')}/${tomorrow.month.toString().padLeft(2, '0')}/${tomorrow.year}";
      try {
        final tomorrowSchedule = _schedules.firstWhere((s) => s.tanggal.contains(tomorrowStr));
        currentPrayerTime = tomorrowSchedule.subuh;
      } catch (e) {
        currentPrayerTime = times["Subuh"] ?? "-";
      }
      countdown = "Besok";
    }
    
    notifyListeners();
  }

  String _countdown(DateTime target) {
    final diff = target.difference(DateTime.now());
    if (diff.inHours > 0) {
      return "${diff.inHours}j ${diff.inMinutes % 60}m";
    } else {
      return "${diff.inMinutes}m lagi";
    }
  }
}