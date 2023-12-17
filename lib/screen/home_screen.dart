import 'package:flutter/material.dart';

import '../model/db_handler.dart';
import '../model/task_model.dart';
import 'add_update_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper? dbHelper;
  late Future<List<Task>> dataList;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    dataList = dbHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ToDo List'),
          backgroundColor: Colors.black,
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/images/bck.jpg"), //home screen background image
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                  child: FutureBuilder(
                future: dataList,
                builder: (context, AsyncSnapshot<List<Task>> snapshot) {
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.length == 0) {
                    return const Center(
                      child: Text('No Tasks Found'),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        // Example usage in HomeScreen
                        int todoId = snapshot.data![index].id ?? 0;
                        String todoTitle =
                            snapshot.data![index].title.toString();
                        String todoDesc = snapshot.data![index].desc.toString();
                        String todoDateandtime =
                            snapshot.data![index].dateandtime.toString();
                        //print(todoTitle);
                        //print(todoId);
                        return Container(
                          //width: MediaQuery.of(context).size.width * 0.8,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.cyan.withOpacity(0.7),
                              boxShadow: [
                                const BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 4,
                                    spreadRadius: 1),
                              ]),
                          child: Column(
                            children: [
                              //task delete function
                              GestureDetector(
                                onLongPress: () {
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    _showDeleteDialog(context, todoId);
                                  });
                                },
                                //task card
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        //task title
                                        Flexible(
                                          child: Text(
                                            todoTitle,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),

                                        //task edit function button
                                        InkWell(
                                            onTap: () {
                                              //print('hi');
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddUpdateScreen(
                                                            todoId: todoId,
                                                            todoTitle:
                                                                todoTitle,
                                                            todoDesc: todoDesc,
                                                            isUpdate: true,
                                                          )));
                                            },
                                            child: const Icon(
                                              Icons.edit,
                                              color: Colors.black,
                                            )),
                                      ],
                                    ),
                                  ),
                                  //task description
                                  subtitle: Text(
                                    todoDesc,
                                    style: const TextStyle(
                                        fontFamily: 'Caveat',
                                        fontSize: 16,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              //divider line
                              const Divider(
                                color: Colors.black54,
                                thickness: 0.8,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 10),
                                //task updated date & time
                                child: Text(
                                  todoDateandtime,
                                  style: const TextStyle(
                                      fontFamily: 'Roboto', fontSize: 15),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ))
            ],
          ),
        ),
        //create task floating button
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.black54,
          label: const Text('New Task'),
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddUpdateScreen(
                          isUpdate: false,
                        )));
          },
        ),
      ),
    );
  }

  //delete function
  void _showDeleteDialog(BuildContext context, int todoId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  dbHelper!.deleteTask(todoId);
                  dataList = dbHelper!.getDataList();
                  Navigator.pop(context);
                });
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
