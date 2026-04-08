import 'dart:io';
import 'package:flutter/material.dart';
import 'package:free_map/free_map.dart';
import 'package:sky_watch/Model/observation_model.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key, required this.obs});
  final Observation obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Keep AppBar logic as is, but the background will flow behind it
      appBar: AppBar(title: const Text("Observation Details"), elevation: 0),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          // Deep Space Gradient
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B1026), Color(0xFF232946)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Text(
                  obs.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 34,
                    letterSpacing: -0.5,
                    shadows: [Shadow(color: Colors.blueAccent, blurRadius: 10)],
                  ),
                ),
                const SizedBox(height: 15),

                // Datos Generales
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabeledText(
                        label: "Time",
                        data:
                            "${obs.dateTime.day}/${obs.dateTime.month}/${obs.dateTime.year} ${obs.dateTime.hour}:${obs.dateTime.minute}",
                      ),
                      const Divider(color: Colors.white10),
                      LabeledText(label: "Category", data: obs.category),
                      const Divider(color: Colors.white10),
                      LabeledText(label: "Condition", data: obs.skyCondition),
                    ],
                  ),
                ),

                //Descripción
                const SizedBox(height: 20),
                Text(
                  obs.description,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),

                // Muestra la imagén redondeada
                if (obs.imagePath.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Image.file(File(obs.imagePath), fit: BoxFit.cover),
                    ),
                  ),

                const SizedBox(height: 20),
                const Text(
                  "Location",
                  style: TextStyle(
                    color: Colors.amberAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  obs.locationText ?? "Unknown Location",
                  style: const TextStyle(color: Colors.white54),
                ),
                const SizedBox(height: 10),

                //Muestra el Mapa
                if (obs.lat != null && obs.lng != null)
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.cyanAccent.withValues(alpha: 0.05),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withValues(alpha: 0.1),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(23),
                      child: FmMap(
                        mapOptions: MapOptions(
                          initialCenter: LatLng(obs.lat!, obs.lng!),
                          initialZoom: 15,
                        ),
                        markers: [
                          Marker(
                            point: LatLng(obs.lat!, obs.lng!),
                            child: const Icon(
                              Icons.stars,
                              color: Colors.amber,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LabeledText extends StatelessWidget {
  const LabeledText({super.key, required this.label, this.data = ""});
  final String label;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "${label.toUpperCase()}: ",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.amberAccent,
                fontSize: 12,
                letterSpacing: 1.2,
              ),
            ),
            TextSpan(
              text: data,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
