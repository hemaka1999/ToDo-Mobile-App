import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/db_handler.dart';
import '../model/task_model.dart';
import 'home_screen.dart';

class AddUpdateScreen extends StatefulWidget {
  int? todoId;
  String? todoTitle;
  String? todoDesc;
  String? todoDateandtime;
  bool? isUpdate;

  AddUpdateScreen({
    this.todoId,
    this.todoTitle,
    this.todoDesc,
    this.todoDateandtime,
    this.isUpdate,
  });

  @override
  State<AddUpdateScreen> createState() => _AddUpdateScreenState();
}

class _AddUpdateScreenState extends State<AddUpdateScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  late TextEditingController titleEditingController;
  late TextEditingController descEditingController;

  DBHelper? dbHelper;
  late Future<List<Task>> dataList;
  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    titleEditingController = TextEditingController(text: widget.todoTitle);
    descEditingController = TextEditingController(text: widget.todoDesc);
  }

  localData() async {
    dataList = dbHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    //Title Field
    final titleField = TextFormField(
      controller: titleEditingController,
      keyboardType: TextInputType.text,
      minLines: 1,
      maxLines: null,
      maxLength: 50,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          hintText: 'Enter title here',
          filled: true,
          fillColor: Colors.white.withOpacity(0.7),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15)),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter a title';
        }
        return null;
      },
      onSaved: (value) {
        titleEditingController.text = value!;
      },
    );

    //Description Field
    final descField = TextFormField(
      controller: descEditingController,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      minLines: 5,
      maxLines: null,
      maxLength: 400,
      decoration: InputDecoration(
          hintText: 'Enter description here',
          filled: true,
          fillColor: Colors.white.withOpacity(0.7),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15)),
      // validator: (value) {
      //   if(value == null || value.isEmpty){
      //     return 'Enter a description';
      //   }
      //   return null;
      // },
      onSaved: (value) {
        descEditingController.text = value!;
      },
    );

    //Save Button
    final saveButton = Material(
      elevation: 5,
      color: Colors.black.withOpacity(0.8),
      borderRadius: BorderRadius.circular(50),
      child: MaterialButton(
        child: const Text('Save'),
        textColor: Colors.white,
        onPressed: () {
          if (_formkey.currentState!.validate()) {
            if (widget.isUpdate == true) {
              dbHelper!.updateTask(Task(
                  id: widget.todoId,
                  title: titleEditingController.text,
                  desc: descEditingController.text,
                  dateandtime: DateFormat('yMd')
                      .add_jm()
                      .format(DateTime.now())
                      .toString()));
            } else {
              dbHelper!.insertTask(Task(
                  title: titleEditingController.text,
                  desc: descEditingController.text,
                  dateandtime: DateFormat('yMd')
                      .add_jm()
                      .format(DateTime.now())
                      .toString()));
            }

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
            // print('Data added');
          }
        },
      ),
    );
    String appTitle;
    if (widget.isUpdate == true) {
      appTitle = "Update Task";
    } else {
      appTitle = "Create Task";
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/images/bck2.jpg"), //addUpdate screen background image
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  //title textFormField
                  titleField,
                  const SizedBox(
                    height: 10,
                  ),
                  //description textFormField
                  descField,
                  const SizedBox(
                    height: 20,
                  ),
                  //save button
                  saveButton,
                ],
              ),
            ),
          ),
        ),
    );
  }
}
