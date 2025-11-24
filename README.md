

This is a Dart native implementation of the Ckmeans.1d.dp clustering algorithm. The original implementation is in C++ with an R wrapper (see https://github.com/cran/Ckmeans.1d.dp/tree/master). 

Described by the original authors (listed below) as, "The package provides a powerful set of tools for fast, optimal, and reproducible univariate clustering by dynamic programming.".

Google Gemini generated the Dart code from the C++ code. 

## Features

Please see the original documentation for a description of the features: https://github.com/cran/Ckmeans.1d.dp/tree/master

The original implementation only supported List<double> as input. This implementation supports List<num>. Objects that are not <num> but which can be represented by <num> can be clustered by using a custom adapter. An example is provided for List<DateTime>, see DateTimeAdapter.

Limitations:
- Only 1D data is supported.
- The user must specify the number of clusters. The original supported a range of cluster counts.
- The original implementation also includes routines for histograms and plots of the clusters. These are not implemented here so that the library can be used in headless and web environments.

## Getting started

Add this package to your `pubspec.yaml` file:

```yaml
dependencies:
  cluster_ckmeans_1d_dp: ^1.0.0
```

## Usage

Use the API function, `findClusters(List<num> data, int clusterCount)`, which returns a `ClusterResult` object. Please see `/test/cluster_api.test` for examples. 

```dart    
    
    test('Basic clustering k=2', () {
      final data = [1.0, 2.0, 3.0, 10.0, 11.0, 12.0];
      final result = findClusters(data, 2);
      expect(result.clusters.length, 2);
      var firstCluster = result.clusters.first;
      expect(firstCluster.values, [1.0, 2.0, 3.0]);
      expect(firstCluster.mean, 2.0);
      expect(firstCluster.elementCount, 3.0);
      expect(firstCluster.sumOfSquares, 2.0);
    });
```
The 'findClusters' function is a wrapper around the traditional 'ckmeans' function which remains available for use. 'findClusters' is a less cryptic and more object-oriented facade for the original function.

Sometimes it is useful to have named clusters. For this purpose, the 'clustersNamed(List<num> input, List<String> clusterNames)' function is provided. Please see `/test/named_cluster_api.test` for examples. 

```dart    
    
    test('Basic clustering k=2', () {
      final data = [1.0, 2.0, 3.0, 10.0, 11.0, 12.0];
      final result = clustersNamed(data, ['A', 'B']);
      expect(result.clusters.length, 2);
    });
```

If you need a comprehensive statistical profile of the data , try the `StatisticalProfiler` class. It calculates commonly used statistical features, including clusters, with minimum traversal of the data. Please see `/test/statistical_profiler.test` for examples. 

```dart
    
  StatisticalProfiler(
    this.data, {
    List<String>? clusterLabels,
    this.bestValues = BestValues.unknown,
    ClusterCount clusterCount = ClusterCount.five,
  })
```

## Additional information

The original authors are:

Song M, Zhong H (2020). “Efficient weighted univariate clustering maps outstanding dysregulated genomic zones in human cancers.” Bioinformatics, 36(20), 5027–5036. https://doi.org/10.1093/bioinformatics/btaa613

Wang H, Song M (2011). “Ckmeans.1d.dp: Optimal k-means clustering in one dimension by dynamic programming.” The R Journal, 3(2), 29–33. https://doi.org/10.32614/RJ-2011-015

The original license is LGPL-3.0, as is this port.
