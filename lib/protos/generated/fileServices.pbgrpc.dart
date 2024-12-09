//
//  Generated code. Do not modify.
//  source: fileServices.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'fileServices.pb.dart' as $0;

export 'fileServices.pb.dart';

@$pb.GrpcServiceName('fileServices.ProfileImageService')
class ProfileImageServiceClient extends $grpc.Client {
  static final _$downloadProfileImage = $grpc.ClientMethod<$0.ImageRequest, $0.ImageResponse>(
      '/fileServices.ProfileImageService/downloadProfileImage',
      ($0.ImageRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ImageResponse.fromBuffer(value));
  static final _$uploadProfileImage = $grpc.ClientMethod<$0.UploadImageRequest, $0.UploadImageResponse>(
      '/fileServices.ProfileImageService/uploadProfileImage',
      ($0.UploadImageRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.UploadImageResponse.fromBuffer(value));
  static final _$deleteProfileImage = $grpc.ClientMethod<$0.ImageRequest, $0.DeleteImageResponse>(
      '/fileServices.ProfileImageService/deleteProfileImage',
      ($0.ImageRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.DeleteImageResponse.fromBuffer(value));

  ProfileImageServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.ImageResponse> downloadProfileImage($0.ImageRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$downloadProfileImage, request, options: options);
  }

  $grpc.ResponseFuture<$0.UploadImageResponse> uploadProfileImage($0.UploadImageRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$uploadProfileImage, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeleteImageResponse> deleteProfileImage($0.ImageRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteProfileImage, request, options: options);
  }
}

@$pb.GrpcServiceName('fileServices.ProfileImageService')
abstract class ProfileImageServiceBase extends $grpc.Service {
  $core.String get $name => 'fileServices.ProfileImageService';

  ProfileImageServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ImageRequest, $0.ImageResponse>(
        'downloadProfileImage',
        downloadProfileImage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ImageRequest.fromBuffer(value),
        ($0.ImageResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UploadImageRequest, $0.UploadImageResponse>(
        'uploadProfileImage',
        uploadProfileImage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UploadImageRequest.fromBuffer(value),
        ($0.UploadImageResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ImageRequest, $0.DeleteImageResponse>(
        'deleteProfileImage',
        deleteProfileImage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ImageRequest.fromBuffer(value),
        ($0.DeleteImageResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ImageResponse> downloadProfileImage_Pre($grpc.ServiceCall call, $async.Future<$0.ImageRequest> request) async {
    return downloadProfileImage(call, await request);
  }

  $async.Future<$0.UploadImageResponse> uploadProfileImage_Pre($grpc.ServiceCall call, $async.Future<$0.UploadImageRequest> request) async {
    return uploadProfileImage(call, await request);
  }

  $async.Future<$0.DeleteImageResponse> deleteProfileImage_Pre($grpc.ServiceCall call, $async.Future<$0.ImageRequest> request) async {
    return deleteProfileImage(call, await request);
  }

  $async.Future<$0.ImageResponse> downloadProfileImage($grpc.ServiceCall call, $0.ImageRequest request);
  $async.Future<$0.UploadImageResponse> uploadProfileImage($grpc.ServiceCall call, $0.UploadImageRequest request);
  $async.Future<$0.DeleteImageResponse> deleteProfileImage($grpc.ServiceCall call, $0.ImageRequest request);
}
@$pb.GrpcServiceName('fileServices.CoverImageService')
class CoverImageServiceClient extends $grpc.Client {
  static final _$downloadCoverImage = $grpc.ClientMethod<$0.ImageRequest, $0.ImageResponse>(
      '/fileServices.CoverImageService/downloadCoverImage',
      ($0.ImageRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ImageResponse.fromBuffer(value));
  static final _$uploadCoverImage = $grpc.ClientMethod<$0.UploadImageRequest, $0.UploadImageResponse>(
      '/fileServices.CoverImageService/uploadCoverImage',
      ($0.UploadImageRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.UploadImageResponse.fromBuffer(value));
  static final _$deleteCoverImage = $grpc.ClientMethod<$0.ImageRequest, $0.DeleteImageResponse>(
      '/fileServices.CoverImageService/deleteCoverImage',
      ($0.ImageRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.DeleteImageResponse.fromBuffer(value));

  CoverImageServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.ImageResponse> downloadCoverImage($0.ImageRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$downloadCoverImage, request, options: options);
  }

  $grpc.ResponseFuture<$0.UploadImageResponse> uploadCoverImage($0.UploadImageRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$uploadCoverImage, request, options: options);
  }

  $grpc.ResponseFuture<$0.DeleteImageResponse> deleteCoverImage($0.ImageRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteCoverImage, request, options: options);
  }
}

@$pb.GrpcServiceName('fileServices.CoverImageService')
abstract class CoverImageServiceBase extends $grpc.Service {
  $core.String get $name => 'fileServices.CoverImageService';

  CoverImageServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ImageRequest, $0.ImageResponse>(
        'downloadCoverImage',
        downloadCoverImage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ImageRequest.fromBuffer(value),
        ($0.ImageResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UploadImageRequest, $0.UploadImageResponse>(
        'uploadCoverImage',
        uploadCoverImage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UploadImageRequest.fromBuffer(value),
        ($0.UploadImageResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ImageRequest, $0.DeleteImageResponse>(
        'deleteCoverImage',
        deleteCoverImage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ImageRequest.fromBuffer(value),
        ($0.DeleteImageResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ImageResponse> downloadCoverImage_Pre($grpc.ServiceCall call, $async.Future<$0.ImageRequest> request) async {
    return downloadCoverImage(call, await request);
  }

  $async.Future<$0.UploadImageResponse> uploadCoverImage_Pre($grpc.ServiceCall call, $async.Future<$0.UploadImageRequest> request) async {
    return uploadCoverImage(call, await request);
  }

  $async.Future<$0.DeleteImageResponse> deleteCoverImage_Pre($grpc.ServiceCall call, $async.Future<$0.ImageRequest> request) async {
    return deleteCoverImage(call, await request);
  }

  $async.Future<$0.ImageResponse> downloadCoverImage($grpc.ServiceCall call, $0.ImageRequest request);
  $async.Future<$0.UploadImageResponse> uploadCoverImage($grpc.ServiceCall call, $0.UploadImageRequest request);
  $async.Future<$0.DeleteImageResponse> deleteCoverImage($grpc.ServiceCall call, $0.ImageRequest request);
}
