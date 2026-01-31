import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/journal_controller.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../core/utils/validators.dart';
import 'package:intl/intl.dart';

class JournalFormPage extends StatefulWidget {
  final String livreurId;
  const JournalFormPage({Key? key, required this.livreurId}) : super(key: key);

  @override
  State<JournalFormPage> createState() => _JournalFormPageState();
}

class _JournalFormPageState extends State<JournalFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<JournalController>();
  
  final _montantCtrl = TextEditingController();
  final _departCtrl = TextEditingController();
  final _arriveeCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _dateCtrl.text = DateFormat('dd/MM/yyyy HH:mm').format(_selectedDate);
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );
      if (time != null) {
        setState(() {
          _selectedDate = DateTime(
            date.year, date.month, date.day,
            time.hour, time.minute
          );
          _dateCtrl.text = DateFormat('dd/MM/yyyy HH:mm').format(_selectedDate);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter une course')),
      body: Obx(() => IgnorePointer(
        ignoring: _controller.isSaving.value,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AppInput(
                  label: 'Date et Heure', 
                  controller: _dateCtrl, 
                  readOnly: true,
                  onTap: _pickDate,
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                AppInput(
                  label: 'Montant (MRU)', 
                  controller: _montantCtrl, 
                  validator: Validators.number, 
                  keyboardType: TextInputType.number
                ),
                AppInput(label: 'Lieu de départ', controller: _departCtrl, validator: Validators.requiredField),
                AppInput(label: 'Lieu d\'arrivée', controller: _arriveeCtrl, validator: Validators.requiredField),
                AppInput(label: 'Description (Optionnel)', controller: _descCtrl, maxLines: 3),

                const SizedBox(height: 20),
                AppButton(
                  text: 'Enregistrer',
                  isLoading: _controller.isSaving.value,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _controller.addEntry(
                        livreurId: widget.livreurId,
                        montant: double.parse(_montantCtrl.text),
                        depart: _departCtrl.text,
                        arrivee: _arriveeCtrl.text,
                        description: _descCtrl.text,
                        date: _selectedDate,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
