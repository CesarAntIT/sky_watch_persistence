import 'package:objectbox/objectbox.dart';

@Entity()
class Profile {
  @Id()
  int id;

  String name;
  String lastName;
  String studentId;
  String imagePath;

  String phrase;

  Profile({
    this.id = 0,
    required this.name,
    required this.lastName,
    required this.studentId,
    required this.imagePath,
    required this.phrase,
  });
}
