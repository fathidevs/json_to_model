// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

/*
{
    "info": "this is an example json. Replace it with your json:",
    "step_1": "copy your json",
    "step_2": "remove this json, then paste your json here",
    "step_3": "run this command: dart create_model.dart <model_name>",
    "step_4": "Enjoy!",
    "models_location": "you will find it in 'model creator/models'",
    "note_1": "DO NOT PUT JSON IN ARRAY.",
    "note_2a": "to create new model, you will have to clear this json",
    "note_2b": "and add the json for the new model",
    "note_3a": "xmodel.dart gets the type of the json values from ".runtimeType" so,"
    "note_3b": "if a value = null, the type will be "dynamic" "
    "note_3c": "if the value is string of integers the type will be int, you will have to review"
    "note_3c": "and make the necessary fixes"
    "note_4": "if this deserves a coffee, you can give it one by visiting: buymeacoffee.com/fathidevs"
}
*/
void main(List<String> arguments) {
  if (arguments.isEmpty || arguments.length > 1) {
    print(
        '\nFormat Error!\ncommand format: dart lib/create/xmodel.dart <model_name>\n');
    return;
  }
  String tableName = arguments.first;
  final String modelsPath = '${Directory.current.path}/lib/api/models';
  final String jsonPath =
      '${Directory.current.path}/lib/api/create/json_file.json';
  if (File('$modelsPath/$tableName.dart').existsSync()) {
    print('\nOps! ($tableName.dart) already exists\n');
    return;
  }
  // final String jsonPath = '$modelsPath/json_file.json';
  final body = File(jsonPath).readAsStringSync();
  var decodedJson = jsonDecode(body);
  Map<String, dynamic> data = {};
  if (decodedJson.runtimeType == List) {
    data = getObject(decodedJson);
  } else {
    data = decodedJson;
  }
  String variables = '';
  String constructorParameters = '';
  String factoryParameters = '';
  String mapContent = '';
  data.forEach((key, value) {
    String type = value.runtimeType.toString().toLowerCase().contains('ll')
        ? 'dynamic'
        : value.runtimeType.toString();
    variables += 'final $type $key;\n';
    constructorParameters += 'required this.$key,\n';
    factoryParameters += '$key: json["$key"],\n';
    mapContent += '"$key": $key,\n';
  });
  String modelClassBody = """
class ${className(tableName)}{

  $variables

  ${className(tableName)}({
    $constructorParameters
  });

  factory ${className(tableName)}.fromJson(Map<String, dynamic> json){
    return ${className(tableName)}(
      $factoryParameters
    );
    }
  Map<String, dynamic> toJson(){
    return {
      $mapContent
    };
  }
}
  """;
  try {
    File('$modelsPath/$tableName.dart').writeAsStringSync(modelClassBody);
    print(
        '\nYay! ($tableName.dart) was created in "models" folder successfully! Enjoy :)\n');
  } catch (e) {
    print('Error generating model class: $e');
  }
}

Map<String, dynamic> getObject(List<dynamic> arr) {
  if (arr.isEmpty || !arr.first.runtimeType.toString().startsWith('List')) {
    return arr.first;
  } else {
    return getObject(arr.first);
  }
}

className(String tableName) {
  if (tableName.contains('_')) {
    List<String> words = tableName.split('_');
    return words
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join();
  }
  return tableName[0].toUpperCase() + tableName.substring(1);
}
