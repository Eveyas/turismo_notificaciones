import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../home/providers.dart';
import 'package:turismoynotificaciones/core/notifications/notification_service.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    _getFcmToken();
    _subscribeToTopics();
  }

  Future<void> _getFcmToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    setState(() {
      _fcmToken = token;
    });
    print('FCM Token: $token');
  }

  Future<void> _subscribeToTopics() async {
    await FirebaseMessaging.instance.subscribeToTopic('ofertas');
    print('Suscripto al tópico: ofertas');
  }

  // Lista de destinos
  static const destinos = [
    {'nombre': 'Cancún', 'tipo': 'Playa'},
    {'nombre': 'Tulum', 'tipo': 'Zona arqueológica'},
    {'nombre': 'Bacalar', 'tipo': 'Laguna'},
    {'nombre': 'Isla Mujeres', 'tipo': 'Isla'},
  ];

  @override
  Widget build(BuildContext context) {
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
                      // Envía la notificación local
                      await NotificationService.showNotification(
                        title: 'Explora ${d['nombre']}',
                        body: 'Descubre ${d['nombre']} (${d['tipo']})',
                      );
                      // Incrementa el contador
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
                // Token FCM
                if (_fcmToken != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Token FCM:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          _fcmToken!,
                          style: const TextStyle(fontSize: 10),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),

                // Contador de notificaciones
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

                // Botón para notificación local
                ElevatedButton.icon(
                  icon: const Icon(Icons.notifications),
                  label: const Text('Enviar notificación local'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
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
                      const SnackBar(
                        backgroundColor: Color(0xFF0D47A1),
                        content: Text(
                          'Notificación enviada',
                          style: TextStyle(color: Colors.white),
                        ),
                        duration: Duration(seconds: 2),
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

