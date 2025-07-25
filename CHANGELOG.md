# Changelog

## [0.8.0](https://github.com/streamnative/terraform-google-cloud/compare/v0.7.0...v0.8.0) (2025-07-24)


### Features

* Support loki bucket creation ([#70](https://github.com/streamnative/terraform-google-cloud/issues/70)) ([e3de376](https://github.com/streamnative/terraform-google-cloud/commit/e3de3763a801a77d68bf3ef54a18b90744cbfb61))

## [0.7.0](https://github.com/streamnative/terraform-google-cloud/compare/v0.6.0...v0.7.0) (2025-04-02)


### Features

* Upgrade submodules to use google provider 6.x ([#68](https://github.com/streamnative/terraform-google-cloud/issues/68)) ([1eae90d](https://github.com/streamnative/terraform-google-cloud/commit/1eae90d55120c99256aa0cceba486eec33d36399))

## [0.6.0](https://github.com/streamnative/terraform-google-cloud/compare/v0.5.2...v0.6.0) (2025-03-30)


### Features

* Expose GKE l4 subsetting option ([#66](https://github.com/streamnative/terraform-google-cloud/issues/66)) ([b1d88fd](https://github.com/streamnative/terraform-google-cloud/commit/b1d88fdb0bfe3dda6ab8a6ce0a5f5bee190cbebd))

## [0.5.2](https://github.com/streamnative/terraform-google-cloud/compare/v0.5.1...v0.5.2) (2025-01-16)


### Bug Fixes

* Unset gcp_public_cidrs_access_enabled in default case ([#64](https://github.com/streamnative/terraform-google-cloud/issues/64)) ([6f287b8](https://github.com/streamnative/terraform-google-cloud/commit/6f287b86299f52e83e226499622fd890de19955e))

## [0.5.1](https://github.com/streamnative/terraform-google-cloud/compare/v0.5.0...v0.5.1) (2025-01-16)


### Bug Fixes

* Disable gcp_public_cidrs_access_enabled by default ([#62](https://github.com/streamnative/terraform-google-cloud/issues/62)) ([a772102](https://github.com/streamnative/terraform-google-cloud/commit/a772102b1b888c8cf557bd667291e47bfc0dbde1))

## [0.5.0](https://github.com/streamnative/terraform-google-cloud/compare/v0.4.0...v0.5.0) (2024-12-13)


### Features

* add dns bucket submodule ([#59](https://github.com/streamnative/terraform-google-cloud/issues/59)) ([5437cf5](https://github.com/streamnative/terraform-google-cloud/commit/5437cf555c61c44b29787ec988a90f292ac721f2))
* add vpc submodule ([#58](https://github.com/streamnative/terraform-google-cloud/issues/58)) ([4934c8c](https://github.com/streamnative/terraform-google-cloud/commit/4934c8ce040bc811fce8fe25e9f60d0ef05ca172))

## [0.4.0](https://github.com/streamnative/terraform-google-cloud/compare/v0.3.5...v0.4.0) (2024-12-05)


### Features

* Support private nodes on public GKE ([#57](https://github.com/streamnative/terraform-google-cloud/issues/57)) ([beff464](https://github.com/streamnative/terraform-google-cloud/commit/beff464bad392bc444642a5ba76d7d9c0c355f2b))

## [0.3.5](https://github.com/streamnative/terraform-google-cloud/compare/v0.3.4...v0.3.5) (2024-06-07)


### Bug Fixes

* Add KMS Uniqueness ([#51](https://github.com/streamnative/terraform-google-cloud/issues/51)) ([39e9bc3](https://github.com/streamnative/terraform-google-cloud/commit/39e9bc34bbdb4409be5a8ee1fb30443f3b44ef3a))
* * Add KMS Keyring Uniqueness ([#53](https://github.com/streamnative/terraform-google-cloud/issues/51)) ([39e9bc3](https://github.com/streamnative/terraform-google-cloud/commit/398a40e27e4cceea522a96ed817ea4ac8a259e8c))

## [0.3.4](https://github.com/streamnative/terraform-google-cloud/compare/v0.3.3...v0.3.4) (2024-05-21)


### Bug Fixes

* Expose nodepool zones ([#49](https://github.com/streamnative/terraform-google-cloud/issues/49)) ([54891a8](https://github.com/streamnative/terraform-google-cloud/commit/54891a8c09a51b35017f639ac1a230411a43eae0))

## [0.3.3](https://github.com/streamnative/terraform-google-cloud/compare/v0.3.2...v0.3.3) (2024-05-13)


### Bug Fixes

* Add KMS IAM binding ([#45](https://github.com/streamnative/terraform-google-cloud/issues/45)) ([ce695f1](https://github.com/streamnative/terraform-google-cloud/commit/ce695f17e04190504f2a3b9c08834173e73e720c))

## [0.3.2](https://github.com/streamnative/terraform-google-cloud/compare/v0.3.1...v0.3.2) (2024-05-13)


### Bug Fixes

* Expose deletion_protection ([#46](https://github.com/streamnative/terraform-google-cloud/issues/46)) ([5052bdb](https://github.com/streamnative/terraform-google-cloud/commit/5052bdb9ca9a91af6cdb2e16c9e0a9ef60be38c0))

## [0.3.1](https://github.com/streamnative/terraform-google-cloud/compare/v0.3.0...v0.3.1) (2024-05-09)


### Bug Fixes

* Updated resource name to use underscores. ([#43](https://github.com/streamnative/terraform-google-cloud/issues/43)) ([a02bba3](https://github.com/streamnative/terraform-google-cloud/commit/a02bba3b9522d554f7f611169980df124bdb41dc))

## [0.3.0](https://github.com/streamnative/terraform-google-cloud/compare/v0.2.1...v0.3.0) (2024-05-03)


### Features

* Add KMS key creation functionality for GKE encryption ([#42](https://github.com/streamnative/terraform-google-cloud/issues/42)) ([f761562](https://github.com/streamnative/terraform-google-cloud/commit/f761562549f9e1b72fc02684f7feba7ff9d0b84c))
* Upgrade terraform-google-kubernetes-engine module to 29.0.0 ([#34](https://github.com/streamnative/terraform-google-cloud/issues/34)) ([411d32d](https://github.com/streamnative/terraform-google-cloud/commit/411d32d2a36e7720354714d2113caf2d78ba6090))

## [0.2.1](https://github.com/streamnative/terraform-google-cloud/compare/v0.2.0...v0.2.1) (2024-04-15)


### Bug Fixes

* Revert "feat: Enable VPA ([#35](https://github.com/streamnative/terraform-google-cloud/issues/35))" ([#38](https://github.com/streamnative/terraform-google-cloud/issues/38)) ([9ff9445](https://github.com/streamnative/terraform-google-cloud/commit/9ff9445251deb04b2bd92bf829b5ca72cd4acf59))

## [0.2.0](https://github.com/streamnative/terraform-google-cloud/compare/v0.1.1...v0.2.0) (2024-03-28)


### Features

* Enable VPA ([#35](https://github.com/streamnative/terraform-google-cloud/issues/35)) ([4366446](https://github.com/streamnative/terraform-google-cloud/commit/4366446a21f3c0fbb17f72c4967e46be30b2e0ec))


### Bug Fixes

* V2 merge ([#32](https://github.com/streamnative/terraform-google-cloud/issues/32)) ([d873ead](https://github.com/streamnative/terraform-google-cloud/commit/d873ead75d6b85c501003ee02f40408cb9ed8418))
