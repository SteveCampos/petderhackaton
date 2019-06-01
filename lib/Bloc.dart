import 'package:cloud_firestore/cloud_firestore.dart';
import 'FireApi.dart';
import 'models.dart';

class Bloc extends BaseBloc {
  Bloc(FireApi api) : super(api);

  Stream<List<Pet>> getAllPets() => api.getAllPets();
}

final Bloc bloc = Bloc(new FireApi(Firestore.instance));

class BaseBloc {
  final FireApi api;

  BaseBloc(this.api);
}
