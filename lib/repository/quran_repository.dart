import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/quran_surah.dart';
import '../model/quran_detail.dart';

class QuranRepository {
  final http.Client _client;

  QuranRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Surah>> getSurahList() async {
    final url = Uri.parse('https://equran.id/api/v2/surat');
    final response = await _client.get(url);

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat daftar surah');
    }

    final data = json.decode(response.body);
    return QuranSurahResponse.fromJson(data).data;
  }

  Future<SurahDetail> getSurahDetail(int nomor) async {
    final url = Uri.parse('https://equran.id/api/v2/surat/$nomor');
    final response = await _client.get(url);

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat detail surah');
    }

    final data = json.decode(response.body);
    return QuranDetailResponse.fromJson(data).data;
  }
}
