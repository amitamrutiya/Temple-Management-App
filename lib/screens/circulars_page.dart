import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:temple/models/circular_model.dart';
import 'package:temple/utils/colors.dart';
import 'package:temple/utils/constant.dart';
import 'package:temple/utils/dimensions.dart';
import 'package:temple/widget/big_text.dart';
import 'package:temple/widget/show_custom_snakbar.dart';
import 'package:temple/widget/small_text.dart';

class CircularPage extends StatefulWidget {
  CircularPage({Key? key}) : super(key: key);

  @override
  State<CircularPage> createState() => _CircularPageState();
}

// int number = 0;

class _CircularPageState extends State<CircularPage> {
  firebase_storage.Reference? ref;
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  var pickDateController = TextEditingController();

  Future<void> uploadCircularPDF() async {
    CircularModel form = CircularModel(
      uploadTime: DateTime.now().toIso8601String(),
      eventTitle: titleController.text.toString(),
      date: pickDateController.text.toString(),
      pdfname: ref?.name,
    );
    return FirebaseFirestore.instance
        .collection("Circular")
        .add(form.toJson())
        .then((_) async {
      print("got data");
    }).catchError((error) {
      showCustomSnakBar("An error occured", title: "Attentation");
    });
  }

  final RxBool _hasInternet = false.obs;
  RxBool get hasInternet => _hasInternet;
  Future checkInternetConnection() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      setState(() {
        _hasInternet(false);
      });
    } else {
      setState(() {
        _hasInternet(true);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    () async {
      await checkInternetConnection();
    }();
  }

  @override
  Widget build(BuildContext context) {
    File? file;

    return Scaffold(
      appBar: Constant.appBar("Circulars"),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Circular")
              .orderBy('uploadTime', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            if (hasInternet.isTrue) {
              return Container(
                  color: AppColors.pageColor,
                  height: double.infinity,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width15,
                    vertical: Dimensions.width20,
                  ),
                  child: ListView.builder(
                      itemBuilder: ((context, index) {
                        DocumentSnapshot data = snapshot.data!.docs[index];
                        return Column(
                          children: [
                            Container(
                              height: Dimensions.height20 * 10,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radius20)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: Dimensions.width15,
                                        left: Dimensions.width15,
                                        top: Dimensions.height15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        BigText(text: '${data['eventTitle']}'),
                                        InkWell(
                                          child: Icon(
                                            Icons.delete,
                                            size: Dimensions.iconSize24,
                                          ),
                                          onTap: () async {
                                            if (ConnectivityResult.none ==
                                                await Connectivity()
                                                    .checkConnectivity()) {
                                              showCustomSnakBar(
                                                  "Turn On Your Internet Connection",
                                                  title: "Attention");
                                            } else {
                                              await deleteCircularData(data.id,
                                                  index, data['pdfname']);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: Dimensions.height10),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: Dimensions.width15),
                                    child: BigText(text: data['date']),
                                  ),
                                  SizedBox(
                                    height: Dimensions.height10,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: ButtonTheme(
                                      buttonColor: Colors.grey,
                                      height: Dimensions.height20 * 2,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        onPressed: () async {
                                          await checkInternetConnection();
                                          if (hasInternet == true)
                                            openFile(fileName: data['pdfname']);
                                          else
                                            showCustomSnakBar("Attension",
                                                title:
                                                    "Internet Connection Required");
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.touch_app),
                                            SizedBox(width: Dimensions.width20),
                                            BigText(text: "Open PDF"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: Dimensions.height20,
                            )
                          ],
                        );
                      }),
                      itemCount: snapshot.data!.docs.length));
            } else {
              return RefreshIndicator(
                onRefresh: () async {
                  await checkInternetConnection();
                  if (hasInternet == true) {
                    setState(() {});
                  }
                },
                child: ListView(
                  children: [
                    SizedBox(height: Dimensions.height45 * 2),
                    Image.asset(
                      'assets/images/no_internet.jpg',
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      height: Dimensions.height15,
                    ),
                    Center(
                      child: BigText(
                        text: "Attention!!!",
                        color: Colors.redAccent,
                        size: Dimensions.font26,
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    Center(
                      child: BigText(
                        text: "Internet Connection Required",
                        // color: Colors.redAccent,
                        size: Dimensions.font20,
                      ),
                    ),
                    SizedBox(height: Dimensions.height10),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: Dimensions.height10),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius20),
                          color: AppColors.mainColor),
                      child: Column(
                        children: [
                          Center(
                            child: SmallText(
                              text: "Turn on Internet",
                              color: Colors.white,
                              size: Dimensions.iconSize16,
                            ),
                          ),
                          Center(
                              child: SmallText(
                            text: "Refresh This Page",
                            color: Colors.white,
                            size: Dimensions.iconSize16,
                          )),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          }),
      floatingActionButton: _hasInternet == true
          ? FloatingActionButton(
              backgroundColor: AppColors.mainColor,
              onPressed: (() {
                titleController.clear();
                pickDateController.clear();
                file = null;
                String buttontext = "Upload PDF";
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: ((context) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Wrap(children: [
                        Container(
                          color: Color(0xFF737373),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(Dimensions.radius15),
                                topRight: Radius.circular(Dimensions.radius15),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.width20,
                                vertical: Dimensions.height20),
                            child: StatefulBuilder(builder:
                                (BuildContext context, StateSetter State) {
                              return Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildTitle(),
                                    SizedBox(height: Dimensions.height20),
                                    buildDateTextField(),
                                    SizedBox(height: Dimensions.height20),
                                    ButtonTheme(
                                      height: Dimensions.height20 * 2,
                                      buttonColor:
                                          Color.fromARGB(255, 231, 231, 231),
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        onPressed:
                                            buttontext == "We got Your PDF"
                                                ? null
                                                : () async {
                                                    final path =
                                                        await FlutterDocumentPicker
                                                            .openDocument();
                                                    if (path != null) {
                                                      State(
                                                        () {
                                                          file = File(path);
                                                        },
                                                      );
                                                      State(
                                                        () {
                                                          buttontext =
                                                              "We got Your PDF";
                                                        },
                                                      );
                                                    }
                                                  },
                                        child: Text(
                                          buttontext,
                                          style: TextStyle(
                                              fontSize: Dimensions.font16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.height20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        ButtonTheme(
                                          height: Dimensions.height20 * 2,
                                          child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              onPressed: file == null
                                                  ? null
                                                  : () async {
                                                      final isValid = _formKey
                                                          .currentState!
                                                          .validate();
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                      if (isValid) {
                                                        _formKey.currentState!
                                                            .save();

                                                        Navigator.pop(context);
                                                        await uploadFile(file!);
                                                        file = null;
                                                        await uploadCircularPDF();
                                                        titleController.clear();
                                                        pickDateController
                                                            .clear();
                                                      }
                                                    },
                                              child: Text("Submit",
                                                  style: TextStyle(
                                                      fontSize:
                                                          Dimensions.font16,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                      ]),
                    );
                  }),
                );
              }),
              child: Icon(
                Icons.add,
                color: Colors.white,
                // size: Dimensions.iconSize,
              ),
            )
          : null,
    );
  }

  Widget buildTitle() {
    return TextFormField(
      autofocus: true,
      controller: titleController,
      decoration: const InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2.0, color: AppColors.mainColor),
        ),
        prefixIcon: Icon(
          Icons.person,
          color: AppColors.secondryDarkColor,
        ),
        labelText: 'Event Name',
        border: OutlineInputBorder(),
      ),
      validator: ((value) {
        if (value!.isEmpty) {
          return 'Please enter event name';
        } else
          return null;
      }),
    );
  }

  Widget buildDateTextField() {
    return TextFormField(
      keyboardType: TextInputType.datetime,
      controller: pickDateController,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2.0, color: AppColors.mainColor),
        ),
        labelText: 'Pick Date',

        suffixIcon: IconButton(
          onPressed: () async {
            DateTime? newDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2023),
            );
            if (newDate == null) return;
            setState(() {
              pickDateController.text =
                  DateFormat('dd/MM/yyyy').format(newDate);
            });
          },
          icon: Icon(Icons.date_range),
          color: AppColors.secondryDarkColor,
        ),
        // prefixIcon: Icon(
        //   Icons.timer,
        //   color: AppColors.secondryDarkColor,
        // ),
        hintText: "DD/MM/YYYY",
        border: OutlineInputBorder(),
      ),
      cursorColor: AppColors.mainColor,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please choose a date';
        }
        return null;
      },
      onSaved: (value) {
        setState(() {
          pickDateController.text = value!;
        });
      },
    );
  }

  Future<firebase_storage.UploadTask?> uploadFile(File file) async {
    if (file == null) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Unable to Upload")));
      return null;
    }

    firebase_storage.UploadTask uploadTask;

    // Create a Reference to the file
    ref = firebase_storage.FirebaseStorage.instance.ref().child('circulars/').child(
        '/${(file.path).replaceAll('/data/user/0/com.example.temple/cache/', '')}');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'circulars/pdf',
        customMetadata: {'picked-file-path': file.path});
    print("Uploading..!");

    uploadTask = ref!.putData(await file.readAsBytes(), metadata);
    print("done..!");

    return Future.value(uploadTask);
  }

  // List<String> items = [];
  // void putPdfNameInItem() {
  //   result?.items.forEach((firebase_storage.Reference ref) {
  //     items.add((ref.name).replaceAll('.pdf', ''));
  //   });
  //   print(items);
  // }

  Future openFile({required String fileName}) async {
    showLoaderDialog(context, 'Loading...');
    final file = await downloadFile(fileName);
    if (file == null) return;
    print("path:${file.path}");
    OpenFile.open(file.path);
  }

  // Future getCircularPDFlink({required String fileName}) async {
  //   return await firebase_storage.FirebaseStorage.instance
  //       .ref('circulars/$fileName')
  //       .getDownloadURL();
  // }

  Future<File?> downloadFile(String name) async {
    String url = await firebase_storage.FirebaseStorage.instance
        .ref('circulars/$name')
        .getDownloadURL();
    final appStorage = await getApplicationDocumentsDirectory();
    final file = File('${appStorage.path}/$name');
    try {
      final response = await Dio().get(url,
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              receiveTimeout: 0));
      Navigator.pop(context);
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return file;
    } catch (e) {
      print(e.toString());
      debugPrint("error" + e.toString());
      return null;
    }
  }

  Future<void> listOFPDFfromFirebase() async {
    firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('circulars')
        .listAll();

    result.items.forEach((firebase_storage.Reference ref) {
      print('Found file: ${ref.fullPath}');
    });

    result.prefixes.forEach((firebase_storage.Reference ref) {
      print('Found directory: ${ref.fullPath}');
    });
  }

  Future<void> deleteCircularData(String id, int index, String name) async {
    showLoaderDialog(context, "Deleting...");
    await firebase_storage.FirebaseStorage.instance
        .ref('circulars/$name')
        .delete();
    await FirebaseFirestore.instance.collection("Circular").doc(id).delete();
    Navigator.pop(context);
  }
}

showLoaderDialog(BuildContext context, String name) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: new Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: Dimensions.width10),
            Container(margin: EdgeInsets.only(left: 7), child: Text(name)),
          ],
        ),
      );
    },
  );
}
