import 'package:intl/intl.dart' as intl;
import 'named_cluster_api.dart';

/// Cluster adapter for DateTime data.
class DateTimeAdapter {
  late NamedClusterResult result;

  DateTimeAdapter(List<DateTime> data, {int clusterCount = 5}) {
    List<num> input = data.map((e) => e.millisecondsSinceEpoch).toList();
    result = clustersNamed(
      input,
      List<String>.filled(clusterCount, '', growable: true),
    );
    _updateClusterLabels(result.clusters);
  }

  void _updateClusterLabels(List<NamedCluster> clusters) {
    for (var cluster in clusters) {
      final start = DateTime.fromMillisecondsSinceEpoch(cluster.min.toInt());
      final stop = DateTime.fromMillisecondsSinceEpoch(cluster.max.toInt());
      var begin = intl.DateFormat.yMd().format(start);
      var end = intl.DateFormat.yMd().format(stop);
      if (cluster == clusters.first) {
        cluster.name = '...$end';
      } else if (cluster == clusters.last) {
        cluster.name = '$begin...';
      } else {
        cluster.name = '$begin...$end';
      }
    }
  }

  String getClusterName(DateTime dateTime) =>
      result.getClusterName(dateTime.millisecondsSinceEpoch);

  List<String> getClusterNames(List<DateTime> dates) =>
      dates.map((date) => getClusterName(date)).toList();
}
