#ifndef SOCIAL_NETWORK_MICROSERVICES_TEXTHANDLER_H
#define SOCIAL_NETWORK_MICROSERVICES_TEXTHANDLER_H

#include <iostream>
#include <regex>
#include <string>

#include "../../gen-cpp/TextService.h"
#include "../ClientPool.h"
#include "../ThriftClient.h"
#include "../logger.h"

namespace social_network {

class TextHandler : public TextServiceIf {
 public:
  TextHandler();
  ~TextHandler() override = default;

  void ComposeText(std::string &_return, int64_t, const std::string &) override;
};

TextHandler::TextHandler() {}

void TextHandler::ComposeText(
    std::string &_return, int64_t req_id, const std::string &text) {

  std::vector<std::string> mention_usernames;
  std::smatch m;
  std::regex e("@[a-zA-Z0-9-_]+");
  auto s = text;
  while (std::regex_search(s, m, e)) {
    auto user_mention = m.str();
    user_mention = user_mention.substr(1, user_mention.length());
    mention_usernames.emplace_back(user_mention);
    s = m.suffix().str();
  }

  std::vector<std::string> urls;
  e = "(http://|https://)([a-zA-Z0-9_!~*'().&=+$%-]+)";
  s = text;
  while (std::regex_search(s, m, e)) {
    auto url = m.str();
    urls.emplace_back(url);
    s = m.suffix().str();
  }

  for (int i = 0; i < 10000; i++) {
    text.find_first_of('a');
  }
  _return = text;
}

}  // namespace social_network

#endif  // SOCIAL_NETWORK_MICROSERVICES_TEXTHANDLER_H
