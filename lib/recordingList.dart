import 'package:flutter/material.dart';

class RecordingsList extends StatelessWidget {
    Widget _recording(int index) {
        final _recordingDate = DateTime.now()
                .subtract(new Duration(days: index))
        .toString();

        return new ListTile(
                trailing: const Icon(Icons.play_circle_outline),
                title: Text(_recordingDate),
    );
    }

    @override
    Widget build(BuildContext context) {
        return new ListView.builder(
                padding: new EdgeInsets.all(8.0),
                itemExtent: 20.0,
                itemBuilder: (BuildContext context, int index) {
            return _recording(index);
        },
    );
    }
}
