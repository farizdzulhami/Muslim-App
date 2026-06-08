class Doa {
  final String id;
  final String doa;
  final String ayat;
  final String latin;
  final String artinya;

  Doa({
    required this.id,
    required this.doa,
    required this.ayat,
    required this.latin,
    required this.artinya,
  });

  factory Doa.fromJson(Map<String, dynamic> json) {
    return Doa(
      id: '', // API baru tidak ada ID spesifik di tiap item
      doa: json['title'] ?? '',
      ayat: json['arabic'] ?? '',
      latin: json['latin'] ?? '',
      artinya: json['translation'] ?? '',
    );
  }
}

class AsmaulHusna {
  final String index;
  final String latin;
  final String arabic;
  final String translationId;

  AsmaulHusna({
    required this.index,
    required this.latin,
    required this.arabic,
    required this.translationId,
  });

  factory AsmaulHusna.fromJson(Map<String, dynamic> json) {
    return AsmaulHusna(
      index: (json['urutan'] ?? '').toString(),
      latin: json['latin'] ?? '',
      arabic: json['arab'] ?? '',
      translationId: json['arti'] ?? '',
    );
  }
}
