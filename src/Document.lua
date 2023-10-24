local Compression = require(script.Parent.Compression)
local freezeDeep = require(script.Parent.freezeDeep)
local Promise = require(script.Parent.Parent.Promise)

--[=[
	@class Document
]=]
local Document = {}
Document.__index = Document

function Document.new(collection, key, validate, lockId, data)
	return setmetatable({
		collection = collection,
		key = key,
		validate = validate,
		lockId = lockId,
		data = data,
		closed = false,
		callingBeforeClose = false,
	}, Document)
end

--[=[
	Returns the document's data.

	@return any
]=]
function Document:read()
	return self.data
end

--[=[
	Writes the document's data.

	:::warning
	Throws an error if the document was closed or if the data is invalid.
	:::

	@param data any
]=]
function Document:write(data)
	assert(not self.closed, "Cannot write to a closed document")
	assert(self.validate(data))

	freezeDeep(data)

	self.data = data
end

--[=[
	Saves the document's data. If the save is throttled and you call it multiple times, it will save only once with the latest data.

	:::warning
	Throws an error if the document was closed.
	:::

	@return Promise<()>
]=]
function Document:save()
	assert(not self.closed and not self.callingBeforeClose, "Cannot save a closed document")

	return self.collection.data:save(self.collection.dataStore, self.key, function(value)
		if value.lockId ~= self.lockId then
			return "fail", "The session lock was stolen"
		end

		local scheme, compressed = Compression.compress(self.data)

		value.compressionScheme = scheme
		value.data = compressed

		return "succeed", value
	end)
end

--[=[
	Saves the document and removes the session lock. The document is unusable after calling. If a save is currently in
	progress it will close the document instead.

	:::warning
	Throws an error if the document was closed.
	:::

	:::warning
	If the beforeClose callback errors, the returned promise will reject and the data will not be saved.
	:::

	@return Promise<()>
]=]
function Document:close()
	assert(not self.closed and not self.callingBeforeClose, "Cannot close a closed document")

	local promise = Promise.resolve()

	if self.beforeCloseCallback ~= nil then
		self.callingBeforeClose = true

		promise = Promise.new(function(resolve, reject)
			local ok, err = pcall(self.beforeCloseCallback)

			if not ok then
				reject(`beforeClose callback threw error: {tostring(err)}`)
			else
				resolve()
			end
		end)
	end

	return promise
		:finally(function()
			self.closed = true

			self.collection.openDocuments[self.key] = nil

			self.collection.autoSave:removeDocument(self)
		end)
		:andThen(function()
			return self.collection.data:save(self.collection.dataStore, self.key, function(value)
				if value.lockId ~= self.lockId then
					return "fail", "The session lock was stolen"
				end

				local scheme, compressed = Compression.compress(self.data)

				value.compressionScheme = scheme
				value.data = compressed
				value.lockId = nil

				return "succeed", value
			end)
		end)
end

--[=[
	Sets a callback that is run inside `document:close` before it saves. The document can be read and written to in the
	callback.

	:::warning
	Throws an error if it was called previously.
	:::

	@param callback () -> ()
]=]
function Document:beforeClose(callback)
	assert(self.beforeCloseCallback == nil, "Document:beforeClose can only be called once")

	self.beforeCloseCallback = callback
end

return Document
