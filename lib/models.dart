import 'package:cloud_firestore/cloud_firestore.dart';

class Pet {
  Pet({this.name, this.avatarUrl, this.reference});

  final DocumentReference reference;
  final String name;
  final String avatarUrl;

  Map<String, Object> toMap() {
    return {'name': name, 'avatar_url': avatarUrl};
  }

  Pet.fromMap(Map<String, dynamic> map, DocumentReference ref)
      : assert(map['name'] != null),
        assert(map['avatar_url'] != null),
        name = map['name'],
        avatarUrl = map['avatar_url'],
        reference = ref;

  Pet.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, snapshot.reference);

  @override
  String toString() {
    return 'Pet{reference: $reference, name: $name, avatarUrl: $avatarUrl}';
  }


}
