#include <signal.h>
#include <thrift/protocol/TBinaryProtocol.h>
#include <thrift/server/TThreadedServer.h>
#include <thrift/transport/TBufferTransports.h>
#include <thrift/transport/TServerSocket.h>

#include "../utils.h"
#include "../utils_thrift.h"
#include "ComposePostHandler.h"

using apache::thrift::protocol::TBinaryProtocolFactory;
using apache::thrift::server::TThreadedServer;
using apache::thrift::transport::TFramedTransportFactory;
using apache::thrift::transport::TServerSocket;
using namespace social_network;

void sigintHandler(int sig) { exit(EXIT_SUCCESS); }

int main(int argc, char *argv[]) {
  signal(SIGINT, sigintHandler);
  init_logger();

  json config_json;
  if (load_config_file("config/service-config.json", &config_json) != 0) {
    exit(EXIT_FAILURE);
  }

  int port = config_json["compose-post-service"]["port"];

  int text_port = config_json["text-service"]["port"];
  std::string text_addr = config_json["text-service"]["addr"];
  int text_conns = config_json["text-service"]["connections"];
  int text_timeout = config_json["text-service"]["timeout_ms"];
  int text_keepalive = config_json["text-service"]["keepalive_ms"];

  ClientPool<ThriftClient<TextServiceClient>> text_client_pool(
      "text-service-client", text_addr, text_port, 0, text_conns, text_timeout,
      text_keepalive, config_json);

  std::shared_ptr<TServerSocket> server_socket = get_server_socket(config_json, "0.0.0.0", port);
  TThreadedServer server(
      std::make_shared<ComposePostServiceProcessor>(
          std::make_shared<ComposePostHandler>(&text_client_pool)),
      server_socket,
      std::make_shared<TFramedTransportFactory>(),
      std::make_shared<TBinaryProtocolFactory>());
  LOG(info) << "Starting the compose-post-service server ...";
  server.serve();
}