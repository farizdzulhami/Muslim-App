import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../model/quran_surah.dart';
import '../model/quran_detail.dart';
import '../repository/quran_repository.dart';

class QuranViewModel extends ChangeNotifier {
  final QuranRepository _repository;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isAudioBusy = false;

  QuranViewModel(this._repository) {
    _audioPlayer.onPlayerComplete.listen((event) {
      _currentPlayingNomor = null;
      notifyListeners();
    });
    
    _audioPlayer.onLog.listen((log) {
      debugPrint("AudioPlayer Log: $log");
    });
  }

  List<Surah> _surahList = [];
  List<Surah> get surahList => _surahList;

  SurahDetail? _surahDetail;
  SurahDetail? get surahDetail => _surahDetail;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  int? _currentPlayingNomor;
  int? get currentPlayingNomor => _currentPlayingNomor;

  Future<void> fetchSurahList() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _surahList = await _repository.getSurahList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSurahDetail(int nomor) async {
    _isLoading = true;
    _error = null;
    _surahDetail = null;
    notifyListeners();

    try {
      _surahDetail = await _repository.getSurahDetail(nomor);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> playAudio(Surah surah) async {
    if (_isAudioBusy) return;
    
    _isAudioBusy = true;
    _error = null;
    notifyListeners();

    try {
      if (_currentPlayingNomor == surah.nomor) {
        await _audioPlayer.pause();
        _currentPlayingNomor = null;
      } else {
        await _audioPlayer.stop();
        if (surah.audioUrl.isNotEmpty) {
          // Menggunakan URL langsung karena sumber baru sudah mendukung CORS
          await _audioPlayer.play(UrlSource(surah.audioUrl));
          _currentPlayingNomor = surah.nomor;
        } else {
          _error = "URL Audio tidak tersedia untuk surat ini";
        }
      }
    } catch (e) {
      if (!e.toString().contains("AbortError")) {
        _error = "Gagal memutar audio: $e";
      }
      _currentPlayingNomor = null;
    } finally {
      _isAudioBusy = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
