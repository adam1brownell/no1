// lib/models/dataset_entry.dart

class DatasetEntry {
  int? id;
  Map<String, dynamic> data;

  DatasetEntry({this.id, required this.data});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>.from(data);
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory DatasetEntry.fromMap(Map<String, dynamic> map) {
    int? id = map['id'];
    map.remove('id');
    return DatasetEntry(id: id, data: map);
  }
}
