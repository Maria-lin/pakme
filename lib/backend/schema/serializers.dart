import 'package:built_value/standard_json_plugin.dart';

import 'users_record.dart';
import 'product_name_record.dart';
import 'payments_record.dart';

import 'index.dart';

export 'index.dart';

part 'serializers.g.dart';

const kDocumentReferenceField = 'Document__Reference__Field';

@SerializersFor(const [
  UsersRecord,
  ProductNameRecord,
  PaymentsRecord,
])
final Serializers serializers = (_$serializers.toBuilder()
      ..add(DocumentReferenceSerializer())
      ..add(DateTimeSerializer())
      ..add(LatLngSerializer())
      ..addPlugin(StandardJsonPlugin()))
    .build();

extension SerializerExtensions on Serializers {
  Map<String, dynamic> toFirestore<T>(Serializer<T> serializer, T object) {
    final serializedObject = serializeWith(serializer, object);

    if (serializedObject == null) {
      // Gérez le cas où la sérialisation a échoué ou où l'objet est nul.
      // Vous pouvez renvoyer une valeur par défaut ou générer une erreur selon vos besoins.
      // Par exemple :
      throw Exception('La sérialisation a échoué ou l\'objet est nul.');
    }

    if (serializedObject is! Map<String, dynamic>) {
      // Gérez le cas où la sérialisation a renvoyé un type incorrect.
      // Vous pouvez renvoyer une valeur par défaut ou générer une erreur selon vos besoins.
      // Par exemple :
      throw Exception('La sérialisation a renvoyé un type incorrect.');
    }

    return mapToFirestore(serializedObject);
  }
}

class DocumentReferenceSerializer
    implements PrimitiveSerializer<DocumentReference> {
  final bool structured = false;
  @override
  final Iterable<Type> types = new BuiltList<Type>([DocumentReference]);
  @override
  final String wireName = 'DocumentReference';

  @override
  Object serialize(Serializers serializers, DocumentReference reference,
      {FullType specifiedType=FullType.unspecified}) {
    return reference;
  }

  @override
  DocumentReference deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType= FullType.unspecified}) =>
      serialized as DocumentReference;
}

class DateTimeSerializer implements PrimitiveSerializer<DateTime> {
  @override
  final Iterable<Type> types = new BuiltList<Type>([DateTime]);
  @override
  final String wireName = 'DateTime';

  @override
  Object serialize(Serializers serializers, DateTime dateTime,
      {FullType specifiedType= FullType.unspecified}) {
    return dateTime;
  }

  @override
  DateTime deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType= FullType.unspecified}) =>
      serialized as DateTime;
}

class LatLngSerializer implements PrimitiveSerializer<LatLng> {
  final bool structured = false;
  @override
  final Iterable<Type> types = new BuiltList<Type>([LatLng]);
  @override
  final String wireName = 'LatLng';

  @override
  Object serialize(Serializers serializers, LatLng location,
      {FullType specifiedType=FullType.unspecified}) {
    return location;
  }

  @override
  LatLng deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType= FullType.unspecified}) =>
      serialized as LatLng;
}

Map<String, dynamic> serializedData(DocumentSnapshot doc) {
  final data = doc.data();
  if (data == null) {
    // Gérez le cas où les données sont nulles.
    // Vous pouvez renvoyer une valeur par défaut ou générer une erreur selon vos besoins.
    // Par exemple :
    throw Exception('Les données du document sont nulles.');
  }

  if (data is! Map<String, dynamic>) {
    // Gérez le cas où les données ne sont pas du bon type.
    // Vous pouvez renvoyer une valeur par défaut ou générer une erreur selon vos besoins.
    // Par exemple :
    throw Exception('Les données du document ne sont pas du bon type.');
  }

  return {...mapFromFirestore(data), kDocumentReferenceField: doc.reference};
}


Map<String, dynamic> mapFromFirestore(Map<String, dynamic> data) =>
    data.map((key, value) {
      if (value is Timestamp) {
        value = (value as Timestamp).toDate();
      }
      if (value is GeoPoint) {
        value = (value as GeoPoint).toLatLng();
      }
      return MapEntry(key, value);
    });

Map<String, dynamic> mapToFirestore(Map<String, dynamic> data) =>
    data.map((key, value) {
      if (value is LatLng) {
        value = (value as LatLng).toGeoPoint();
      }
      return MapEntry(key, value);
    });

extension GeoPointExtension on LatLng {
  GeoPoint toGeoPoint() => GeoPoint(latitude, longitude);
}

extension LatLngExtension on GeoPoint {
  LatLng toLatLng() => LatLng(latitude, longitude);
}

DocumentReference toRef(String ref) => FirebaseFirestore.instance.doc(ref);

T? safeGet<T>(T Function() func, [Function(dynamic)? reportError]) {
  try {
    return func();
  } catch (e) {
    reportError?.call(e);
  }
  return null;
}
