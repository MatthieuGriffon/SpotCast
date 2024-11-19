import 'package:flutter/material.dart';

class SpotDetailsModal extends StatefulWidget {
  final Function(String spotName, String description, String fishType,
      String spotType, String? group) onSubmit;

  const SpotDetailsModal({super.key, required this.onSubmit});

  @override
  State<SpotDetailsModal> createState() => _SpotDetailsModalState();
}

class _SpotDetailsModalState extends State<SpotDetailsModal> {
  final TextEditingController _spotNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _fishTypeController = TextEditingController();

  String _selectedSpotType = 'Public'; // Valeur par défaut
  String? _selectedGroup;
  final List<String> _userGroups = ['Group1', 'Group2', 'Group3'];

  @override
  void dispose() {
    _spotNameController.dispose();
    _descriptionController.dispose();
    _fishTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nom du spot
            TextField(
              controller: _spotNameController,
              decoration: const InputDecoration(
                labelText: 'Nom du Spot *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),

            // Description
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),

            // Type de poissons
            TextField(
              controller: _fishTypeController,
              decoration: const InputDecoration(
                labelText: 'Type de poissons disponibles',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Type de spot
            const Text(
              'Type de Spot *',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14, // Taille de la police du titre
              ),
            ),
            Column(
              children: [
                RadioListTile<String>(
                  title: const Text(
                    'Public',
                    style:
                        TextStyle(fontSize: 12), // Taille de la police réduite
                  ),
                  value: 'Public',
                  groupValue: _selectedSpotType,
                  onChanged: (value) {
                    setState(() {
                      _selectedSpotType = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text(
                    'Privé',
                    style:
                        TextStyle(fontSize: 12), // Taille de la police réduite
                  ),
                  value: 'Privé',
                  groupValue: _selectedSpotType,
                  onChanged: (value) {
                    setState(() {
                      _selectedSpotType = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text(
                    'Groupe',
                    style:
                        TextStyle(fontSize: 12), // Taille de la police réduite
                  ),
                  value: 'Groupe',
                  groupValue: _selectedSpotType,
                  onChanged: (value) {
                    setState(() {
                      _selectedSpotType = value!;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Groupe associé (affiché seulement si le type est "Groupe")
            if (_selectedSpotType == 'Groupe')
              DropdownButtonFormField<String>(
                value: _selectedGroup,
                items: _userGroups
                    .map((group) => DropdownMenuItem(
                          value: group,
                          child: Text(group),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGroup = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Groupe associé',
                  border: OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 16),

            // Boutons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_spotNameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Veuillez entrer un nom pour le spot.'),
                        ),
                      );
                      return;
                    }

                    widget.onSubmit(
                      _spotNameController.text,
                      _descriptionController.text,
                      _fishTypeController.text,
                      _selectedSpotType,
                      _selectedGroup,
                    );
                  },
                  child: const Text('Enregistrer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
