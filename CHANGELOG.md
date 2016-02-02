## Ghangelog

> This file is written in reverse chronological order, newer releases will appear at the top.

## 1.0.0

- Refactoring of the Gem and integration tests
  [#7](https://github.com/mdouchement/swift-server/pull/7)
  @mdouchement

- Multipart uploads and copies support (aka Swift's Manifest file for large file support)
  [#6](https://github.com/mdouchement/swift-server/pull/6)
  @ArmandPredicSis

- List of objects can be filtered with a prefix
  [5](https://github.com/mdouchement/swift-server/pull/5)
  @mdouchement

- Authentication credentials can be changed with environment variables
  [#4](https://github.com/mdouchement/swift-server/pull/4)
  @mdouchement

- Fix `Content-Type` of uploaded file
  [#3](https://github.com/mdouchement/swift-server/pull/3)
  @mdouchement

- Add `copy` HTTP verb support
  [#1](https://github.com/mdouchement/swift-server/pull/1)
  [#2](https://github.com/mdouchement/swift-server/pull/2)
  @ArmandPredicSis

- Initial commit
  @mdouchement
 - Authentication (Keystone v1 & v2)
 - Container's interactions (linsting, creation, deletion, etc.)
 - Object's interactions (linsting, creation, copy, deletion, etc.)
