import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sky_watch/Model/observation_model.dart';
import 'package:sky_watch/Widgets/list_observation.dart';
import 'package:sky_watch/main.dart';
import 'package:sky_watch/services/image_picker_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentSort = "Date";

  void showDeleteAll() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0B1026),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.5)),
          ),
          title: const Text(
            "ELIMINAR TODO",
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "Esta acción eliminará permanentemente todos los datos y cerrará la aplicación.\n\n¿Desea continuar?",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "CANCELAR",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                objectbox.deleteAllData();
                ImgPickService.deleteAllImages();
                SystemNavigator.pop();
              },
              child: const Text(
                "SÍ, ELIMINAR",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  //Ayuda a estilizar los botones de filtro, es chulo
  Widget _botonFiltro(String label, String value) {
    bool isActive = _currentSort == value;
    return InkWell(
      onTap: () => setState(() => _currentSort = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.cyanAccent.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isActive ? Colors.cyanAccent : Colors.white12,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.cyanAccent : Colors.white70,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("SKY WATCH"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: showDeleteAll,
            icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            icon: const Icon(Icons.info_outline, color: Colors.cyanAccent),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B1026), Color(0xFF232946)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              //Barra con opciones de Sorteo
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _botonFiltro("Fecha", "Date"),
                    _botonFiltro("Categoría", "Category"),
                    _botonFiltro("Localidad", "Location"),
                  ],
                ),
              ),

              Expanded(
                child: StreamBuilder<List<Observation>>(
                  stream: objectbox.getObservations(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.cyanAccent,
                        ),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          "No hay rastros en el cielo todavía...",
                          style: TextStyle(
                            color: Colors.white38,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      );
                    }

                    final obsList = List<Observation>.from(snapshot.data!);

                    // Sorting Logic
                    switch (_currentSort) {
                      case "Date":
                        obsList.sort(
                          (a, b) => b.dateTime.compareTo(a.dateTime),
                        );
                        break;
                      case "Category":
                        obsList.sort(
                          (a, b) => a.category.compareTo(b.category),
                        );
                        break;
                      case "Location":
                        obsList.sort(
                          (a, b) => (a.locationText ?? '').compareTo(
                            b.locationText ?? "",
                          ),
                        );
                        break;
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      physics: const BouncingScrollPhysics(),
                      itemCount: obsList.length,
                      itemBuilder: (context, index) {
                        return ListObservation(observation: obsList[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyanAccent,
        foregroundColor: Colors.black,
        elevation: 10,
        onPressed: () => Navigator.pushNamed(context, '/observation'),
        child: const Icon(Icons.add_a_photo_rounded),
      ),
    );
  }
}
