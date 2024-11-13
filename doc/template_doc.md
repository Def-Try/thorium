# Class `ByteBuffer`
Class used to read and write binary data

## `ByteBuffer.Clear(self: ByteBuffer) -> self: ByteBuffer`
Clears buffer, removing all data from it

## `ByteBuffer.EndOfBuffer(self: ByteBuffer) -> endofbuffer: boolean`
Returns whether we are at the end of buffer or not

## `ByteBuffer.New(self: ByteBuffer, this: table?) -> ByteBuffer`
Creates new BitBuffer

## `ByteBuffer.ReadAngle(self: ByteBuffer) -> ang: Angle`
Reads angle. Reads 12 bytes

## `ByteBuffer.ReadBool(self: ByteBuffer) -> bool: boolean`
Reads a boolean. Reads 1 byte

## `ByteBuffer.ReadByte(self: ByteBuffer) -> num: integer`
Reads signed byte. Reads 1 byte

## `ByteBuffer.ReadColor(self: ByteBuffer) -> clr: Color`
Reads color. Reads 4 bytes

## `ByteBuffer.ReadDouble(self: ByteBuffer) -> x: number`
Reads double-precision float. Reads 8 bytes

## `ByteBuffer.ReadFloat(self: ByteBuffer) -> x: number`
Reads single-precision float. Reads 4 bytes

## `ByteBuffer.ReadInt(self: ByteBuffer) -> num: integer`
Reads signed integer. Reads 4 bytes

## `ByteBuffer.ReadRAW(self: ByteBuffer, amount: integer) -> data: string`
Reads raw data (string) from buffer

## `ByteBuffer.ReadShort(self: ByteBuffer) -> num: integer`
Reads signed short. Reads 2 bytes

## `ByteBuffer.ReadStringLP(self: ByteBuffer) -> str: string`
Reads length prefixed string. Reads #str + 2 bytes

## `ByteBuffer.ReadStringNT(self: ByteBuffer) -> str: string`
Reads null terminated string. Reads #str + 1 bytes

## `ByteBuffer.ReadTable(self: ByteBuffer) -> tbl: table`
Reads table from buffer. Reads variable amount of bytes

## `ByteBuffer.ReadType(self: ByteBuffer) -> v: any`
Attempts to read a variable type. Reads variable amount of bytes

## `ByteBuffer.ReadUByte(self: ByteBuffer) -> num: integer`
Reads unsigned byte. Reads 1 byte

## `ByteBuffer.ReadUInt(self: ByteBuffer) -> num: integer`
Reads unsigned integer. Reads 4 bytes

## `ByteBuffer.ReadUShort(self: ByteBuffer) -> num: integer`
Reads unsigned short. Reads 2 bytes

## `ByteBuffer.ReadVarInt(self: ByteBuffer) -> num: integer`
Reads VarInt. Reads variable amount of bytes

## `ByteBuffer.ReadVector(self: ByteBuffer) -> vec: Vector`
Reads vector. Reads 12 bytes

## `ByteBuffer.Seek(self: ByteBuffer, seek_to: integer) -> self: ByteBuffer`
Seeks (moves pointer) to a position in buffer.
On overflow goes over.

## `ByteBuffer.Size(self: ByteBuffer) -> size: integer`
Get size of buffer

## `ByteBuffer.Skip(self: ByteBuffer, bytes: integer) -> self: ByteBuffer`
Skips some amount of bytes, same as buffer:Seek(buffer:Tell()+bytes)

## `ByteBuffer.TYPETABLE_read: table`

## `ByteBuffer.TYPETABLE_write: table`

## `ByteBuffer.Tell(self: ByteBuffer) -> position: integer`
Tell the position of pointer in buffer

## `ByteBuffer.WriteAngle(self: ByteBuffer, ang: Angle) -> self: ByteBuffer`
Writes angle. Writes 12 bytes

## `ByteBuffer.WriteBool(self: ByteBuffer, bool: boolean) -> self: ByteBuffer`
Writes a boolean. Writes 1 byte

## `ByteBuffer.WriteByte(self: ByteBuffer, num: integer) -> self: ByteBuffer`
Writes signed byte. Writes 1 byte

## `ByteBuffer.WriteColor(self: ByteBuffer, clr: Color) -> self: ByteBuffer`
Writes color. Writes 4 bytes

## `ByteBuffer.WriteDouble(self: ByteBuffer, x: number) -> self: ByteBuffer`
Writes double-precision float. Writes 8 bytes

