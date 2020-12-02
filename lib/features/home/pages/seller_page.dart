import 'dart:io';
import 'dart:math';

import 'package:ecommerce/core/utils/all_provider.dart';
import 'package:ecommerce/features/home/widgets/submit_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class SellerPage extends StatefulWidget {
  @override
  _SellerPageState createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
  List<Asset> _images = List<Asset>();
  List<Widget> listItems = <Widget>[];

  @override
  Widget build(BuildContext context) {
    final _sHeight = MediaQuery.of(context).size.height;
    final _sWidth = MediaQuery.of(context).size.width;

    Widget buildGridView() {
      if (_images.isEmpty)
        return Container();
      else
        return GridView.count(
          physics: BouncingScrollPhysics(),
          crossAxisCount: 1,
          children: List.generate(_images?.length, (index) {
            Asset asset = _images[index];
            return AssetThumb(
              asset: asset,
              width: _sWidth.toInt(),
              height: (_sHeight * 0.8).toInt(),
            );
          }),
        );
    }

    Future<void> loadAssets() async {
      List<Asset> resultList = List<Asset>();
      String error = 'No Error Dectected';

      try {
        resultList = await MultiImagePicker.pickImages(
          maxImages: 3,
          enableCamera: true,
          selectedAssets: _images,
          cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
          materialOptions: MaterialOptions(
            actionBarColor: "#abcdef",
            actionBarTitle: "Example App",
            allViewTitle: "All Photos",
            useDetailsView: false,
            selectCircleStrokeColor: "#000000",
          ),
        );
      } on Exception catch (e) {
        error = e.toString();
      }
      if (!mounted) return;

      setState(() {
        _images = resultList;
        Provider.of<AllProvider>(context, listen: false)
            .updateSellerImage(_images);

        // _error = error;
      });
    }

    Widget imageHeader() {
      return AnimatedCrossFade(
          firstChild: InkWell(
            onTap: loadAssets,
            child: _images.isNotEmpty
                ? Container()
                : Center(
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo,
                        color: Colors.grey,
                        size: 14,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Upload Image',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  )),
          ),
          secondChild: LimitedBox(maxHeight: 100, child: buildGridView()),
          crossFadeState: _images.isEmpty
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(seconds: 1));
    }

    return WillPopScope(
      onWillPop: () async {
        Provider.of<AllProvider>(context, listen: false).clearAll();

        return false;
      },
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            // Provider.of<AllProvider>(context, listen: false).hideInfluencerCode();
          },
          child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.black87,
                title: Text(
                  'Add Item',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              body: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    elevation: 1,
                    backgroundColor: Colors.white,
                    automaticallyImplyLeading: false,
                    stretch: true,
                    expandedHeight: (_sHeight * 0.5) - _images.length,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: _images.isNotEmpty
                          ? Container(
                              height: 30,
                              child: RaisedButton(
                                color: Colors.white,
                                child: Text(
                                  'Select another',
                                  style: TextStyle(fontSize: 10),
                                ),
                                onPressed: loadAssets,
                              ),
                            )
                          : null,
                      background: imageHeader(),
                      stretchModes: [
                        StretchMode.zoomBackground,
                        StretchMode.blurBackground
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        shrinkWrap: true,
                        children: [
                          SizedBox(
                            height: 50,
                            child: TextField(
                              onChanged: (value) {
                                Provider.of<AllProvider>(context, listen: false)
                                    .updateItemName(value);
                              },
                              decoration: InputDecoration(
                                filled: true,
                                labelText: 'Item Name',
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: _sHeight * 0.5 -
                                210 -
                                kBottomNavigationBarHeight,
                          ),
                          SubmitButton(),
                        ],
                      )
                    ]),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
