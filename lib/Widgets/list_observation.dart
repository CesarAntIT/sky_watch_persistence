import 'package:flutter/material.dart';
import 'package:sky_watch/Model/observation_model.dart';
import 'package:sky_watch/pages/details_page.dart';

class ListObservation extends StatelessWidget {
  const ListObservation({super.key, required this.observation});

  final Observation observation;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(obs: observation),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Color(0xFF0D47A1), // Azul profundo
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.blue,
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              observation.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 16,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${observation.dateTime.year}/${observation.dateTime.month}/${observation.dateTime.day}",
                ),
                Text(observation.category),
                Text(
                  "${observation.lat} \n${observation.lng}",
                  style: TextStyle(fontWeight: FontWeight(700)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
