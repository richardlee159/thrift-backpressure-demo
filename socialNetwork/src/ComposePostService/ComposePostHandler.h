#ifndef SOCIAL_NETWORK_MICROSERVICES_SRC_COMPOSEPOSTSERVICE_COMPOSEPOSTHANDLER_H_
#define SOCIAL_NETWORK_MICROSERVICES_SRC_COMPOSEPOSTSERVICE_COMPOSEPOSTHANDLER_H_

#include <chrono>
#include <future>
#include <iostream>
#include <nlohmann/json.hpp>
#include <string>
#include <vector>

#include "../../gen-cpp/ComposePostService.h"
#include "../../gen-cpp/TextService.h"
#include "../../gen-cpp/social_network_types.h"
#include "../ClientPool.h"
#include "../ThriftClient.h"
#include "../logger.h"

namespace social_network {

class ComposePostHandler : public ComposePostServiceIf {
 public:
  ComposePostHandler(ClientPool<ThriftClient<TextServiceClient>> *);
  ~ComposePostHandler() override = default;

  void ComposePost(int64_t req_id, const std::string &text) override;

 private:
  ClientPool<ThriftClient<TextServiceClient>> *_text_service_client_pool;

  std::string _ComposeTextHelper(int64_t req_id, const std::string &text);
};

ComposePostHandler::ComposePostHandler(
    ClientPool<ThriftClient<TextServiceClient>> *text_service_client_pool) {
  _text_service_client_pool = text_service_client_pool;
}

std::string ComposePostHandler::_ComposeTextHelper(
    int64_t req_id, const std::string &text) {
  auto text_client_wrapper = _text_service_client_pool->Pop();
  if (!text_client_wrapper) {
    ServiceException se;
    se.errorCode = ErrorCode::SE_THRIFT_CONN_ERROR;
    se.message = "Failed to connect to text-service";
    LOG(error) << se.message;
    ;
    throw se;
  }

  auto text_client = text_client_wrapper->GetClient();
  std::string _return_text;
  try {
    text_client->ComposeText(_return_text, req_id, text);
  } catch (...) {
    LOG(error) << "Failed to send compose-text to text-service";
    _text_service_client_pool->Remove(text_client_wrapper);
    throw;
  }
  _text_service_client_pool->Keepalive(text_client_wrapper);
  return _return_text;
}

void ComposePostHandler::ComposePost(
    const int64_t req_id, const std::string &text) {
  auto text_future =
      std::async(std::launch::async, &ComposePostHandler::_ComposeTextHelper,
                 this, req_id, text);

  auto text_return = text_future.get();
  for (int i = 0; i < 20000; i++) {
    text_return.find_first_of('.');
  }
}

}  // namespace social_network

#endif  // SOCIAL_NETWORK_MICROSERVICES_SRC_COMPOSEPOSTSERVICE_COMPOSEPOSTHANDLER_H_
