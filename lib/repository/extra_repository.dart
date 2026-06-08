import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/extra_models.dart';

class ExtraRepository {
  final http.Client _client;
  ExtraRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Doa>> getDoaList() async {
    try {
      final res = await _client.get(Uri.parse('https://islamic-api-zhirrr.vercel.app/api/doaharian'));
      if (res.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(res.body);
        final List data = body['data'];
        if (data != null && data.isNotEmpty) {
          return data.map((e) => Doa.fromJson(e)).toList();
        }
      }
    } catch (e) {
      // Fallback if API fails
    }
    
    // Hardcoded Doa Harian sebagai fallback agar tidak kosong
    return [
      Doa(id: '1', doa: 'Doa Sebelum Makan', ayat: 'اللَّهُمَّ بَارِكْ لَنَا فِيمَا رَزَقْتَنَا وَقِنَا عَذَابَ النَّارِ', latin: 'Allahumma barik lana fima razaqtana wa qina adzaban nar', artinya: 'Ya Allah, berkahilah kami dalam rezeki yang telah Engkau berikan kepada kami dan peliharalah kami dari siksa api neraka.'),
      Doa(id: '2', doa: 'Doa Sesudah Makan', ayat: 'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ', latin: 'Alhamdulillahilladzi ath\'amana wa saqana wa ja\'alana muslimin', artinya: 'Segala puji bagi Allah yang telah memberi kami makan dan minum serta menjadikan kami orang-orang muslim.'),
      Doa(id: '3', doa: 'Doa Sebelum Tidur', ayat: 'بِاسْمِكَ اللَّهُمَّ أَحْيَا وَأَمُوتُ', latin: 'Bismika allahumma ahya wa amutu', artinya: 'Dengan nama-Mu ya Allah aku hidup dan aku mati.'),
      Doa(id: '4', doa: 'Doa Bangun Tidur', ayat: 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ', latin: 'Alhamdulillahilladzi ahyana ba\'da ma amatana wa ilaihin nusyur', artinya: 'Segala puji bagi Allah yang telah menghidupkan kami sesudah mati (tidur) dan kepada-Nya kami kembali.'),
      Doa(id: '5', doa: 'Doa Masuk Kamar Mandi', ayat: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ', latin: 'Allahumma inni a\'udzu bika minal khubutsi wal khabaits', artinya: 'Ya Allah, sesungguhnya aku berlindung kepada-Mu dari godaan syetan laki-laki dan syetan perempuan.'),
      Doa(id: '6', doa: 'Doa Keluar Kamar Mandi', ayat: 'غُفْرَانَكَ الْحَمْدُ لِلَّهِ الَّذِي أَذْهَبَ عَنِّي الْأَذَى وَعَافَانِي', latin: 'Ghufranaka alhamdulillahilladzi adzhaba \'annil adza wa \'afani', artinya: 'Dengan mengharap ampunan-Mu, segala puji bagi Allah yang telah menghilangkan penyakit dari tubuhku dan menjaga kesehatanku.'),
    ];
  }

  Future<List<AsmaulHusna>> getAsmaulHusna() async {
    try {
      final res = await _client.get(Uri.parse('https://asmaul-husna-api.vercel.app/api/all'));
      if (res.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(res.body);
        final List items = data['data'];
        if (items != null && items.isNotEmpty) {
          return items.map((e) => AsmaulHusna.fromJson(e)).toList();
        }
      }
    } catch (e) {
      // Handle error
    }

    // Fallback Asmaul Husna (Beberapa yang utama)
    return [
      AsmaulHusna(index: '1', latin: 'Ar Rahman', arabic: 'الرحمن', translationId: 'Yang Maha Pengasih'),
      AsmaulHusna(index: '2', latin: 'Ar Rahim', arabic: 'الرحيم', translationId: 'Yang Maha Penyayang'),
      AsmaulHusna(index: '3', latin: 'Al Malik', arabic: 'الملك', translationId: 'Yang Maha Merajai'),
      AsmaulHusna(index: '4', latin: 'Al Quddus', arabic: 'القدوس', translationId: 'Yang Maha Suci'),
      AsmaulHusna(index: '5', latin: 'As Salam', arabic: 'السلام', translationId: 'Yang Maha Memberi Kesejahteraan'),
      AsmaulHusna(index: '6', latin: 'Al Mu\'min', arabic: 'المؤمن', translationId: 'Yang Maha Memberi Keamanan'),
      AsmaulHusna(index: '7', latin: 'Al Muhaimin', arabic: 'المهيمن', translationId: 'Yang Maha Pemelihara'),
      AsmaulHusna(index: '8', latin: 'Al \'Aziz', arabic: 'العزيز', translationId: 'Yang Maha Perkasa'),
      AsmaulHusna(index: '9', latin: 'Al Jabbar', arabic: 'الجبار', translationId: 'Yang Memiliki Mutlak Kegagahan'),
      AsmaulHusna(index: '10', latin: 'Al Mutakabbir', arabic: 'المتكبر', translationId: 'Yang Maha Megah'),
      AsmaulHusna(index: '11', latin: 'Al Khaliq', arabic: 'الخالق', translationId: 'Yang Maha Pencipta'),
      AsmaulHusna(index: '12', latin: 'Al Baari\'', arabic: 'البارئ', translationId: 'Yang Maha Melepaskan'),
      AsmaulHusna(index: '13', latin: 'Al Mushawwir', arabic: 'المصور', translationId: 'Yang Maha Membentuk Rupa'),
      AsmaulHusna(index: '14', latin: 'Al Ghaffar', arabic: 'الغفار', translationId: 'Yang Maha Pengampun'),
      AsmaulHusna(index: '15', latin: 'Al Qahhar', arabic: 'القهار', translationId: 'Yang Maha Menundukkan'),
    ];
  }
}
