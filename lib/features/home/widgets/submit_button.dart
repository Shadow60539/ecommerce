import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/utils/all_provider.dart';
import 'package:ecommerce/features/home/widgets/simple_dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class SubmitButton extends StatefulWidget {
  @override
  _SubmitButtonState createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  bool isAllOptionsChosen = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final AllProvider _provider = Provider.of<AllProvider>(context);

    bool isAllOptionsChosen = (_provider.sellerImage.isNotEmpty);
    return AnimatedContainer(
      margin: const EdgeInsets.only(top: 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: isAllOptionsChosen ? Colors.black87 : Colors.transparent,
          border: Border.all(color: Colors.black12, width: 1)),
      height: 50,
      duration: const Duration(milliseconds: 200),
      child: OutlineButton(
        splashColor: Colors.white,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black87, width: 2),
            borderRadius: BorderRadius.circular(5)),
        onPressed: () {
          print(_provider.sellerImage.isNotEmpty);
          if (isLoading) {
          } else if (isAllOptionsChosen) {
            uploadImage(
                fileName: 'images',
                assets: _provider.sellerImage,
                itemName: _provider.itemName);
          }
        },
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                  strokeWidth: 1,
                ),
              )
            : Text(
                'SUBMIT',
                style: TextStyle(
                    color: isAllOptionsChosen ? Colors.white : Colors.black12),
              ),
      ),
    );
  }

  Future<void> uploadImage(
      {@required String fileName,
      @required List<Asset> assets,
      String itemName}) async {
    List<String> uploadUrls = [];
    setState(() {
      isLoading = true;
    });

    FirebaseAuth auth = FirebaseAuth.instance;

    await Future.wait(
        assets.map((Asset asset) async {
          ByteData byteData = await asset.getByteData();
          List<int> imageData = byteData.buffer.asUint8List();

          Reference reference = FirebaseStorage.instance
              .ref()
              .child('${auth.currentUser.uid}/${assets.indexOf(asset)}');
          UploadTask uploadTask = reference.putData(imageData);
          TaskSnapshot storageTaskSnapshot;

          // Release the image data
          TaskSnapshot snapshot = await uploadTask.catchError((onError) {
            print('Error from image repo ${onError.toString()}');
            throw ('This file is not an image');
          });
          storageTaskSnapshot = snapshot;
          final String downloadUrl =
              await storageTaskSnapshot.ref.getDownloadURL();

          uploadUrls.add(downloadUrl);

          print('Upload success');
        }),
        eagerError: true,
        cleanUp: (_) {
          print('eager cleaned up');
        });

    setState(() {
      isLoading = false;
    });

    showDialog(context: context, child: MySimpleDialog(isSuccess: true));

    final Directory tempDir = await getTemporaryDirectory();

    print(uploadUrls.toList());

    await FirebaseFirestore.instance.collection("items").add({
      "url": uploadUrls,
      "name": itemName,
      "sellerName": auth.currentUser.email
    });
    Provider.of<AllProvider>(context, listen: false).clearAll();
  }
}