## `ByteBuffer.WriteFloat(self: ByteBuffer, x: number) -> self: ByteBuffer`
Writes single-precision float. Writes 4 bytes

## `ByteBuffer.WriteInt(self: ByteBuffer, num: integer) -> self: ByteBuffer`
Writes signed integer. Writes 4 bytes

## `ByteBuffer.WriteRAW(self: ByteBuffer, data: string) -> self: ByteBuffer`
Appends raw data (string) to buffer.

## `ByteBuffer.WriteShort(self: ByteBuffer, num: integer) -> self: ByteBuffer`
Writes signed short. Writes 2 bytes

## `ByteBuffer.WriteStringLP(self: ByteBuffer, str: string) -> self: ByteBuffer`
Writes length prefixed string. Writes #str + 2 bytes

## `ByteBuffer.WriteStringNT(self: ByteBuffer, str: string) -> self: ByteBuffer`
Writes null terminated string. Writes #str + 1 bytes

## `ByteBuffer.WriteTable(self: ByteBuffer, tbl: table) -> self: ByteBuffer`
Writes table to buffer. Writes variable amount of bytes

## `ByteBuffer.WriteType(self: ByteBuffer, v: any) -> self: ByteBuffer`
Attempts to write a variable type. Writes variable amount of bytes

## `ByteBuffer.WriteUByte(self: ByteBuffer, num: integer) -> self: ByteBuffer`
Writes unsigned byte. Writes 1 byte

## `ByteBuffer.WriteUInt(self: ByteBuffer, num: integer) -> self: ByteBuffer`
Writes unsigned integer. Writes 4 bytes

## `ByteBuffer.WriteUShort(self: ByteBuffer, num: integer) -> self: ByteBuffer`
Writes unsigned short. Writes 2 bytes

## `ByteBuffer.WriteVarInt(self: ByteBuffer, num: integer) -> self: ByteBuffer`
Writes VarInt. Writes variable amount of bytes

## `ByteBuffer.WriteVector(self: ByteBuffer, vec: Vector) -> self: ByteBuffer`
Writes vector. Writes 12 bytes

# Field `ByteBuffer: ByteBuffer`
Class used to read and write binary data

## `ByteBuffer.__len(self: ByteBuffer) -> size: integer`

## `ByteBuffer.__tostring(self: ByteBuffer) -> string`

## `ByteBuffer.data: string`

## `ByteBuffer.pointer: integer`

## `ByteBuffer.size: integer`



# Function `Debug(text: any, ...unknown) -> nil`
Same as printf, but appends a bunch of info about caller at the start

# Class `GColor`
Color utilities

# Field `GColor: unknown`

# Field `GColor: unknown`

## `GColor.FromHex(hexstring: string) -> Color`
Create color from a hex string

# Field `GColor: unknown`

# Field `GColor: unknown`

# Field `GColor: unknown`

# Field `GColor: unknown`

# Field `GColor: unknown`



# Class `GLocale`
A better localization module

## `GLocale.Add(placeholder: string, fulltext: string, lang: string|nil)`
Add a translation string

## `GLocale.GetStringTable() -> table`

## `GLocale.LoadFromFile(filepath: string, gamepath: string, lang: string|nil)`
Load translation strings from properties file

## `GLocale.Localize(text: string, lang: string|nil) -> Localized: string`
Localize string



# Class `GNWVars`
NetWork Variables utilities



# Class `GNet`
A better abstraction over default garrysmod net

## `GNet.Receive(message: string, callback: function)`
Adds a net message handler. Only one receiver can be used to receive the message <br>
Callback arguments: function(handle: NetHandle, size: integer, from: Player|Entity|nil)

## `GNet.Send(handle: ByteBuffer|NetHandle, target: string|Entity|Player, docompress: boolean?, dochunk: boolean?)`
Sends a NetHandle over network
If on client, and target is not set, set to Entity(0) or "SERVER" will send to server.
If on server, and target is set to "BROADCAST", will broadcast to everyone

## `GNet.Start(message: string) -> NetHandle`
Creates new NetHandle



# Class `GRandom`
Access point to Random objects

## `GRandom.New(seed: integer) -> Random`
Creates new Random object



# Function `Log(text: string, ...any) -> nil`
Same as printf, but appends addon name at the start

# Class `NetHandle`
## `NetHandle.Clear(self: ByteBuffer) -> self: ByteBuffer`
Clears buffer, removing all data from it

