local _M = {}
local k8s_suffix = os.getenv("fqdn_suffix")
if (k8s_suffix == nil) then
  k8s_suffix = ""
end

local function _StrIsEmpty(s)
  return s == nil or s == ''
end

function _M.ComposePost()
  local ngx = ngx
  local cjson = require "cjson"

  local GenericObjectPool = require "GenericObjectPool"
  local social_network_ComposePostService = require "social_network_ComposePostService"
  local ComposePostServiceClient = social_network_ComposePostService.ComposePostServiceClient

  GenericObjectPool:setMaxTotal(512)

  local req_id = tonumber(string.sub(ngx.var.request_id, 0, 15), 16)


  ngx.req.read_body()
  local post = ngx.req.get_post_args()

  if (_StrIsEmpty(post.text)) then
    ngx.status = ngx.HTTP_BAD_REQUEST
    ngx.say("Incomplete arguments")
    ngx.log(ngx.ERR, "Incomplete arguments")
    ngx.exit(ngx.HTTP_BAD_REQUEST)
  end

  local status, ret

  local client = GenericObjectPool:connection(
      ComposePostServiceClient, "compose-post-service" .. k8s_suffix, 9090)

  status, ret = pcall(client.ComposePost, client, req_id, post.text)
  if not status then
    ngx.status = ngx.HTTP_INTERNAL_SERVER_ERROR
    if (ret.message) then
      ngx.say("compost_post failure: " .. ret.message)
      ngx.log(ngx.ERR, "compost_post failure: " .. ret.message)
    else
      ngx.say("compost_post failure: " .. ret)
      ngx.log(ngx.ERR, "compost_post failure: " .. ret)
    end
    client.iprot.trans:close()
    ngx.exit(ngx.status)
  end

  GenericObjectPool:returnConnection(client)
  ngx.status = ngx.HTTP_OK
  ngx.say("Successfully upload post")
  ngx.exit(ngx.status)
end

return _M