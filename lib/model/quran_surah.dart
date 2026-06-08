class QuranSurahResponse {
  final int code;
  final String message;
  final List<Surah> data;

  QuranSurahResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory QuranSurahResponse.fromJson(Map<String, dynamic> json) {
    return QuranSurahResponse(
      code: json['code'],
      message: json['message'],
      data: (json['data'] as List).map((e) => Surah.fromJson(e)).toList(),
    );
  }
}

class Surah {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final String audioUrl;

  Surah({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audioUrl,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    // FIX UNTUK WEB & ANDROID: Menggunakan CDN yang mendukung CORS (Access-Control-Allow-Origin: *)
    // Sumber: Quran.com / Quranicaudio.com
    final int no = json['nomor'];
    final String audio = "https://download.quranicaudio.com/qdc/mishari_al_afasy/murattal/$no.mp3";

    return Surah(
      nomor: no,
      nama: json['nama'],
      namaLatin: json['namaLatin'],
      jumlahAyat: json['jumlahAyat'],
      tempatTurun: json['tempatTurun'],
      arti: json['arti'],
      deskripsi: json['deskripsi'],
      audioUrl: audio,
    );
  }
}
