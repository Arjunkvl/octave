import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marshal/data/models/song_model.dart';

DocumentSnapshot? lastDoc;
List<Song> songs = [];
