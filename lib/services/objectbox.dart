import 'package:sky_watch/Model/observation_model.dart';
import 'package:sky_watch/Model/profile_model.dart';
import 'package:sky_watch/objectbox.g.dart';
import 'package:sky_watch/services/assets_file_get.dart';
import 'package:sky_watch/services/image_picker_service.dart';

class Objectbox {
  late final Store store;
  late final Box<Observation> observationsBox;
  late final Box<Profile> profileBox;

  //Allows access to the data stored in the app
  Objectbox._create(this.store) {
    observationsBox = Box<Observation>(store);
    profileBox = Box<Profile>(store);

    if (profileBox.isEmpty()) {
      _addDemoData();
    }
  }

  //Opens the database for the app.
  static Future<Objectbox> create() async {
    final store = await openStore();
    return Objectbox._create(store);
  }

  void _addDemoData() async {
    observationsBox.put(
      Observation(
        title: 'Avistamiento de Júpiter',
        skyCondition: 'Despejado',
        locationText: 'Observatorio de las Colinas',
        lng: -70.6483,
        lat: -33.4489,
        durationSec: 1200,
        description:
            'Se observaron claramente las bandas nubosas y cuatro de sus lunas galileanas.',
        dateTime: DateTime(2026, 04, 03, 21, 30),
        category: 'Astronomía',
      ),
    );

    final defaultPhoto = await AssetFileGet.getAssetPath(
      "Foto_Personal_Profesional.jpeg",
    );
    profileBox.put(
      Profile(
        name: "César Antonio",
        lastName: "Aybar Vargas",
        studentId: "20240096",
        imagePath: defaultPhoto,
        phrase:
            "«Cada vez que levantas la vista al cielo, no solo estás mirando estrellas, sino que estás entrenando tu mente para ver más allá de lo evidente y recordándole a tu espíritu que no hay frontera que la curiosidad no pueda cruzar.»",
      ),
    );
  }

  Stream<List<Observation>> getObservations() {
    final builder = observationsBox.query()
      ..order(Observation_.dateTime, flags: Order.descending);
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  void addObservation(Observation obs) async {
    if (obs.imagePath.isNotEmpty) {
      final truePath = await ImgPickService.addImage(obs.imagePath);
      obs.imagePath = truePath;
    }
    observationsBox.put(obs);
  }

  void deleteEvent(int id) {
    observationsBox.remove(id);
  }

  Profile getCurrentProfile() {
    final profileList = profileBox.getAll();
    return profileList[0];
  }

  void deleteAllData() async {
    observationsBox.removeAll();
    profileBox.removeAll();
  }
}
