# Changelog

## [0.4.0](https://github.com/streamnative/terraform-google-cloud/compare/v0.3.5...v0.4.0) (2024-06-07)


### Features

* Add KMS key creation functionality for GKE encryption ([#42](https://github.com/streamnative/terraform-google-cloud/issues/42)) ([f761562](https://github.com/streamnative/terraform-google-cloud/commit/f761562549f9e1b72fc02684f7feba7ff9d0b84c))
* Enable VPA ([#35](https://github.com/streamnative/terraform-google-cloud/issues/35)) ([4366446](https://github.com/streamnative/terraform-google-cloud/commit/4366446a21f3c0fbb17f72c4967e46be30b2e0ec))
* Upgrade terraform-google-kubernetes-engine module to 29.0.0 ([#34](https://github.com/streamnative/terraform-google-cloud/issues/34)) ([411d32d](https://github.com/streamnative/terraform-google-cloud/commit/411d32d2a36e7720354714d2113caf2d78ba6090))


### Bug Fixes

* Add KMS IAM binding ([#45](https://github.com/streamnative/terraform-google-cloud/issues/45)) ([ce695f1](https://github.com/streamnative/terraform-google-cloud/commit/ce695f17e04190504f2a3b9c08834173e73e720c))
* Add KMS Uniqueness ([#51](https://github.com/streamnative/terraform-google-cloud/issues/51)) ([39e9bc3](https://github.com/streamnative/terraform-google-cloud/commit/39e9bc34bbdb4409be5a8ee1fb30443f3b44ef3a))
* copyrigh in license header ([#22](https://github.com/streamnative/terraform-google-cloud/issues/22)) ([d9afb6b](https://github.com/streamnative/terraform-google-cloud/commit/d9afb6b8fc4ec6846267d5df721023fcd36f9fce))
* Expose deletion_protection ([#46](https://github.com/streamnative/terraform-google-cloud/issues/46)) ([5052bdb](https://github.com/streamnative/terraform-google-cloud/commit/5052bdb9ca9a91af6cdb2e16c9e0a9ef60be38c0))
* Expose nodepool zones ([#49](https://github.com/streamnative/terraform-google-cloud/issues/49)) ([54891a8](https://github.com/streamnative/terraform-google-cloud/commit/54891a8c09a51b35017f639ac1a230411a43eae0))
* handle empty suffix ([#15](https://github.com/streamnative/terraform-google-cloud/issues/15)) ([3f65f8b](https://github.com/streamnative/terraform-google-cloud/commit/3f65f8bb57e31124e9d19eccc513494aacad5e5c))
* Revert "feat: Enable VPA ([#35](https://github.com/streamnative/terraform-google-cloud/issues/35))" ([#38](https://github.com/streamnative/terraform-google-cloud/issues/38)) ([9ff9445](https://github.com/streamnative/terraform-google-cloud/commit/9ff9445251deb04b2bd92bf829b5ca72cd4acf59))
* set versions range rather than exact ([#18](https://github.com/streamnative/terraform-google-cloud/issues/18)) ([8e69597](https://github.com/streamnative/terraform-google-cloud/commit/8e69597c19a577253c22f21aa991fa5ccd46380e))
* Updated resource name to use underscores. ([#43](https://github.com/streamnative/terraform-google-cloud/issues/43)) ([a02bba3](https://github.com/streamnative/terraform-google-cloud/commit/a02bba3b9522d554f7f611169980df124bdb41dc))
* upgrade default version of external-dns chart to 6.15.0 ([#16](https://github.com/streamnative/terraform-google-cloud/issues/16)) ([ec55878](https://github.com/streamnative/terraform-google-cloud/commit/ec558786303ac6bccca449114c355847bbf3f897))
* upgrade to latest external-dns helm chart ([ec55878](https://github.com/streamnative/terraform-google-cloud/commit/ec558786303ac6bccca449114c355847bbf3f897))
* V2 merge ([#32](https://github.com/streamnative/terraform-google-cloud/issues/32)) ([d873ead](https://github.com/streamnative/terraform-google-cloud/commit/d873ead75d6b85c501003ee02f40408cb9ed8418))

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
