import 'package:objectbox/objectbox.dart';

@Entity()
class Observation {
  // Primary Key
  @Id()
  int id;
  String title;
  // Date and Time
  @Property(type: PropertyType.dateUtc)
  DateTime dateTime;

  //Location Data
  double? lat;
  double? lng;
  String? locationText;

  //Descriptors
  int? durationSec;
  String category;
  String skyCondition;
  String description;

  //File Paths
  String imagePath;
  String audioPath;

  Observation({
    this.id = 0,
    required this.title,
    required this.skyCondition,
    this.locationText,
    this.lng,
    this.lat,
    this.imagePath = "",
    this.durationSec,
    required this.description,
    required this.dateTime,
    required this.category,
    this.audioPath = "",
  });
}