## `NetHandle.EndOfBuffer(self: ByteBuffer) -> endofbuffer: boolean`
Returns whether we are at the end of buffer or not

## `NetHandle.New(self: ByteBuffer, this: table?) -> ByteBuffer`
Creates new BitBuffer

## `NetHandle.ReadAngle(self: ByteBuffer) -> ang: Angle`
Reads angle. Reads 12 bytes

## `NetHandle.ReadBool(self: ByteBuffer) -> bool: boolean`
Reads a boolean. Reads 1 byte

## `NetHandle.ReadByte(self: ByteBuffer) -> num: integer`
Reads signed byte. Reads 1 byte

## `NetHandle.ReadColor(self: ByteBuffer) -> clr: Color`
Reads color. Reads 4 bytes

## `NetHandle.ReadDouble(self: ByteBuffer) -> x: number`
Reads double-precision float. Reads 8 bytes

## `NetHandle.ReadEntity(self: NetHandle, ent: any) -> ent: Entity`
Reads entity from buffer. Reads 2 bytes.

## `NetHandle.ReadFloat(self: ByteBuffer) -> x: number`
Reads single-precision float. Reads 4 bytes

## `NetHandle.ReadInt(self: ByteBuffer) -> num: integer`
Reads signed integer. Reads 4 bytes

## `NetHandle.ReadRAW(self: ByteBuffer, amount: integer) -> data: string`
Reads raw data (string) from buffer

## `NetHandle.ReadShort(self: ByteBuffer) -> num: integer`
Reads signed short. Reads 2 bytes

## `NetHandle.ReadStringLP(self: ByteBuffer) -> str: string`
Reads length prefixed string. Reads #str + 2 bytes

## `NetHandle.ReadStringNT(self: ByteBuffer) -> str: string`
Reads null terminated string. Reads #str + 1 bytes

## `NetHandle.ReadTable(self: ByteBuffer) -> tbl: table`
Reads table from buffer. Reads variable amount of bytes

## `NetHandle.ReadType(self: ByteBuffer) -> v: any`
Attempts to read a variable type. Reads variable amount of bytes

## `NetHandle.ReadUByte(self: ByteBuffer) -> num: integer`
Reads unsigned byte. Reads 1 byte

## `NetHandle.ReadUInt(self: ByteBuffer) -> num: integer`
Reads unsigned integer. Reads 4 bytes

## `NetHandle.ReadUShort(self: ByteBuffer) -> num: integer`
Reads unsigned short. Reads 2 bytes

## `NetHandle.ReadVarInt(self: ByteBuffer) -> num: integer`
Reads VarInt. Reads variable amount of bytes

## `NetHandle.ReadVector(self: ByteBuffer) -> vec: Vector`
Reads vector. Reads 12 bytes

## `NetHandle.Seek(self: ByteBuffer, seek_to: integer) -> self: ByteBuffer`
Seeks (moves pointer) to a position in buffer.
On overflow goes over.

## `NetHandle.Size(self: ByteBuffer) -> size: integer`
Get size of buffer

## `NetHandle.Skip(self: ByteBuffer, bytes: integer) -> self: ByteBuffer`
Skips some amount of bytes, same as buffer:Seek(buffer:Tell()+bytes)

## `NetHandle.TYPETABLE_read: table`

## `NetHandle.TYPETABLE_write: table`

## `NetHandle.Tell(self: ByteBuffer) -> position: integer`
Tell the position of pointer in buffer

## `NetHandle.WriteAngle(self: ByteBuffer, ang: Angle) -> self: ByteBuffer`
Writes angle. Writes 12 bytes

## `NetHandle.WriteBool(self: ByteBuffer, bool: boolean) -> self: ByteBuffer`
Writes a boolean. Writes 1 byte

## `NetHandle.WriteByte(self: ByteBuffer, num: integer) -> self: ByteBuffer`
Writes signed byte. Writes 1 byte

## `NetHandle.WriteColor(self: ByteBuffer, clr: Color) -> self: ByteBuffer`
Writes color. Writes 4 bytes

## `NetHandle.WriteDouble(self: ByteBuffer, x: number) -> self: ByteBuffer`
Writes double-precision float. Writes 8 bytes

## `NetHandle.WriteEntity(self: NetHandle, ent: Entity) -> self: ByteBuffer`
Writes entity to buffer. Writes 2 bytes.

