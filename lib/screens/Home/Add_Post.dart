import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bricolage_app/constants.dart';

class Add_Post extends StatefulWidget {
  const Add_Post({Key? key}) : super(key: key);
  @override
  _Add_PostState createState() => _Add_PostState();
}

class _Add_PostState extends State<Add_Post> {
  final _formKey = GlobalKey<FormState>();
  List<String> TimeUnits = ['min', 'hours', 'days', 'months'];
  String selectedUnit="min";
  String selectedCategorie="Cleaning";
  bool showSpinner=false;
  late String title,location,description;
  late int price,duration;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),

      body:Stack(
        children: [
          SingleChildScrollView(
          padding: EdgeInsets.only(top: size.height * 0.03),
          child: Form(
          key: _formKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: const Text(
                    "CREATE JOB",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2661FA),
                        fontSize: 36
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: size.height * 0.03),

                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (value){title = value;},
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Job Title"
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),

                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child:DropdownSearch<String>(
                      mode: Mode.MENU,
                      items: kcategories,
                      popupShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      dropdownSearchDecoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                        labelText: "Categories",
                        hintText: "Select Categorie",
                        border: OutlineInputBorder(),
                      ),
                      validator: (item) {
                       if (item == null)
                          return "Select Categorie";
                        else
                         return null;
                      },
                    onChanged: (value) {
                        setState(() {
                          selectedCategorie = value.toString();
                        });
                    },
                  ),
                ),

                SizedBox(height: size.height * 0.03),

                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child:  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the price';
                      }
                      return null;
                    },
                    onChanged: (value){price =int.parse(value);},
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Price"
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.03),

                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a value';
                      }
                      return null;
                    },
                    onChanged: (value){location =value;},
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Location"
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.03),

                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
                    children:  [
                        Expanded(
                         child:TextFormField(
                           validator: (value) {
                             if (value == null || value.isEmpty) {
                               return 'Please enter a value';
                             }
                             return null;
                           },
                           onChanged: (value){duration =int.parse(value);},
                           inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                           keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Job Duration"
                          ),
                      ),
                       ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 255, 136, 34),
                                  Color.fromARGB(255, 255, 177, 41)
                                ]
                            )
                        ),
                        child: DropdownButton(
                          alignment: Alignment.center,
                          borderRadius: BorderRadius.circular(15),
                           value: selectedUnit,
                           items: TimeUnits.map((unit) {
                             return DropdownMenuItem(
                               child: Text(unit,style: const TextStyle(fontSize: 17),),
                               value: unit,
                             );
                           }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedUnit = value.toString();
                            });
                          },
                          underline: const SizedBox(),

                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: size.height * 0.03),

                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child:  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (value){description =value;},
                    minLines: 3,
                    maxLines: 15,
                    keyboardType: TextInputType.multiline,
                    decoration:  const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Description",
                      alignLabelWithHint: true,
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.04),

                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                      shadowColor: MaterialStateProperty.all(Colors.transparent)
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate() ) {

                        setState(() {
                          showSpinner=true;
                        });
                       await firestore.collection("posts").add({
                            'title': title,
                            'category':selectedCategorie,
                            'price': price,
                            'location':location,
                            'duration':duration,
                            'time_unit':selectedUnit,
                            'description':description,
                            'createdAt' : Timestamp.now(),
                              'userId' : auth.currentUser?.uid
                       });
                       setState(() {
                         showSpinner=false;
                       });
                       Navigator.pop(context);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      width: size.width * 0.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80.0),
                          gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 255, 136, 34),
                                Color.fromARGB(255, 255, 177, 41)
                              ]
                          )
                      ),
                      padding: const EdgeInsets.all(0),
                      child: const Text(
                        "SUBMIT",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ),
        ),
          showSpinner? Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            ),
          ) : const SizedBox(height: 0),
      ],
      ),
    );
  }
}