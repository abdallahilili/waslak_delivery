class Validators {
  static String? requiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ce champ est obligatoire';
    }
    return null;
  }

  static String? phoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ce champ est obligatoire';
    }
    // Basic phone validation (adjust regex as needed for Mauritania/specific region)
    // Allows + prefix and 8+ digits
    final phoneRegex = RegExp(r'^\+?[0-9]{8,}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Numéro de téléphone invalide';
    }
    return null;
  }

  static String? nni(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ce champ est obligatoire';
    }
    if (value.length < 10) { // Assuming NNI is at least 10 digits
      return 'NNI invalide';
    }
    return null;
  }
  
  static String? number(String? value) {
     if (value == null || value.trim().isEmpty) {
      return 'Ce champ est obligatoire';
    }
    if (double.tryParse(value) == null) {
      return 'Veuillez entrer un nombre valide';
    }
    return null;
  }
}
