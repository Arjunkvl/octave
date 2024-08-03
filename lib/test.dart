import 'package:flutter/material.dart';
import 'package:marshal/data/repository/song_repo_impl.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          SongRepoImpl().getNewReleseas();
        },
        child: Center(
          child: Container(
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
