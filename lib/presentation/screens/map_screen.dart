import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../providers/pin_provider.dart';
import '../../presentation/widgets/pin_dialog.dart';
import '../../data/models/pin.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    // Inicializa Firebase Auth anónimo y escucha pins
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PinProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pinProvider = context.watch<PinProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MapWhisper',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(19.4326, -99.1332), // Ciudad de Mexico
          initialZoom: 13,
          onTap: (tapPosition, point) {
            // Aquí abriremos el dialog para crear un pin
            _showPinDialog(context, point);
          },
        ),
        children: [
          // Capa de tiles — OpenStreetMap
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.mapwhisper.app',
          ),
          // Capa de marcadores — los pins
          MarkerLayer(
            markers: pinProvider.pins.map((pin) {
              return Marker(
                point: LatLng(pin.lat, pin.lng),
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () => _showPinDetail(context, pin),
                  child: _categoryIcon(pin.category),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      floatingActionButton: pinProvider.isLoading
          ? const CircularProgressIndicator()
          : null,
    );
  }

  void _showPinDialog(BuildContext context, LatLng point) {
    showDialog(
      context: context,
      builder: (_) => PinDialog(position: point),
    );
  }

  void _showPinDetail(BuildContext context, Pin pin) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _categoryIcon(pin.category),
                const SizedBox(width: 8),
                Text(
                  pin.category.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(pin.createdAt),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            Text(pin.comment, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    context.read<PinProvider>().reportPin(pin.id);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.flag, color: Colors.red),
                  label: const Text(
                    'Report',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Icon _categoryIcon(String category) {
    switch (category) {
      case 'warning':
        return const Icon(Icons.warning, color: Colors.orange, size: 30);
      case 'recommendation':
        return const Icon(Icons.thumb_up, color: Colors.green, size: 30);
      case 'question':
        return const Icon(Icons.help, color: Colors.blue, size: 30);
      default:
        return const Icon(Icons.location_pin, color: Colors.purple, size: 40);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
