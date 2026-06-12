import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  
  for (final file in files) {
    String content = file.readAsStringSync();
    bool changed = false;
    
    if (content.contains('0xFF0F9D8A')) {
      content = content.replaceAll('0xFF0F9D8A', '0xFF1565C0');
      changed = true;
    }
    if (content.contains('0xFF0C7C6D')) {
      content = content.replaceAll('0xFF0C7C6D', '0xFF0D47A1');
      changed = true;
    }
    if (content.contains('0xFF086B5E')) {
      content = content.replaceAll('0xFF086B5E', '0xFF0D47A1');
      changed = true;
    }
    
    if (changed) {
      file.writeAsStringSync(content);
      print('Updated ${file.path}');
    }
  }
  print('Done.');
}
