# Changelog

## [0.2.0](https://github.com/2martens/terraform/compare/v0.1.0...v0.2.0) (2024-09-10)


### Added

* Add domain-test for testing INWX changes ([82def8f](https://github.com/2martens/terraform/commit/82def8fc67237ef9aa30bb0b579d334f1cee5236))
* Add nameserver resource ([729960b](https://github.com/2martens/terraform/commit/729960b98cfc2c6f0d1feecd3a572f030682fed4))


### Changed

* Add domain zone on nameserver ([7cf1e3a](https://github.com/2martens/terraform/commit/7cf1e3a94ce416c3c55ad0098b377e9aa3f90093))
* Remove 2martens.eu from domain test ([6ef68f4](https://github.com/2martens/terraform/commit/6ef68f47fa40608f431ca0541c9cc813c2711868))
* Use 2martens.example for domain test ([6ef68f4](https://github.com/2martens/terraform/commit/6ef68f47fa40608f431ca0541c9cc813c2711868))
* Use test instance of inwx ([8b34a7f](https://github.com/2martens/terraform/commit/8b34a7f60cc1ec701170e430d1786e3670eea2fd))


### Fixed

* Add missing records ([e2c439d](https://github.com/2martens/terraform/commit/e2c439deef10303391452f0566dde8468bff794b))
* Move whois_protection to domain ([7514828](https://github.com/2martens/terraform/commit/75148283850092fadafe87bf3aa3e33485004690))
* Remove inwx_nameserver as that breaks the apply ([47004e4](https://github.com/2martens/terraform/commit/47004e40f9ee0114dab253b4bc8363d6440dea75))
* Remove not required variables for domain test ([927eaad](https://github.com/2martens/terraform/commit/927eaad75b810051f5f6f4472461af5d859166b4))
* Remove outputs from domain-test ([1b7969b](https://github.com/2martens/terraform/commit/1b7969bada6492b1321cb4483fe210e02373720f))
* Remove SOA records and add zone for 2martens.eu ([2383874](https://github.com/2martens/terraform/commit/2383874cf6f62ec301662de956862004db67b6c5))
* Remove WHOIS protection ([2e0fa2e](https://github.com/2martens/terraform/commit/2e0fa2e095f185dd6d9052afe1e86384f5138d41))
* Removed resources for SOA and NS ([87b5436](https://github.com/2martens/terraform/commit/87b54361b4eb9d2255a1ba12e9b012f426c13a7d))
* Switch back to live system for terraform folder ([056e709](https://github.com/2martens/terraform/commit/056e709c8d85faa5fd40b992ce53b43b818d1264))
* Use 2martens.cloud ([6f45439](https://github.com/2martens/terraform/commit/6f454397a7d41cf05946e4df14b437de65291cda))
* Use correct domain for nameserver records ([9d40e26](https://github.com/2martens/terraform/commit/9d40e2699ab1d788fba5dd7d695e396fe368f146))
* Use correct NS for test ([6ef68f4](https://github.com/2martens/terraform/commit/6ef68f47fa40608f431ca0541c9cc813c2711868))
* Use correct syntax ([a96bdd9](https://github.com/2martens/terraform/commit/a96bdd979afe22618b6de567a0ad07e2281b760f))
* Use unique name for nameserver entry ([b9ee24b](https://github.com/2martens/terraform/commit/b9ee24b516d23d6b27075833d233b60241d18dd4))

## [0.1.0](https://github.com/2martens/terraform/compare/v0.0.1...v0.1.0) (2024-02-05)


### Added

* Add monitoring cluster ([4a09d2a](https://github.com/2martens/terraform/commit/4a09d2afbe1f635bc529f22cace20ffea6c56dcc))


### Fixed

* Allow hcloud as namespace ([fe0442e](https://github.com/2martens/terraform/commit/fe0442e4ba59c687db0a3662843a8afa49cf4a33))
* Allow timetable namespace for vault ([ab8ee17](https://github.com/2martens/terraform/commit/ab8ee17866f7674edde5810a25d5b4b3d06c1862))
