//
//  Generated code. Do not modify.
//  source: fileServices.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use imageRequestDescriptor instead')
const ImageRequest$json = {
  '1': 'ImageRequest',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
  ],
};

/// Descriptor for `ImageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imageRequestDescriptor = $convert.base64Decode(
    'CgxJbWFnZVJlcXVlc3QSEgoEcGF0aBgBIAEoCVIEcGF0aA==');

@$core.Deprecated('Use imageResponseDescriptor instead')
const ImageResponse$json = {
  '1': 'ImageResponse',
  '2': [
    {'1': 'imageData', '3': 1, '4': 1, '5': 9, '10': 'imageData'},
  ],
};

/// Descriptor for `ImageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imageResponseDescriptor = $convert.base64Decode(
    'Cg1JbWFnZVJlc3BvbnNlEhwKCWltYWdlRGF0YRgBIAEoCVIJaW1hZ2VEYXRh');

@$core.Deprecated('Use uploadImageRequestDescriptor instead')
const UploadImageRequest$json = {
  '1': 'UploadImageRequest',
  '2': [
    {'1': 'fileName', '3': 1, '4': 1, '5': 9, '10': 'fileName'},
    {'1': 'imageData', '3': 2, '4': 1, '5': 9, '10': 'imageData'},
  ],
};

/// Descriptor for `UploadImageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadImageRequestDescriptor = $convert.base64Decode(
    'ChJVcGxvYWRJbWFnZVJlcXVlc3QSGgoIZmlsZU5hbWUYASABKAlSCGZpbGVOYW1lEhwKCWltYW'
    'dlRGF0YRgCIAEoCVIJaW1hZ2VEYXRh');

@$core.Deprecated('Use uploadImageResponseDescriptor instead')
const UploadImageResponse$json = {
  '1': 'UploadImageResponse',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
    {'1': 'filePath', '3': 2, '4': 1, '5': 9, '10': 'filePath'},
  ],
};

/// Descriptor for `UploadImageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadImageResponseDescriptor = $convert.base64Decode(
    'ChNVcGxvYWRJbWFnZVJlc3BvbnNlEhgKB21lc3NhZ2UYASABKAlSB21lc3NhZ2USGgoIZmlsZV'
    'BhdGgYAiABKAlSCGZpbGVQYXRo');

@$core.Deprecated('Use deleteImageResponseDescriptor instead')
const DeleteImageResponse$json = {
  '1': 'DeleteImageResponse',
  '2': [
    {'1': 'message', '3': 1, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `DeleteImageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteImageResponseDescriptor = $convert.base64Decode(
    'ChNEZWxldGVJbWFnZVJlc3BvbnNlEhgKB21lc3NhZ2UYASABKAlSB21lc3NhZ2U=');

