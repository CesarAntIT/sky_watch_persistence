import 'package:flutter/material.dart';
import 'package:free_map/free_map.dart';
import 'package:intl/intl.dart';
import 'package:sky_watch/main.dart';
import 'package:sky_watch/services/image_picker_service.dart';
import '../Model/observation_model.dart';

class AddObservation extends StatefulWidget {
  const AddObservation({super.key});

  @override
  State<AddObservation> createState() => _AddObservationState();
}

class _AddObservationState extends State<AddObservation> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Astronomía';
  String _selectedSkyCondition = 'Despejado';
  double? latitude;
  double? longitude;
  String? selectedImage;

  final List<String> _categories = [
    'Astronomía',
    'Meteorología',
    'Emergencia',
    'Objeto Artificial',
    'Otro',
  ];
  final List<String> _conditions = [
    'Despejado',
    'Parcialmente\nNublado',
    'Nublado',
    'Lluvia Ligera',
    'Lluvia Fuerte',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  // Styles for text inputs to look like "Glassmorphism"
  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.amberAccent),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.05),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.white12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.cyanAccent, width: 2),
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.cyanAccent,
              onPrimary: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  void _selectImage() async {
    selectedImage = await ImgPickService.selectImage();
    setState(() {});
  }

  void _getLocationName() async {
    final address = await FmService().getAddress(
      lat: latitude!,
      lng: longitude!,
    );
    setState(() {
      _locationController.text = address?.address ?? "";
    });
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final newObservation = Observation(
        title: _titleController.text,
        skyCondition: _selectedSkyCondition,
        description: _descriptionController.text,
        dateTime: _selectedDate,
        category: _selectedCategory,
        locationText: _locationController.text,
        lat: latitude,
        lng: longitude,
        imagePath: selectedImage ?? "",
        durationSec: int.tryParse(_durationController.text),
      );
      objectbox.addObservation(newObservation);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Nueva Observación'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        //Fondo del Container.
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B1026), Color(0xFF232946)],
          ),
        ),

        child: SafeArea(
          maintainBottomViewPadding: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputStyle('Título *', Icons.edit),
                    validator: (value) =>
                        value!.isEmpty ? 'Ingresa un título' : null,
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          initialValue: _selectedCategory,
                          dropdownColor: const Color(0xFF232946),
                          style: TextStyle(
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis,
                          ),
                          decoration: _inputStyle('Categoría', Icons.category),
                          items: _categories
                              .map(
                                (c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(
                                    c,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedCategory = val!),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          initialValue: _selectedSkyCondition,
                          dropdownColor: const Color(0xFF232946),
                          style: const TextStyle(
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis,
                          ),
                          decoration: _inputStyle('Cielo', Icons.cloud),
                          items: _conditions
                              .map(
                                (c) =>
                                    DropdownMenuItem(value: c, child: Text(c)),
                              )
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedSkyCondition = val!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Fecha Selector
                  InkWell(
                    onTap: _pickDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Fecha: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const Icon(
                            Icons.calendar_today,
                            color: Colors.cyanAccent,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _durationController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: _inputStyle('Duración (segundos)', Icons.timer),
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _locationController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputStyle(
                      'Ubicación (Texto)',
                      Icons.location_city,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Map & Image Section
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final LatLng? selectedLocation =
                                await showModalBottomSheet<LatLng>(
                                  context: context,
                                  backgroundColor: const Color(0xFF0B1026),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25),
                                    ),
                                  ),
                                  isScrollControlled: true,
                                  builder: (context) => Container(
                                    height: 600,
                                    padding: const EdgeInsets.all(20),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: FmMap(
                                        mapOptions: MapOptions(
                                          initialCenter: LatLng(
                                            latitude ?? 18.4861,
                                            longitude ?? -69.9312,
                                          ),
                                          initialZoom: 15,
                                          onTap: (_, point) =>
                                              Navigator.pop(context, point),
                                        ),
                                      ),
                                    ),
                                  ),
                                );

                            if (selectedLocation != null) {
                              setState(() {
                                longitude = selectedLocation.longitude;
                                latitude = selectedLocation.latitude;
                                _getLocationName();
                              });
                            }
                          },
                          icon: const Icon(Icons.map, color: Colors.cyanAccent),
                          label: const Text(
                            "Ubicar en Mapa",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white24),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _selectImage,
                          icon: const Icon(
                            Icons.image,
                            color: Colors.amberAccent,
                          ),
                          label: const Text(
                            "Foto",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white24),
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (latitude != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Coord: ${latitude!.toStringAsFixed(4)}, ${longitude!.toStringAsFixed(4)}",
                        style: const TextStyle(
                          color: Colors.cyanAccent,
                          fontSize: 12,
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputStyle('¿Qué viste? *', Icons.visibility),
                    validator: (value) =>
                        value!.isEmpty ? 'Describe tu observación' : null,
                  ),

                  const SizedBox(height: 40),

                  // Save Button
                  Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withValues(alpha: 0.3),
                          blurRadius: 10,
                          spreadRadius: -2,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _saveForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'REGISTRAR EN EL CIELO',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
