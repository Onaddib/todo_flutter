class LanguageModel {
  String? code;
  String? name;

  LanguageModel({required this.code, required this.name});
  Map<String, dynamic> toJson() => {'code': code, 'name': name};
  
}
