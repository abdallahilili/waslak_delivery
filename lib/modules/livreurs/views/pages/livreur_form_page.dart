import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/livreur_controller.dart';
import '../../models/livreur_model.dart';
import '../widgets/document_uploader.dart';

class LivreurFormPage extends StatefulWidget {
  final LivreurModel? livreur;

  const LivreurFormPage({super.key, this.livreur});

  @override
  State<LivreurFormPage> createState() => _LivreurFormPageState();
}

class _LivreurFormPageState extends State<LivreurFormPage> {
  final controller = Get.find<LivreurController>();
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Controllers Step 1
  late TextEditingController _nomCtrl;
  late TextEditingController _prenomCtrl;
  late TextEditingController _nniCtrl;
  late TextEditingController _telCtrl;
  late TextEditingController _whatsappCtrl;
  late TextEditingController _emailCtrl;
  DateTime? _dateNaissance;

  // Controllers Step 2
  late TextEditingController _adresseCtrl;
  late TextEditingController _villeCtrl;
  late TextEditingController _quartierCtrl;
  String? _zoneService;

  // Controllers Step 3
  String? _typeVehicule = 'moto';
  late TextEditingController _marqueCtrl;
  late TextEditingController _modeleCtrl;
  late TextEditingController _immatCtrl;
  late TextEditingController _couleurCtrl;
  late TextEditingController _anneeCtrl;

  // Step 4 (Files)
  File? _fProfil, _fCni, _fPermis, _fCarteGrise, _fAssurance, _fMoto;
  DateTime? _expPermis, _expAssurance;

  // Step 5
  double _commission = 10.0;
  int _priorite = 0;
  bool _estFavori = false;

