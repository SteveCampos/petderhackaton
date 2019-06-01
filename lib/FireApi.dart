import 'package:cloud_firestore/cloud_firestore.dart';
import 'models.dart';

class FireApi {
  final String _COLLECTION_PETS = 'pets';
  Firestore _firestore;

  FireApi(this._firestore);

  Stream<List<Pet>> getAllPets() async* {
    var querySnap = _firestore.collection(_COLLECTION_PETS).snapshots();
    await for (QuerySnapshot snapshot in querySnap) {
      List<DocumentSnapshot> documents = snapshot.documents;
      List<Pet> pets = documents.map((d) => Pet.fromSnapshot(d)).toList();
      yield pets;
    }
  }
}
