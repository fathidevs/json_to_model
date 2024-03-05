**Effortless Model Generation from JSON** 

Effortlessly streamline your development workflow by automatically generating Dart model classes from JSON data with json_to_model.


**Benefits:**

*Save time and reduce boilerplate code** Focus on your application logic, not repetitive model creation.
**Improved code maintainability** Keep your models consistent and easy to update with changing API responses.
**Enhanced readability and organization** Generated models clearly represent your data structure.

**How It Works:**

1. **Installation:**
   - copy the api folder into "lib" folder

2. **Usage:**
   - run this command in cmd: `dart lib/api/create/xmodel.dart <model_name>.dart`.
   - The generated model file will be placed in the `models` folder.


**Example:**

```
// json
{
  "name": "John Doe",
  "age": 30,
  
}
```

**Generated Model:**

```
// model
class User {
  final String name;
  final int age;
  

  User({
    required this.name,
    required this.age,
  
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json['name'] as String,
        age: json['age'] as int,
  
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
  
      };
}

```
