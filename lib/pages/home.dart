import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/pages/employee.dart';
import 'package:firebase_crud/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  Stream? EmployeeStream;

  getOnTheLoad() async {
    EmployeeStream = await DatabaseMethods().getEmployeeDetails();
    setState(() {});
  }

  @override
  void initState() {
    getOnTheLoad();
    super.initState();
  }

  Widget allEmploeeDetails() {
    return StreamBuilder(
        stream: EmployeeStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        snapshot.data.docs[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                            padding: EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name
                                Row(
                                  children: [
                                    Text(
                                      "Name : " + documentSnapshot["Name"],
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        nameController.text =
                                            documentSnapshot["Name"];
                                        ageController.text =
                                            documentSnapshot["Age"];
                                        locationController.text =
                                            documentSnapshot["Location"];
                                        EditEmployeeDetail(
                                            documentSnapshot["Id"]);
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.orange,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        await DatabaseMethods()
                                            .deleteEmployeeDetails(
                                                documentSnapshot["Id"])
                                            .then((value) {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Employee has been deleted successfully",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        });
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                // Age
                                Text(
                                  "Age : " + documentSnapshot["Age"],
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                // Location
                                Text(
                                  "Location : " + documentSnapshot["Location"],
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )),
                      ),
                    );
                  })
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Employee()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Flutter",
            style: TextStyle(
                color: Colors.blue,
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Firebase",
            style: TextStyle(
                color: Colors.orange,
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          )
        ],
      )),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
        child: Column(children: [Expanded(child: allEmploeeDetails())]),
      ),
    );
  }

  Future EditEmployeeDetail(String id) => showDialog(
      context: context,
      builder: (content) => AlertDialog(
            content: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.cancel)),
                      SizedBox(
                        width: 60.0,
                      ),
                      Text(
                        "Edit",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Details",
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  // Name
                  Text(
                    "Name",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  // Age
                  Text(
                    "Age",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: ageController,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  // Location
                  Text(
                    "Location",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: locationController,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  // Add Button
                  Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic> employeeInfo = {
                            "Id": id,
                            "Name": nameController.text,
                            "Age": ageController.text,
                            "Location": locationController.text,
                          };

                          await DatabaseMethods()
                              .updateEmployeeDetails(employeeInfo, id)
                              .then((value) {
                            Fluttertoast.showToast(
                                msg: "Employee has been updated successfully",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0);

                            Navigator.pop(context);
                          });
                        },
                        child: Text(
                          "Update",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        )),
                  )
                ],
              ),
            ),
          ));
}
