

This is a Dart native implementation of the Ckmeans.1d.dp clustering algorithm. The original implementation is in C++ with an R wrapper (see https://github.com/cran/Ckmeans.1d.dp/tree/master). 

Described by the original authors (below) as, "The package provides a powerful set of tools for fast, optimal, and reproducible univariate clustering by dynamic programming.".

## Features

Please see the original documentation for a description of the features: https://github.com/cran/Ckmeans.1d.dp/tree/master

Limitations:
- Only 1D data is supported.
- Only double precision is supported.
- Only integer a user-specified number of clusters is supported. The original supported a range of cluster counts.
- The original implementation also includes routines for histograms and plots of the clusters. These are not implemented here.

## Getting started

Add this package to your `pubspec.yaml` file:

```yaml
dependencies:
  cluster_ckmeans_1d_dp: ^1.0.0
```

## Usage

There is a single API function, `ckmeans`, which takes a list of double precision numbers and an integer for the cluster count and returns a `CkmeansResult` object. Please see the `/test` folder for examples. 

```dart    
test('Basic clustering k=2', () {
      final data = [1.0, 2.0, 3.0, 10.0, 11.0, 12.0];
      final result = ckmeans(data, 2);

      expect(result.clusters.length, 2);
      expect(result.clusters[0], [1.0, 2.0, 3.0]);
      expect(result.clusters[1], [10.0, 11.0, 12.0]);
      expect(result.centers[0], 2.0);
      expect(result.centers[1], 11.0);
      expect(result.sizes, [3.0, 3.0]);
      expect(
        result.withinss[0],
        2.0,
      ); // (1-2)^2 + (2-2)^2 + (3-2)^2 = 1 + 0 + 1 = 2
      expect(result.withinss[1], 2.0);
      expect(result.totalWithinss, 4.0);
    });
```

## Additional information

The original authors are:

Song M, Zhong H (2020). “Efficient weighted univariate clustering maps outstanding dysregulated genomic zones in human cancers.” Bioinformatics, 36(20), 5027–5036. https://doi.org/10.1093/bioinformatics/btaa613

Wang H, Song M (2011). “Ckmeans.1d.dp: Optimal k-means clustering in one dimension by dynamic programming.” The R Journal, 3(2), 29–33. https://doi.org/10.32614/RJ-2011-015

The original license is the LGPL-3.0 license, as is this port.