  @override
  void initState() {
    super.initState();
    final l = widget.livreur;
    _nomCtrl = TextEditingController(text: l?.nom);
    _prenomCtrl = TextEditingController(text: l?.prenom);
    _nniCtrl = TextEditingController(text: l?.nni);
    _telCtrl = TextEditingController(text: l?.telephone);
    _whatsappCtrl = TextEditingController(text: l?.whatsapp);
    _emailCtrl = TextEditingController(text: l?.email);
    _dateNaissance = l?.dateNaissance;

    _adresseCtrl = TextEditingController(text: l?.adresse);
    _villeCtrl = TextEditingController(text: l?.ville);
    _quartierCtrl = TextEditingController(text: l?.quartier);
    _zoneService = l?.zoneService;

    _typeVehicule = l?.typeVehicule ?? 'moto';
    _marqueCtrl = TextEditingController(text: l?.marque);
    _modeleCtrl = TextEditingController(text: l?.modele);
    _immatCtrl = TextEditingController(text: l?.immatriculation);
    _couleurCtrl = TextEditingController(text: l?.couleur);
    _anneeCtrl = TextEditingController(text: l?.annee?.toString());

    _expPermis = l?.dateExpirationPermis;
    _expAssurance = l?.dateExpirationAssurance;

    _commission = l?.commissionPlateforme ?? 10.0;
    _priorite = l?.priorite ?? 0;
    _estFavori = l?.estFavori ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.livreur != null ? 'Modifier Livreur' : 'Nouveau Livreur'),
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.horizontal,
          currentStep: _currentStep,
          onStepContinue: _onStepContinue,
          onStepCancel: _onStepCancel,
          onStepTapped: (step) => setState(() => _currentStep = step),
          steps: [
            _buildStep1(),
            _buildStep2(),
            _buildStep3(),
            _buildStep4(),
            _buildStep5(),
          ],
        ),
      ),
    );
  }

  Step _buildStep1() {
    return Step(
      title: const Text('Perso'),
      isActive: _currentStep >= 0,
      content: Column(
        children: [
          TextFormField(controller: _nomCtrl, decoration: const InputDecoration(labelText: 'Nom *')),
          const SizedBox(height: 8),
          TextFormField(controller: _prenomCtrl, decoration: const InputDecoration(labelText: 'Prénom')),
          const SizedBox(height: 8),
          TextFormField(controller: _nniCtrl, decoration: const InputDecoration(labelText: 'NNI *'), keyboardType: TextInputType.number),
          const SizedBox(height: 8),
          TextFormField(controller: _telCtrl, decoration: const InputDecoration(labelText: 'Téléphone *'), keyboardType: TextInputType.phone),
          const SizedBox(height: 8),
          TextFormField(controller: _whatsappCtrl, decoration: const InputDecoration(labelText: 'WhatsApp'), keyboardType: TextInputType.phone),
          const SizedBox(height: 8),
          TextFormField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress),
        ],
      ),
    );
  }

  Step _buildStep2() {
    return Step(
      title: const Text('Adresse'),
      isActive: _currentStep >= 1,
      content: Column(
        children: [
          TextFormField(controller: _adresseCtrl, decoration: const InputDecoration(labelText: 'Adresse')),
          const SizedBox(height: 8),
          TextFormField(controller: _villeCtrl, decoration: const InputDecoration(labelText: 'Ville')),
          const SizedBox(height: 8),
          TextFormField(controller: _quartierCtrl, decoration: const InputDecoration(labelText: 'Quartier')),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _zoneService,
            decoration: const InputDecoration(labelText: 'Zone de service'),
            items: const [
              DropdownMenuItem(value: 'NKC_CENTER', child: Text('NKC Centre')),
              DropdownMenuItem(value: 'NKC_NORTH', child: Text('NKC Nord')),
              DropdownMenuItem(value: 'NKC_SOUTH', child: Text('NKC Sud')),
            ],
            onChanged: (v) => setState(() => _zoneService = v),
          ),
        ],
      ),
    );
  }

  Step _buildStep3() {
    return Step(
      title: const Text('Véhicule'),
      isActive: _currentStep >= 2,
      content: Column(
        children: [
          DropdownButtonFormField<String>(
            value: _typeVehicule,
            decoration: const InputDecoration(labelText: 'Type de véhicule *'),
            items: const [
              DropdownMenuItem(value: 'moto', child: Text('Moto')),
              DropdownMenuItem(value: 'voiture', child: Text('Voiture')),
              DropdownMenuItem(value: 'velo', child: Text('Vélo')),
            ],
            onChanged: (v) => setState(() => _typeVehicule = v),
          ),
          const SizedBox(height: 8),
          TextFormField(controller: _marqueCtrl, decoration: const InputDecoration(labelText: 'Marque')),
          const SizedBox(height: 8),
          TextFormField(controller: _modeleCtrl, decoration: const InputDecoration(labelText: 'Modèle')),
          const SizedBox(height: 8),
          TextFormField(controller: _immatCtrl, decoration: const InputDecoration(labelText: 'Immatriculation')),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: TextFormField(controller: _couleurCtrl, decoration: const InputDecoration(labelText: 'Couleur'))),
              const SizedBox(width: 8),
              Expanded(child: TextFormField(controller: _anneeCtrl, decoration: const InputDecoration(labelText: 'Année'), keyboardType: TextInputType.number)),
            ],
          ),
        ],
      ),
    );
  }

  Step _buildStep4() {
    return Step(
      title: const Text('Docs'),
      isActive: _currentStep >= 3,
      content: Column(
        children: [
          DocumentUploader(label: 'Photo Profil', initialUrl: widget.livreur?.photoProfilUrl, onFileChanged: (f) => _fProfil = f),
          const SizedBox(height: 12),
          DocumentUploader(label: 'Photo CNI', initialUrl: widget.livreur?.photoCniUrl, onFileChanged: (f) => _fCni = f),
          const SizedBox(height: 12),
          DocumentUploader(label: 'Permis de conduire', initialUrl: widget.livreur?.photoPermisUrl, onFileChanged: (f) => _fPermis = f),
          const SizedBox(height: 12),
          DocumentUploader(label: 'Carte Grise', initialUrl: widget.livreur?.photoCarteGriseUrl, onFileChanged: (f) => _fCarteGrise = f),
          const SizedBox(height: 12),
          DocumentUploader(label: 'Assurance', initialUrl: widget.livreur?.photoAssuranceUrl, onFileChanged: (f) => _fAssurance = f),
          const SizedBox(height: 12),
          DocumentUploader(label: 'Moto', initialUrl: widget.livreur?.photoMotoUrl, onFileChanged: (f) => _fMoto = f),
        ],
      ),
    );
  }

  Step _buildStep5() {
    return Step(
      title: const Text('Config'),
      isActive: _currentStep >= 4,
      content: Column(
        children: [
          const Text('Commission Plateforme (%)'),
          Slider(
            value: _commission,
            min: 0,
            max: 50,
            divisions: 50,
            label: '${_commission.round()}%',
            onChanged: (v) => setState(() => _commission = v),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            value: _priorite,
            decoration: const InputDecoration(labelText: 'Priorité'),
            items: [0, 1, 2, 3, 4, 5].map((p) => DropdownMenuItem(value: p, child: Text('Priorité $p'))).toList(),
            onChanged: (v) => setState(() => _priorite = v ?? 0),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('Ajouter aux favoris'),
            value: _estFavori,
            activeColor: Colors.blue,
            onChanged: (v) => setState(() => _estFavori = v),
          ),
        ],
      ),
    );
  }

  void _onStepContinue() async {
    if (_currentStep < 4) {
      setState(() => _currentStep++);
    } else {
      // Save logic
      if (_formKey.currentState!.validate()) {
         _saveLivreur();
      }
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Get.back();
    }
  }

  Future<void> _saveLivreur() async {
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    
    try {
      // 1. Upload new files if any
      String? urlProfil = _fProfil != null ? await controller.uploadDocument(_fProfil!, 'profils') : widget.livreur?.photoProfilUrl;
      String? urlCni = _fCni != null ? await controller.uploadDocument(_fCni!, 'docs') : widget.livreur?.photoCniUrl;
      String? urlPermis = _fPermis != null ? await controller.uploadDocument(_fPermis!, 'docs') : widget.livreur?.photoPermisUrl;
      String? urlCG = _fCarteGrise != null ? await controller.uploadDocument(_fCarteGrise!, 'docs') : widget.livreur?.photoCarteGriseUrl;
      String? urlAss = _fAssurance != null ? await controller.uploadDocument(_fAssurance!, 'docs') : widget.livreur?.photoAssuranceUrl;
      String? urlMoto = _fMoto != null ? await controller.uploadDocument(_fMoto!, 'motos') : widget.livreur?.photoMotoUrl;

      final data = {
        'nom': _nomCtrl.text,
        'prenom': _prenomCtrl.text,
        'nni': _nniCtrl.text,
        'telephone': _telCtrl.text,
        'whatsapp': _whatsappCtrl.text,
        'email': _emailCtrl.text,
        'adresse': _adresseCtrl.text,
        'ville': _villeCtrl.text,
        'quartier': _quartierCtrl.text,
        'zone_service': _zoneService,
        'type_vehicule': _typeVehicule,
        'marque': _marqueCtrl.text,
        'modele': _modeleCtrl.text,
        'immatriculation': _immatCtrl.text,
        'couleur': _couleurCtrl.text,
        'annee': int.tryParse(_anneeCtrl.text),
        'photo_profil_url': urlProfil,
        'photo_cni_url': urlCni,
        'photo_permis_url': urlPermis,
        'photo_carte_grise_url': urlCG,
        'photo_assurance_url': urlAss,
        'photo_moto_url': urlMoto,
        'commission_plateforme': _commission,
        'priorite': _priorite,
        'est_favori': _estFavori,
        'statut': widget.livreur?.statut ?? 'actif',
      };

      if (widget.livreur == null) {
        await controller.createLivreur(LivreurModel.fromMap({...data, 'id': '', 'created_at': DateTime.now().toIso8601String()}));
      } else {
        await controller.updateLivreur(widget.livreur!.id, data);
      }
      
      Get.back(); // Close loading dialog
      Get.back(); // Close form
      Get.snackbar('Succès', 'Livreur enregistré avec succès');
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar('Erreur', 'Impossible d\'enregistrer le livreur: $e');
    }
  }
}
