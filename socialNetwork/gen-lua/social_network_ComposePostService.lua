--
-- Autogenerated by Thrift
--
-- DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
-- @generated
--


Thrift = require 'Thrift'
TType = Thrift.TType
TMessageType = Thrift.TMessageType
__TObject = Thrift.__TObject
TApplicationException = Thrift.TApplicationException
__TClient = Thrift.__TClient
__TProcessor = Thrift.__TProcessor
ttype = Thrift.ttype
social_network_ttypes = require 'social_network_ttypes'
ServiceException = social_network_ttypes.ServiceException

ComposePostServiceClient = __TObject.new(__TClient, {
  __type = 'ComposePostServiceClient'
})

function ComposePostServiceClient:ComposePost(req_id, text)
  self:send_ComposePost(req_id, text)
  self:recv_ComposePost(req_id, text)
end

function ComposePostServiceClient:send_ComposePost(req_id, text)
  self.oprot:writeMessageBegin('ComposePost', TMessageType.CALL, self._seqid)
  local args = ComposePost_args:new{}
  args.req_id = req_id
  args.text = text
  args:write(self.oprot)
  self.oprot:writeMessageEnd()
  self.oprot.trans:flush()
end

function ComposePostServiceClient:recv_ComposePost(req_id, text)
  local fname, mtype, rseqid = self.iprot:readMessageBegin()
  if mtype == TMessageType.EXCEPTION then
    local x = TApplicationException:new{}
    x:read(self.iprot)
    self.iprot:readMessageEnd()
    error(x)
  end
  local result = ComposePost_result:new{}
  result:read(self.iprot)
  self.iprot:readMessageEnd()
end
ComposePostServiceIface = __TObject:new{
  __type = 'ComposePostServiceIface'
}


ComposePostServiceProcessor = __TObject.new(__TProcessor
, {
 __type = 'ComposePostServiceProcessor'
})

function ComposePostServiceProcessor:process(iprot, oprot, server_ctx)
  local name, mtype, seqid = iprot:readMessageBegin()
  local func_name = 'process_' .. name
  if not self[func_name] or ttype(self[func_name]) ~= 'function' then
    iprot:skip(TType.STRUCT)
    iprot:readMessageEnd()
    x = TApplicationException:new{
      errorCode = TApplicationException.UNKNOWN_METHOD
    }
    oprot:writeMessageBegin(name, TMessageType.EXCEPTION, seqid)
    x:write(oprot)
    oprot:writeMessageEnd()
    oprot.trans:flush()
  else
    self[func_name](self, seqid, iprot, oprot, server_ctx)
  end
end

function ComposePostServiceProcessor:process_ComposePost(seqid, iprot, oprot, server_ctx)
  local args = ComposePost_args:new{}
  local reply_type = TMessageType.REPLY
  args:read(iprot)
  iprot:readMessageEnd()
  local result = ComposePost_result:new{}
  local status, res = pcall(self.handler.ComposePost, self.handler, args.req_id, args.text)
  if not status then
    reply_type = TMessageType.EXCEPTION
    result = TApplicationException:new{message = res}
  elseif ttype(res) == 'ServiceException' then
    result.se = res
  else
    result.success = res
  end
  oprot:writeMessageBegin('ComposePost', reply_type, seqid)
  result:write(oprot)
  oprot:writeMessageEnd()
  oprot.trans:flush()
end

-- HELPER FUNCTIONS AND STRUCTURES

ComposePost_args = __TObject:new{
  req_id,
  text
}

function ComposePost_args:read(iprot)
  iprot:readStructBegin()
  while true do
    local fname, ftype, fid = iprot:readFieldBegin()
    if ftype == TType.STOP then
      break
    elseif fid == 1 then
      if ftype == TType.I64 then
        self.req_id = iprot:readI64()
      else
        iprot:skip(ftype)
      end
    elseif fid == 2 then
      if ftype == TType.STRING then
        self.text = iprot:readString()
      else
        iprot:skip(ftype)
      end
    else
      iprot:skip(ftype)
    end
    iprot:readFieldEnd()
  end
  iprot:readStructEnd()
end

function ComposePost_args:write(oprot)
  oprot:writeStructBegin('ComposePost_args')
  if self.req_id ~= nil then
    oprot:writeFieldBegin('req_id', TType.I64, 1)
    oprot:writeI64(self.req_id)
    oprot:writeFieldEnd()
  end
  if self.text ~= nil then
    oprot:writeFieldBegin('text', TType.STRING, 2)
    oprot:writeString(self.text)
    oprot:writeFieldEnd()
  end
  oprot:writeFieldStop()
  oprot:writeStructEnd()
end

ComposePost_result = __TObject:new{
  se
}

function ComposePost_result:read(iprot)
  iprot:readStructBegin()
  while true do
    local fname, ftype, fid = iprot:readFieldBegin()
    if ftype == TType.STOP then
      break
    elseif fid == 1 then
      if ftype == TType.STRUCT then
        self.se = ServiceException:new{}
        self.se:read(iprot)
      else
        iprot:skip(ftype)
      end
    else
      iprot:skip(ftype)
    end
    iprot:readFieldEnd()
  end
  iprot:readStructEnd()
end

function ComposePost_result:write(oprot)
  oprot:writeStructBegin('ComposePost_result')
  if self.se ~= nil then
    oprot:writeFieldBegin('se', TType.STRUCT, 1)
    self.se:write(oprot)
    oprot:writeFieldEnd()
  end
  oprot:writeFieldStop()
  oprot:writeStructEnd()
end

return {
  ComposePostServiceClient = ComposePostServiceClient
}