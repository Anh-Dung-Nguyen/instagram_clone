import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram/data/firebase_service/firestorage.dart';
import 'package:instagram/data/firebase_service/storage.dart';

class AddPostText extends StatefulWidget {
  File _file;
  AddPostText(this._file, {super.key});

  @override
  State<AddPostText> createState() => _AddPostTextState();
}

class _AddPostTextState extends State<AddPostText> {
  final caption = TextEditingController();
  final location = TextEditingController();
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'New post',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: false,
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    isloading = true;
                  });
                  String post_url = await StorageMethod().uploadImageToStorage('post', widget._file);
                  await Firebase_Firestorage().CreatePost(postImage: post_url, caption: caption.text, location: location.text);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Share',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15.sp
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: isloading 
        ? Center(child: CircularProgressIndicator(color: Colors.black,)) 
        : Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                child: Row(
                  children: [
                    Container(
                      width: 65.w,
                      height: 65.h,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        image: DecorationImage(
                          image: FileImage(widget._file),
                          fit: BoxFit.cover,
                        )
                      ),
                    ),
                    SizedBox(width: 10.w),
                    SizedBox(
                      width: 280.w,
                      height: 60.h,
                      child: TextField(
                        controller: caption,
                        decoration: const InputDecoration(
                          hintText: 'Write a caption ...',
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: SizedBox(
                  width: 280.w,
                  height: 30.h,
                  child: TextField(
                    controller: location,
                    decoration: const InputDecoration(
                      hintText: 'Add location',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}