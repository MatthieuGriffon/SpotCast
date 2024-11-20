import 'package:flutter/material.dart';
import 'package:date_picker_plus/date_picker_plus.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _participantsController = TextEditingController();

  String _selectedType = 'Public'; // Valeur par défaut pour le type

  void _createEvent() {
    if (_formKey.currentState!.validate()) {
      // Récupération des valeurs du formulaire
      final name = _nameController.text;
      final date = _dateController.text;
      final time = _timeController.text;
      final location = _locationController.text;
      final description = _descriptionController.text;
      final participants =
          _participantsController.text.split(',').map((p) => p.trim()).toList();

      // Affichage pour test
      print('Nom : $name');
      print('Date : $date');
      print('Heure : $time');
      print('Lieu : $location');
      print('Description : $description');
      print('Participants : $participants');
      print('Type : $_selectedType');

      // Retour à la page précédente
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un événement'),
        backgroundColor: const Color(0xFF1B3A57),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom de l'événement
                TextFormField(
                  controller: _nameController,
                  decoration:
                      const InputDecoration(labelText: 'Nom de l\'événement *'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Veuillez entrer un nom'
                      : null,
                ),
                const SizedBox(height: 16),

                // Champ de date avec date_picker_plus
                TextFormField(
                  controller: _dateController,
                  decoration:
                      const InputDecoration(labelText: 'Date (jj/mm/aaaa) *'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Veuillez sélectionner une date'
                      : null,
                  readOnly: true, // Rend le champ non modifiable directement
                  onTap: () async {
                    DateTime? pickedDate = await showDatePickerDialog(
                      context: context,
                      minDate: DateTime(2020),
                      maxDate: DateTime(2100),
                      initialDate: DateTime.now(),
                      daysOfTheWeekTextStyle: const TextStyle(
                          fontSize:
                              8), // Réduit la taille des jours de la semaine
                      enabledCellsTextStyle: const TextStyle(
                          fontSize:
                              8), // Réduit la taille des cellules actives
                      currentDateTextStyle: const TextStyle(
                          fontSize: 8,
                          color: Colors.red), // Style pour la date actuelle
                      leadingDateTextStyle: const TextStyle(
                          fontSize: 10), // Style pour les dates précédentes
                      width: 350, // Réduit la largeur
                      height: 350, // Réduit la hauteur
                      slidersSize: 8, // Réduit la taille des sliders
                      selectedCellDecoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );

                    if (pickedDate != null) {
                      String formattedDate =
                          '${pickedDate.day.toString().padLeft(2, '0')}/'
                          '${pickedDate.month.toString().padLeft(2, '0')}/'
                          '${pickedDate.year}';

                      setState(() {
                        _dateController.text = formattedDate;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Heure
                TextFormField(
                  controller: _timeController,
                  decoration:
                      const InputDecoration(labelText: 'Heure (hh:mm) *'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Veuillez entrer une heure'
                      : null,
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 16),

                // Lieu
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Lieu *'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Veuillez entrer un lieu'
                      : null,
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Participants
                TextFormField(
                  controller: _participantsController,
                  decoration: const InputDecoration(
                      labelText: 'Participants (séparés par des virgules)'),
                ),
                const SizedBox(height: 16),

                // Type d'événement
                const Text(
                  'Type d\'événement *',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Public'),
                        value: 'Public',
                        groupValue: _selectedType,
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Privé'),
                        value: 'Privé',
                        groupValue: _selectedType,
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Bouton de soumission
                Center(
                  child: ElevatedButton(
                    onPressed: _createEvent,
                    child: const Text('Créer l\'événement'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _participantsController.dispose();
    super.dispose();
  }
}
