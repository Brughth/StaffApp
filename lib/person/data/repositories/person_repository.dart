import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:staff_app/shared/utils/const.dart';

class PersonRepository {
  CollectionReference people =
      FirebaseFirestore.instance.collection(peopleCollection);

  Future<DocumentReference<Object?>> addPerson({
    required Map<String, dynamic> data,
  }) async {
    data["createdAt"] = DateTime.now().toUtc().toIso8601String();
    return await people.add(data);
  }

  updatePerson({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    data["updateAt"] = DateTime.now().toUtc().toIso8601String();
    return await people.doc(id).set(data, SetOptions(merge: true));
  }

  deletePerson(String id) {
    people.doc(id).delete();
  }

  Future<String> uploadFileToFireStorage(MemoryImage file) async {
    var ref = FirebaseStorage.instance
        .ref()
        .child("$peopleCollection/${file.hashCode}");
    TaskSnapshot uploadedFile = await ref.putData(file.bytes);
    return await uploadedFile.ref.getDownloadURL();
  }
}
