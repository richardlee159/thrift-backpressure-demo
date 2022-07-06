namespace cpp social_network
namespace py social_network
namespace lua social_network

enum ErrorCode {
  SE_CONNPOOL_TIMEOUT,
  SE_THRIFT_CONN_ERROR,
  SE_UNAUTHORIZED,
  SE_THRIFT_HANDLER_ERROR,
}

exception ServiceException {
    1: ErrorCode errorCode;
    2: string message;
}

service TextService {
  string ComposeText (
    1: i64 req_id,
    2: string text,
  ) throws (1: ServiceException se)
}

service ComposePostService {
  void ComposePost(
    1: i64 req_id,
    2: string text,
  ) throws (1: ServiceException se)
}