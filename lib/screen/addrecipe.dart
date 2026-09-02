import 'package:flutter/material.dart';
import '../class/recipe.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

    @override
    State<StatefulWidget> createState() {
        return _AddRecipeState();
    }
}
class _AddRecipeState extends State<AddRecipe> {

    final TextEditingController _recipeNameController = TextEditingController();
    final TextEditingController _recipeDescController = TextEditingController();
    int _charleft=0;
    final TextEditingController _recipePhotoController = TextEditingController();
    
    String _category = 'Indonesian';
    bool _isVegetarian = false;
    String _level = 'Easy';

    @override
    void initState() {
        super.initState();
        _recipeNameController.text = "your food name";
        _recipeDescController.text = "Recipe of ..";  
        _charleft = 200 - _recipeDescController.text.length;
        _recipePhotoController.text = "https://ubaya.cloud/no_image.jpg";
    }


    Color getButtonColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }



    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('Add Recipe'),
            ),
            body:  ListView(
                    children:  [
                    TextField(
                      controller:_recipeNameController,
                      onChanged: (v) {
                         print(_recipeNameController.text);
                         print(v);
                      },                            
   ),


  TextField(
     controller: _recipeDescController,
     onChanged: (v) {setState(() {     
	          _charleft = 200 - v.length;                               
            });
}, 
     keyboardType: TextInputType.multiline,
     minLines: 4,
     maxLines: null,
     maxLength: 200
  ),
  Text("sisa karakter : $_charleft"),

   TextField(
             controller: _recipePhotoController,
             onSubmitted: (v) {
                            setState(() {});
                          },
            ),
        Image.network(_recipePhotoController.text),
        
            DropdownButton<String>(
              value: _category,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _category = newValue;
                  });
                }
              },
              items: <String>['Indonesian', 'Japanese', 'Korean']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Checkbox(
                checkColor: Colors.white,
                value: _isVegetarian,
                activeColor: Colors.blue,
                onChanged: (bool? value) {
                  setState(() {
                    _isVegetarian = value!;
                  });
                },
              ),
              const Text("Vegetarian")
            ]),
            DropdownButton<String>(
              value: _level,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _level = newValue;
                  });
                }
              },
              items: <String>['Easy', 'Medium', 'Difficult']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

            ElevatedButton(
            style: ButtonStyle(
              elevation: WidgetStatePropertyAll(5),
              backgroundColor:
                  WidgetStateProperty.resolveWith(getButtonColor),
            ),
             onPressed: () {
              recipes.add(Recipe(
                    id: recipes.length + 1,
                    name: _recipeNameController.text,
                    desc: _recipeDescController.text,
                    photo: _recipePhotoController.text,
                    category: _category,
                    type: _isVegetarian ? 'Vegetarian' : 'Non Vege',
                    level: _level
                  ));
                  //nanti diisi showdialog
                  	showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text('Add Recipe'),
                            content: Text('Recipe successfully added'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ));

            },

            child: const Text('SUBMIT'))



                ]
            ),
        );
    }
}