## `NetHandle.WriteFloat(self: ByteBuffer, x: number) -> self: ByteBuffer`
Writes single-precision float. Writes 4 bytes

## `NetHandle.WriteInt(self: ByteBuffer, num: integer) -> self: ByteBuffer`
Writes signed integer. Writes 4 bytes

## `NetHandle.WriteRAW(self: ByteBuffer, data: string) -> self: ByteBuffer`
Appends raw data (string) to buffer.

## `NetHandle.WriteShort(self: ByteBuffer, num: integer) -> self: ByteBuffer`
Writes signed short. Writes 2 bytes

## `NetHandle.WriteStringLP(self: ByteBuffer, str: string) -> self: ByteBuffer`
Writes length prefixed string. Writes #str + 2 bytes

## `NetHandle.WriteStringNT(self: ByteBuffer, str: string) -> self: ByteBuffer`
Writes null terminated string. Writes #str + 1 bytes

## `NetHandle.WriteTable(self: ByteBuffer, tbl: table) -> self: ByteBuffer`
Writes table to buffer. Writes variable amount of bytes

## `NetHandle.WriteType(self: ByteBuffer, v: any) -> self: ByteBuffer`
Attempts to write a variable type. Writes variable amount of bytes

## `NetHandle.WriteUByte(self: ByteBuffer, num: integer) -> self: ByteBuffer`
Writes unsigned byte. Writes 1 byte

## `NetHandle.WriteUInt(self: ByteBuffer, num: integer) -> self: ByteBuffer`
Writes unsigned integer. Writes 4 bytes

## `NetHandle.WriteUShort(self: ByteBuffer, num: integer) -> self: ByteBuffer`
Writes unsigned short. Writes 2 bytes

## `NetHandle.WriteVarInt(self: ByteBuffer, num: integer) -> self: ByteBuffer`
Writes VarInt. Writes variable amount of bytes

## `NetHandle.WriteVector(self: ByteBuffer, vec: Vector) -> self: ByteBuffer`
Writes vector. Writes 12 bytes

# Field `NetHandle: ByteBuffer`
Class used to read and write binary data

## `NetHandle.__len(self: ByteBuffer) -> size: integer`

## `NetHandle.__tostring(self: NetHandle) -> string`

## `NetHandle.data: string`

## `NetHandle.message: string`

## `NetHandle.pointer: integer`

## `NetHandle.size: integer`



# Function `PrintTable(tbl: table, indent: integer, done: table)`
Prints table

# Class `Random`
## `Random.GetSeed(self: Random) -> number`
Get seed of Random object

## `Random.New(self: Random, seed: integer) -> Random`
Creates new Random object

## `Random.RandFloat(self: Random, min: number, max: number) -> number`
Generates random float in range from min to max
When max is not set, min argument becomes the max, and min is set to 0
When no arguments are specified, min becomes 0, max becomes 1

## `Random.RandInt(self: Random, min: number, max: number) -> number`
Generates random integer in range from min to max
When max is not set, min argument becomes the max, and min is set to 0
When no arguments are specified, min becomes 0, max becomes 1

## `Random.RandomFloat(self: Random) -> number`
Generates random number in range from 0 to 1

## `Random.SetSeed(self: Random, seed: integer) -> self: Random`
Set seed on Random object

# Field `Random: Random`

## `Random.__tostring(self: Random) -> string`



# Class `Thorium`
Thorium

# Field `Thorium: table`

## `Thorium.GetCapabilityVersion(capability: string) -> version: string`
Gets capability version

## `Thorium.HasCapability(capability: string) -> boolean`
Checks if Thorium has capability loaded

## `Thorium.LoadCapability(file: string, capability: string|nil, client: boolean|nil, cap_ver: string|nil) -> success: boolean, module_or_error: any`
Loads thorium capability

# Field `Thorium: string`

# Field `Thorium: GColor`
Color utilities

# Field `Thorium: gbuffer`
Access point to BitBuffer objects

# Field `Thorium: GLocale`
A better localization module

# Field `Thorium: GNet`
A better abstraction over default garrysmod net

# Field `Thorium: GRandom`
Access point to Random objects

# Field `Thorium: GNWVars`
NetWork Variables utilities



# Function `file.WhereIs(filepath: string, search_legacy: boolean|nil) -> owner: string|nil`
Tries to find the addon that owns a file

# Class `gbuffer`
Access point to BitBuffer objects

