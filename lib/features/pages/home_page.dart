import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../home/providers.dart';
import 'package:turismo_notificaciones/core/notifications/notification_service.dart';

//interfaz principal
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  //Lista de destinos
  static const destinos = [
    {'nombre': 'Cancún', 'tipo': 'Playa'},
    {'nombre': 'Tulum', 'tipo': 'Zona arqueológica'},
    {'nombre': 'Bacalar', 'tipo': 'Laguna'},
    {'nombre': 'Isla Mujeres', 'tipo': 'Isla'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badge = ref.watch(badgeCountProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        elevation: 4,
        backgroundColor: const Color(0xFF0D47A1),
        title: const Text(
          'Destinos turísticos',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: destinos.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (_, i) {
                final d = destinos[i];
                return Card(
                  elevation: 3,
                  color: Colors.white,
                  shadowColor: Colors.blueGrey.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: const Icon(
                      Icons.place,
                      color: Color(0xFF1976D2),
                      size: 30,
                    ),
                    title: Text(
                      d['nombre']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                    subtitle: Text(
                      d['tipo']!,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0xFFD32F2F),
                      size: 18,
                    ),
                    onTap: () async {
                      //envia la notificacion local
                      await NotificationService.showNotification(
                        title: 'Explora ${d['nombre']}',
                        body: 'Descubre ${d['nombre']} (${d['tipo']})',
                      );
                      //incrementa el contador
                      ref.read(badgeCountProvider.notifier).state++;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color(0xFF1976D2),
                          content: Text(
                            'Notificación de ${d['nombre']} enviada',
                            style: const TextStyle(color: Colors.white),
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFB71C1C), Color(0xFFD32F2F)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.notifications_active,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Notificaciones enviadas: $badge',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  icon: const Icon(Icons.notifications),
                  label: const Text('Enviar notificación'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2), // Azul medio
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: Colors.blueAccent,
                    elevation: 3,
                  ),
                  onPressed: () async {
                    await NotificationService.showNotification(
                      title: 'Novedad turística',
                      body: 'Nueva promo en Quintana Roo',
                    );
                    ref.read(badgeCountProvider.notifier).state++;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: const Color(0xFF0D47A1),
                        content: const Text(
                          'Notificación enviada',
                          style: TextStyle(color: Colors.white),
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
