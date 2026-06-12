import 'package:flutter/material.dart';

class KiblatPage extends StatelessWidget {
  const KiblatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text("Arah Kiblat",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1565C0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Posisikan Smartphone Anda datar",
                style: TextStyle(color: isDark ? Colors.white60 : Colors.grey)),
            const SizedBox(height: 40),
            // Compass UI
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF1565C0), width: 8),
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  ),
                ),
                Transform.rotate(
                  angle: 0.5, // Dummy angle
                  child: Column(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red, size: 40),
                      const SizedBox(height: 10),
                      Container(
                          width: 4,
                          height: 100,
                          color: isDark ? Colors.white54 : Colors.black54),
                    ],
                  ),
                ),
                Text(
                  "KA'BAH",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                "Arah Kiblat: 295.14°",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1565C0),
                    fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
