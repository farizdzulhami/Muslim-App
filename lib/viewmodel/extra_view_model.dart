import 'package:flutter/material.dart';
import '../model/extra_models.dart';
import '../repository/extra_repository.dart';

class ExtraViewModel extends ChangeNotifier {
  final ExtraRepository _repo;
  ExtraViewModel(this._repo);

  List<Doa> _doaList = [];
  List<AsmaulHusna> _asmaulList = [];
  bool _isLoading = false;

  List<Doa> get doaList => _doaList;
  List<AsmaulHusna> get asmaulList => _asmaulList;
  bool get isLoading => _isLoading;

  Future<void> fetchDoa() async {
    _isLoading = true;
    notifyListeners();
    try {
      _doaList = await _repo.getDoaList();
    } catch (e) {
      debugPrint("Error Fetching Doa: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchAsmaul() async {
    _isLoading = true;
    notifyListeners();
    try {
      _asmaulList = await _repo.getAsmaulHusna();
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }
}
