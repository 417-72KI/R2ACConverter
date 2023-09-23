# AssetCatalogConverter
[![Actions Status](https://github.com/417-72KI/AssetCatalogConverter/workflows/Test/badge.svg)](https://github.com/417-72KI/AssetCatalogConverter/actions)
[![GitHub release](https://img.shields.io/github/release/417-72KI/AssetCatalogConverter/all.svg)](https://github.com/417-72KI/AssetCatalogConverter/releases)
[![SwiftPM Compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://swift.org/package-manager)
[![Platform](https://img.shields.io/badge/Platforms-macOS%7CLinux-blue.svg)](https://github.com/417-72KI/AssetCatalogConverter)
[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/417-72KI/AssetCatalogConverter/master/LICENSE)

A simple converter from R.swift to Asset Catalog for Xcode 15

## Example
### R.image
| before | after |
| --- | --- |
| `R.image.foo()` | `UIImage(resource: .foo)` |
| `R.image.bar()!` | `UIImage(resource: .bar)` |
| `UIImage(resource: R.image.baz)` | `UIImage(resource: .baz)` |
| `Image(R.image.qux)` | `Image(.qux)` |
| `Image(uiImage: R.image.quux()!)` | `Image(.quux)` |
| `Image(uiImage: UIImage(resource: R.image.corge)!)` | `Image(.corge)` |
### R.color
| before | after |
| --- | --- |
| `R.color.foo()` | `UIColor(resource: .foo)` |
| `R.color.bar()!` | `UIColor(resource: .bar)` |
| `UIColor(resource: R.color.baz)` | `UIColor(resource: .baz)` |
| `Color(R.color.qux)` | `Color(.qux)` |
| `Color(uiColor: R.color.quux()!)` | `Color(.quux)` |
| `Color(uiColor: UIColor(resource: R.color.corge)!)` | `Color(.corge)` |

## Requirement
- macOS 13+
- Xcode 15+
- Swift 5.9+

## Installation
### Mint

```sh
mint install 417-72KI/AssetCatalogConverter
```

### Homebrew

```sh
brew install 417-72KI/tap/asset-catalog-converter
```

## Usage
```sh
$ asset-catalog-converter /path/to/project
```
