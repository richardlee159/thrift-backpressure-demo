#ifndef SOCIAL_NETWORK_MICROSERVICES_SRC_UTILS_THRIFT_H_
#define SOCIAL_NETWORK_MICROSERVICES_SRC_UTILS_THRIFT_H_

#include <string>
#include <nlohmann/json.hpp>
#include <thrift/transport/TServerSocket.h>

namespace social_network{
using json = nlohmann::json;
using apache::thrift::transport::TServerSocket;

std::shared_ptr<TServerSocket> get_server_socket(const json &config_json, const std::string &address, int port) {
  return std::make_shared<TServerSocket>(address, port);
};

} //namespace social_network

#endif //SOCIAL_NETWORK_MICROSERVICES_SRC_UTILS_THRIFT_H_