## `gbuffer.New(o: table?) -> ByteBuffer`
Creates new BitBuffer



# Function `math.Bezier(p0: number, p1: number, p2: number, t: number) -> number`
Performs Bezier Interpolation

# Function `math.BezierAngle(p0: Angle, p1: Angle, p2: Angle, t: number) -> Angle`
Performs Bezier Interpolation on Angles

# Function `math.BezierVector(p0: Vector, p1: Vector, p2: Vector, t: number) -> Vector`
Performs Bezier Interpolation on Vectors

# Function `printf(text: string, ...any) -> nil`
Similar to print, with the exception of that it automatically formats first string with arguments

# Field `thorium: Thorium`
Thorium

# Field `thorium.CAPABILITIES: table`

# Function `thorium.GetCapabilityVersion(capability: string) -> version: string`
Gets capability version

# Function `thorium.HasCapability(capability: string) -> boolean`
Checks if Thorium has capability loaded

# Function `thorium.LoadCapability(file: string, capability: string|nil, client: boolean|nil, cap_ver: string|nil) -> success: boolean, module_or_error: any`
Loads thorium capability

# Field `thorium.VERSION: string`

# Field `thorium.color: GColor`
Color utilities

# Field `thorium.gbuffer: gbuffer`
Access point to BitBuffer objects

# Field `thorium.glocale: GLocale`
A better localization module

# Field `thorium.gnet: GNet`
A better abstraction over default garrysmod net

# Field `thorium.grandom: GRandom`
Access point to Random objects

# Field `thorium.nwvars: GNWVars`
NetWork Variables utilities

### `ByteBuffer.WriteRAW(self: ByteBuffer) -> data: string`
Appends raw data (string) to buffer.

### `ByteBuffer.WriteBool(self: ByteBuffer, bool: boolean) -> self: ByteBuffer`
Writes a boolean. Writes 1 byte

### `ByteBuffer.WriteUByte(self: ByteBuffer, num: integer) -> self: ByteBuffer`
Writes unsigned byte. Writes 1 byte

### `ByteBuffer.WriteUShort(self: ByteBuffer, num: integer) -> self: ByteBuffer`
Writes unsigned short. Writes 2 bytes

### `ByteBuffer.WriteUInt(self: ByteBuffer, num: integer) -> self: ByteBuffer`
Writes unsigned integer. Writes 4 bytes

### `ByteBuffer.WriteByte(self: ByteBuffer, num: integer) -> self: ByteBuffer`
Writes signed byte. Writes 1 byte

### `ByteBuffer.WriteShort(self: ByteBuffer, num: integer) -> self: ByteBuffer`
Writes signed short. Writes 2 bytes

### `ByteBuffer.WriteInt(self: ByteBuffer, num: integer) -> self: ByteBuffer`
Writes signed integer. Writes 4 bytes

### `ByteBuffer.WriteVarInt(self: ByteBuffer, num: integer) -> self: ByteBuffer`
Writes VarInt. Writes variable amount of bytes

### `ByteBuffer.WriteFloat(self: ByteBuffer, x: number) -> self: ByteBuffer`
Writes single-precision float. Writes 4 bytes

### `ByteBuffer.WriteDouble(self: ByteBuffer, x: number) -> self: ByteBuffer`
Writes double-precision float. Writes 8 bytes

### `ByteBuffer.WriteStringLP(self: ByteBuffer, str: string) -> self: ByteBuffer`
Writes length prefixed string. Writes #str + 2 bytes

### `ByteBuffer.WriteStringNT(self: ByteBuffer, str: string) -> self: ByteBuffer`
Writes null terminated string. Writes #str + 1 bytes

### `ByteBuffer.WriteAngle(self: ByteBuffer, ang: Angle) -> self: ByteBuffer`
Writes angle. Writes 12 bytes

### `ByteBuffer.WriteColor(self: ByteBuffer, clr: Color) -> self: ByteBuffer`
Writes color. Writes 4 bytes

### `ByteBuffer.WriteVector(self: ByteBuffer, vec: Vector) -> self: ByteBuffer`
Writes vector. Writes 12 bytes

### `ByteBuffer.WriteTable(self: ByteBuffer, tbl: table) -> self: ByteBuffer`
Writes table to buffer. Writes variable amount of bytes

### `ByteBuffer.WriteType(self: ByteBuffer, v: any) -> self: ByteBuffer`
Attempts to write a variable type. Writes variable amount of bytes