import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/journal_controller.dart';
import '../../../places/controllers/places_controller.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_input.dart';
import '../../../../core/utils/validators.dart';

class JournalFormPage extends StatefulWidget {
  final String livreurId;
  final String journalId;

  const JournalFormPage({
    Key? key, 
    required this.livreurId, 
    required this.journalId
  }) : super(key: key);

  @override
  State<JournalFormPage> createState() => _JournalFormPageState();
}

class _JournalFormPageState extends State<JournalFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<JournalController>();
  final _placesController = Get.put(PlacesController());
  
  final _montantCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  
  String? _placeDepartId;
  String? _placeArriveeId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter une course')),
      body: Obx(() {
        if (_placesController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return IgnorePointer(
          ignoring: _controller.isSaving.value,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildPlaceDropdowns(),
                  const SizedBox(height: 16),
                  _buildInputFields(),
                  const SizedBox(height: 30),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPlaceDropdowns() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: _placeDepartId,
          decoration: const InputDecoration(labelText: 'Lieu de départ *'),
          items: _placesController.places
              .map((p) => DropdownMenuItem(value: p.id, child: Text(p.nom)))
              .toList(),
          onChanged: (v) => setState(() => _placeDepartId = v),
          validator: (v) => v == null ? 'Requis' : null,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _placeArriveeId,
          decoration: const InputDecoration(labelText: 'Lieu d\'arrivée *'),
          items: _placesController.places
              .map((p) => DropdownMenuItem(value: p.id, child: Text(p.nom)))
              .toList(),
          onChanged: (v) => setState(() => _placeArriveeId = v),
          validator: (v) => v == null ? 'Requis' : null,
        ),
      ],
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        AppInput(
          label: 'Montant (MRU) *', 
          controller: _montantCtrl, 
          validator: Validators.number, 
          keyboardType: TextInputType.number
        ),
        AppInput(label: 'Description (Optionnel)', controller: _descCtrl, maxLines: 3),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return AppButton(
      text: 'ENREGISTRER LA COURSE',
      isLoading: _controller.isSaving.value,
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _controller.addJournalLine(
            journalId: widget.journalId,
            livreurId: widget.livreurId,
            placeDepartId: _placeDepartId!,
            placeArriveeId: _placeArriveeId!,
            montant: double.parse(_montantCtrl.text),
            description: _descCtrl.text,
          );
        }
      },
    );
  }
}
