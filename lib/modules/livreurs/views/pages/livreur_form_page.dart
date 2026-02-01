import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/livreur_controller.dart';
import '../../models/livreur_model.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_input.dart';
import '../../../../core/utils/validators.dart';
import '../widgets/form_image_picker.dart';

class LivreurFormPage extends StatefulWidget {
  final LivreurModel? livreur;
  
  const LivreurFormPage({Key? key, this.livreur}) : super(key: key);

  @override
  State<LivreurFormPage> createState() => _LivreurFormPageState();
}

class _LivreurFormPageState extends State<LivreurFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<LivreurController>();
  
  late TextEditingController _nomCtrl;
  late TextEditingController _nniCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _whatsappCtrl;

  File? _profilImage, _cniImage, _carteGriseImage, _assuranceImage, _motoImage;
  final ImagePicker _picker = ImagePicker();
  String _statut = 'actif';

  @override
  void initState() {
    super.initState();
    _nomCtrl = TextEditingController(text: widget.livreur?.nom);
    _nniCtrl = TextEditingController(text: widget.livreur?.nni);
    _phoneCtrl = TextEditingController(text: widget.livreur?.telephone);
    _whatsappCtrl = TextEditingController(text: widget.livreur?.whatsapp);
    _statut = widget.livreur?.statut ?? 'actif';
  }

  Future<void> _pickImage(String type) async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (file != null) {
      setState(() {
        switch (type) {
          case 'profil': _profilImage = File(file.path); break;
          case 'cni': _cniImage = File(file.path); break;
          case 'carte_grise': _carteGriseImage = File(file.path); break;
          case 'assurance': _assuranceImage = File(file.path); break;
          case 'moto': _motoImage = File(file.path); break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.livreur == null ? 'Ajouter Livreur' : 'Modifier Livreur')),
      body: Obx(() => IgnorePointer(
        ignoring: _controller.isSaving.value,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                FormImagePicker(
                  label: 'Photo de profil',
                  image: _profilImage,
                  currentUrl: widget.livreur?.photoProfilUrl,
                  type: 'profil',
                  onTap: () => _pickImage('profil'),
                ),
                _buildBasicInfoSection(),
                const Divider(),
                _buildDocumentsSection(),
                const SizedBox(height: 20),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      children: [
        AppInput(label: 'Nom complet', controller: _nomCtrl, validator: Validators.requiredField),
        AppInput(label: 'NNI', controller: _nniCtrl, validator: Validators.nni, keyboardType: TextInputType.number),
        AppInput(label: 'Téléphone', controller: _phoneCtrl, validator: Validators.phoneNumber, keyboardType: TextInputType.phone),
        AppInput(label: 'Whatsapp (Optionnel)', controller: _whatsappCtrl, keyboardType: TextInputType.phone),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: _statut,
          decoration: const InputDecoration(labelText: 'Statut du livreur'),
          items: ['actif', 'inactif', 'suspendu']
              .map((e) => DropdownMenuItem(value: e, child: Text(e.toUpperCase())))
              .toList(),
          onChanged: (v) => setState(() => _statut = v!),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDocumentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Documents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: FormImagePicker(
                label: 'CNI',
                image: _cniImage,
                currentUrl: widget.livreur?.photoCniUrl,
                type: 'cni',
                onTap: () => _pickImage('cni'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FormImagePicker(
                label: 'Carte Grise',
                image: _carteGriseImage,
                currentUrl: widget.livreur?.photoCarteGriseUrl,
                type: 'carte_grise',
                onTap: () => _pickImage('carte_grise'),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: FormImagePicker(
                label: 'Assurance',
                image: _assuranceImage,
                currentUrl: widget.livreur?.photoAssuranceUrl,
                type: 'assurance',
                onTap: () => _pickImage('assurance'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FormImagePicker(
                label: 'Moto',
                image: _motoImage,
                currentUrl: widget.livreur?.photoMotoUrl,
                type: 'moto',
                onTap: () => _pickImage('moto'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return AppButton(
      text: 'Enregistrer',
      isLoading: _controller.isSaving.value,
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          if (widget.livreur == null) {
            _controller.createLivreur(
              _nomCtrl.text,
              _nniCtrl.text,
              _phoneCtrl.text,
              _whatsappCtrl.text,
              _statut,
              photoProfil: _profilImage,
              photoCni: _cniImage,
              photoCarteGrise: _carteGriseImage,
              photoAssurance: _assuranceImage,
              photoMoto: _motoImage,
            );
          } else {
            _controller.updateLivreur(widget.livreur!.id, {
              'nom': _nomCtrl.text,
              'nni': _nniCtrl.text,
              'telephone': _phoneCtrl.text,
              'whatsapp': _whatsappCtrl.text,
              'statut': _statut,
            });
          }
        }
      },
    );
  }
}
